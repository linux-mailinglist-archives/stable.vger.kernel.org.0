Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1245538A963
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhETLBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239544AbhETK7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 313BE61D03;
        Thu, 20 May 2021 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504978;
        bh=gBf7JQuiMchMJMj27SI9YlCqZIKfXup9TmY+DS1xi7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yopqikVFOOTbK4iFFKo2PgUhCDMl7PWJQJc5qnA8aVABvlrW/JUFh0IZVXlOflCU3
         +BB4xgP3+zjG8E278u4RYKjhu15xNWklEWYr+cWCnJ0laYi7kfUy5dQINfuGK6Abkq
         JYwJ1mUmB7BQTikW48fR/6no9L5xuAAhW+kH26Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 167/240] sctp: delay auto_asconf init until binding the first addr
Date:   Thu, 20 May 2021 11:22:39 +0200
Message-Id: <20210520092114.249703783@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 34e5b01186858b36c4d7c87e1a025071e8e2401f upstream.

As Or Cohen described:

  If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
  held and sp->do_auto_asconf is true, then an element is removed
  from the auto_asconf_splist without any proper locking.

  This can happen in the following functions:
  1. In sctp_accept, if sctp_sock_migrate fails.
  2. In inet_create or inet6_create, if there is a bpf program
     attached to BPF_CGROUP_INET_SOCK_CREATE which denies
     creation of the sctp socket.

This patch is to fix it by moving the auto_asconf init out of
sctp_init_sock(), by which inet_create()/inet6_create() won't
need to operate it in sctp_destroy_sock() when calling
sk_common_release().

It also makes more sense to do auto_asconf init while binding the
first addr, as auto_asconf actually requires an ANY addr bind,
see it in sctp_addr_wq_timeout_handler().

This addresses CVE-2021-23133.

Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -367,6 +367,18 @@ static struct sctp_af *sctp_sockaddr_af(
 	return af;
 }
 
+static void sctp_auto_asconf_init(struct sctp_sock *sp)
+{
+	struct net *net = sock_net(&sp->inet.sk);
+
+	if (net->sctp.default_auto_asconf) {
+		spin_lock(&net->sctp.addr_wq_lock);
+		list_add_tail(&sp->auto_asconf_list, &net->sctp.auto_asconf_splist);
+		spin_unlock(&net->sctp.addr_wq_lock);
+		sp->do_auto_asconf = 1;
+	}
+}
+
 /* Bind a local address either to an endpoint or to an association.  */
 static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 {
@@ -429,8 +441,10 @@ static int sctp_do_bind(struct sock *sk,
 	}
 
 	/* Refresh ephemeral port.  */
-	if (!bp->port)
+	if (!bp->port) {
 		bp->port = inet_sk(sk)->inet_num;
+		sctp_auto_asconf_init(sp);
+	}
 
 	/* Add the address to the bind address list.
 	 * Use GFP_ATOMIC since BHs will be disabled.
@@ -4262,19 +4276,6 @@ static int sctp_init_sock(struct sock *s
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	/* Nothing can fail after this block, otherwise
-	 * sctp_destroy_sock() will be called without addr_wq_lock held
-	 */
-	if (net->sctp.default_auto_asconf) {
-		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
-		list_add_tail(&sp->auto_asconf_list,
-		    &net->sctp.auto_asconf_splist);
-		sp->do_auto_asconf = 1;
-		spin_unlock(&sock_net(sk)->sctp.addr_wq_lock);
-	} else {
-		sp->do_auto_asconf = 0;
-	}
-
 	local_bh_enable();
 
 	return 0;
@@ -7817,6 +7818,8 @@ static void sctp_sock_migrate(struct soc
 	sctp_bind_addr_dup(&newsp->ep->base.bind_addr,
 				&oldsp->ep->base.bind_addr, GFP_KERNEL);
 
+	sctp_auto_asconf_init(newsp);
+
 	/* Move any messages in the old socket's receive queue that are for the
 	 * peeled off association to the new socket's receive queue.
 	 */


