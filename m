Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B900E86A0B
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405160AbfHHTJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405158AbfHHTJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D0012173E;
        Thu,  8 Aug 2019 19:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291385;
        bh=wXX6c7v6ufyv8qeaTgGQyaBp4jZNRtKWBLXZWn0+ffU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPhVQ9uN62LdH8zVTgC4bqQwNlF9HHN23LujqBFU6w4Xpq8sviW0NnkpL+kwXpT5l
         8DYNPA4VjmP4yveW7eiEpoOs+be4iYVGa4LSswqlAWhvBSwj7d6oc+h2RuuecbhgA/
         5epw8kZy9Exx/1xBCvsuUWt8BKW0xmMFumSOd1vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 39/45] compat_ioctl: pppoe: fix PPPOEIOCSFWD handling
Date:   Thu,  8 Aug 2019 21:05:25 +0200
Message-Id: <20190808190456.059378702@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 055d88242a6046a1ceac3167290f054c72571cd9 ]

Support for handling the PPPOEIOCSFWD ioctl in compat mode was added in
linux-2.5.69 along with hundreds of other commands, but was always broken
sincen only the structure is compatible, but the command number is not,
due to the size being sizeof(size_t), or at first sizeof(sizeof((struct
sockaddr_pppox)), which is different on 64-bit architectures.

Guillaume Nault adds:

  And the implementation was broken until 2016 (see 29e73269aa4d ("pppoe:
  fix reference counting in PPPoE proxy")), and nobody ever noticed. I
  should probably have removed this ioctl entirely instead of fixing it.
  Clearly, it has never been used.

Fix it by adding a compat_ioctl handler for all pppoe variants that
translates the command number and then calls the regular ioctl function.

All other ioctl commands handled by pppoe are compatible between 32-bit
and 64-bit, and require compat_ptr() conversion.

This should apply to all stable kernels.

Acked-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pppoe.c  |    3 +++
 drivers/net/ppp/pppox.c  |   13 +++++++++++++
 drivers/net/ppp/pptp.c   |    3 +++
 fs/compat_ioctl.c        |    3 ---
 include/linux/if_pppox.h |    3 +++
 net/l2tp/l2tp_ppp.c      |    3 +++
 6 files changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1120,6 +1120,9 @@ static const struct proto_ops pppoe_ops
 	.recvmsg	= pppoe_recvmsg,
 	.mmap		= sock_no_mmap,
 	.ioctl		= pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppoe_proto = {
--- a/drivers/net/ppp/pppox.c
+++ b/drivers/net/ppp/pppox.c
@@ -22,6 +22,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/net.h>
@@ -103,6 +104,18 @@ int pppox_ioctl(struct socket *sock, uns
 
 EXPORT_SYMBOL(pppox_ioctl);
 
+#ifdef CONFIG_COMPAT
+int pppox_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	if (cmd == PPPOEIOCSFWD32)
+		cmd = PPPOEIOCSFWD;
+
+	return pppox_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+
+EXPORT_SYMBOL(pppox_compat_ioctl);
+#endif
+
 static int pppox_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
 {
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -633,6 +633,9 @@ static const struct proto_ops pptp_ops =
 	.recvmsg    = sock_no_recvmsg,
 	.mmap       = sock_no_mmap,
 	.ioctl      = pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppox_pptp_proto = {
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -894,9 +894,6 @@ COMPATIBLE_IOCTL(PPPIOCDISCONN)
 COMPATIBLE_IOCTL(PPPIOCATTCHAN)
 COMPATIBLE_IOCTL(PPPIOCGCHAN)
 COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
-/* PPPOX */
-COMPATIBLE_IOCTL(PPPOEIOCSFWD)
-COMPATIBLE_IOCTL(PPPOEIOCDFWD)
 /* Big A */
 /* sparc only */
 /* Big Q for sound/OSS */
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -84,6 +84,9 @@ extern int register_pppox_proto(int prot
 extern void unregister_pppox_proto(int proto_num);
 extern void pppox_unbind_sock(struct sock *sk);/* delete ppp-channel binding */
 extern int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+extern int pppox_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+
+#define PPPOEIOCSFWD32    _IOW(0xB1 ,0, compat_size_t)
 
 /* PPPoX socket states */
 enum {
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1686,6 +1686,9 @@ static const struct proto_ops pppol2tp_o
 	.recvmsg	= pppol2tp_recvmsg,
 	.mmap		= sock_no_mmap,
 	.ioctl		= pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppol2tp_proto = {


