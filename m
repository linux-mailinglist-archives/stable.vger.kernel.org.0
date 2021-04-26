Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90AB36ACEE
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhDZHb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhDZHb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90CF61041;
        Mon, 26 Apr 2021 07:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422246;
        bh=DVXXAnLoVWgZ+1YCkGZuJAOvDooxlpbEBfviWDTW2Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VobeJ3cqEGkeHZrs6IU13k46tU+pI0bW/SysdJ48PubcWEqAtiGwhNEtdn8BEfE89
         b9atSaxba/BVqDZO9hjGK22L8YCCCfeXz0c7vjylbH+6OsBKIcYo3sgYweGzsmY7mv
         aChMjifQeHa9R/OC8hFWYn2b3XkGJjcZYGZNiqjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 01/32] net/sctp: fix race condition in sctp_destroy_sock
Date:   Mon, 26 Apr 2021 09:28:59 +0200
Message-Id: <20210426072816.631201988@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

commit b166a20b07382b8bc1dcee2a448715c9c2c81b5b upstream.

If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
held and sp->do_auto_asconf is true, then an element is removed
from the auto_asconf_splist without any proper locking.

This can happen in the following functions:
1. In sctp_accept, if sctp_sock_migrate fails.
2. In inet_create or inet6_create, if there is a bpf program
   attached to BPF_CGROUP_INET_SOCK_CREATE which denies
   creation of the sctp socket.

The bug is fixed by acquiring addr_wq_lock in sctp_destroy_sock
instead of sctp_close.

This addresses CVE-2021-23133.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1567,11 +1567,9 @@ static void sctp_close(struct sock *sk,
 
 	/* Supposedly, no process has access to the socket, but
 	 * the net layers still may.
-	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
-	 * held and that should be grabbed before socket lock.
 	 */
-	spin_lock_bh(&net->sctp.addr_wq_lock);
-	bh_lock_sock_nested(sk);
+	local_bh_disable();
+	bh_lock_sock(sk);
 
 	/* Hold the sock, since sk_common_release() will put sock_put()
 	 * and we have just a little more cleanup.
@@ -1580,7 +1578,7 @@ static void sctp_close(struct sock *sk,
 	sk_common_release(sk);
 
 	bh_unlock_sock(sk);
-	spin_unlock_bh(&net->sctp.addr_wq_lock);
+	local_bh_enable();
 
 	sock_put(sk);
 
@@ -4161,9 +4159,6 @@ static int sctp_init_sock(struct sock *s
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	/* Nothing can fail after this block, otherwise
-	 * sctp_destroy_sock() will be called without addr_wq_lock held
-	 */
 	if (net->sctp.default_auto_asconf) {
 		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
 		list_add_tail(&sp->auto_asconf_list,
@@ -4198,7 +4193,9 @@ static void sctp_destroy_sock(struct soc
 
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
+		spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 		list_del(&sp->auto_asconf_list);
+		spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	}
 	sctp_endpoint_free(sp->ep);
 	local_bh_disable();


