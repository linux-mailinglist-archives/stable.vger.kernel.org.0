Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CEC1E2EEB
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389232AbgEZS5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390011AbgEZS5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FAC20849;
        Tue, 26 May 2020 18:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519428;
        bh=n/NqSZUexd3WmAYJCy5QjSeuALoNAEoTCx58MVGOB5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfSbckdJOnTqUsvxfEQo4EVaeCbkFMQ8CDmvsF+HtHk6rsHA5vJcTor/kto5f7od/
         HPplY9xDnwuTlLbLFweH/MtGZpDD/WOriiNd7djYpd2xcO9JbKgTfPYY/98HAMAWo7
         HpwiHn2R68Ict/daoHwFvKIalQWursHpuUi5GUyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "R. Parameswaran" <rparames@brocade.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 65/65] l2tp: device MTU setup, tunnel socket needs a lock
Date:   Tue, 26 May 2020 20:53:24 +0200
Message-Id: <20200526183929.373249014@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: R. Parameswaran <parameswaran.r7@gmail.com>

commit 57240d007816486131bee88cd474c2a71f0fe224 upstream.

The MTU overhead calculation in L2TP device set-up
merged via commit b784e7ebfce8cfb16c6f95e14e8532d0768ab7ff
needs to be adjusted to lock the tunnel socket while
referencing the sub-data structures to derive the
socket's IP overhead.

Reported-by: Guillaume Nault <g.nault@alphalink.fr>
Tested-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: R. Parameswaran <rparames@brocade.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/net.h |    2 +-
 net/l2tp/l2tp_eth.c |    2 ++
 net/socket.c        |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -291,7 +291,7 @@ int kernel_sendpage(struct socket *sock,
 int kernel_sock_ioctl(struct socket *sock, int cmd, unsigned long arg);
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how);
 
-/* Following routine returns the IP overhead imposed by a socket.  */
+/* Routine returns the IP overhead imposed by a (caller-protected) socket. */
 u32 kernel_sock_ip_overhead(struct sock *sk);
 
 #define MODULE_ALIAS_NETPROTO(proto) \
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -240,7 +240,9 @@ static void l2tp_eth_adjust_mtu(struct l
 		dev->needed_headroom += session->hdr_len;
 		return;
 	}
+	lock_sock(tunnel->sock);
 	l3_overhead = kernel_sock_ip_overhead(tunnel->sock);
+	release_sock(tunnel->sock);
 	if (l3_overhead == 0) {
 		/* L3 Overhead couldn't be identified, this could be
 		 * because tunnel->sock was NULL or the socket's
--- a/net/socket.c
+++ b/net/socket.c
@@ -3308,7 +3308,7 @@ EXPORT_SYMBOL(kernel_sock_shutdown);
 /* This routine returns the IP overhead imposed by a socket i.e.
  * the length of the underlying IP header, depending on whether
  * this is an IPv4 or IPv6 socket and the length from IP options turned
- * on at the socket.
+ * on at the socket. Assumes that the caller has a lock on the socket.
  */
 u32 kernel_sock_ip_overhead(struct sock *sk)
 {


