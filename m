Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C782C0BA9
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgKWN2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbgKWMa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BBB920728;
        Mon, 23 Nov 2020 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134626;
        bh=9/ESZs/RaSsKWgxuQVvkyVD8XDF9tVstZa76j+Ga6R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrqJ20V2iz3dWKgtoRTjklRzcQt1lnUu+G/IjBCHLk/WHYZGGqGcCY3biLgXt87RP
         Jq96UYtl9g6IIQ8azeMijhlpiTyEu8LDiHJpriwyd8I81v8ZWfmTiePWu7xDS+kMzi
         DFLgwdv/iMeuxgj3FdgIiThSxrTVJlqupe5ZC5EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 25/91] net/ncsi: Fix netlink registration
Date:   Mon, 23 Nov 2020 13:21:45 +0100
Message-Id: <20201123121810.542023213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 1922a46b8c18cb09d33e06a6cc2e43844ac1b9d0 ]

If a user unbinds and re-binds a NC-SI aware driver the kernel will
attempt to register the netlink interface at runtime. The structure is
marked __ro_after_init so registration fails spectacularly at this point.

 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/bind
  ftgmac100 1e660000.ethernet: Read MAC address 52:54:00:12:34:56 from chip
  ftgmac100 1e660000.ethernet: Using NCSI interface
  8<--- cut here ---
  Unable to handle kernel paging request at virtual address 80a8f858
  pgd = 8c768dd6
  [80a8f858] *pgd=80a0841e(bad)
  Internal error: Oops: 80d [#1] SMP ARM
  CPU: 0 PID: 116 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00003-gdd25b227ec1e #51
  Hardware name: Generic DT based system
  PC is at genl_register_family+0x1f8/0x6d4
  LR is at 0xff26ffff
  pc : [<8073f930>]    lr : [<ff26ffff>]    psr: 20000153
  sp : 8553bc80  ip : 81406244  fp : 8553bd04
  r10: 8085d12c  r9 : 80a8f73c  r8 : 85739000
  r7 : 00000017  r6 : 80a8f860  r5 : 80c8ab98  r4 : 80a8f858
  r3 : 00000000  r2 : 00000000  r1 : 81406130  r0 : 00000017
  Flags: nzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 00c5387d  Table: 85524008  DAC: 00000051
  Process sh (pid: 116, stack limit = 0x1f1988d6)
 ...
  Backtrace:
  [<8073f738>] (genl_register_family) from [<80860ac0>] (ncsi_init_netlink+0x20/0x48)
   r10:8085d12c r9:80c8fb0c r8:85739000 r7:00000000 r6:81218000 r5:85739000
   r4:8121c000
  [<80860aa0>] (ncsi_init_netlink) from [<8085d740>] (ncsi_register_dev+0x1b0/0x210)
   r5:8121c400 r4:8121c000
  [<8085d590>] (ncsi_register_dev) from [<805a8060>] (ftgmac100_probe+0x6e0/0x778)
   r10:00000004 r9:80950228 r8:8115bc10 r7:8115ab00 r6:9eae2c24 r5:813b6f88
   r4:85739000
  [<805a7980>] (ftgmac100_probe) from [<805355ec>] (platform_drv_probe+0x58/0xa8)
   r9:80c76bb0 r8:00000000 r7:80cd4974 r6:80c76bb0 r5:8115bc10 r4:00000000
  [<80535594>] (platform_drv_probe) from [<80532d58>] (really_probe+0x204/0x514)
   r7:80cd4974 r6:00000000 r5:80cd4868 r4:8115bc10

Jakub pointed out that ncsi_register_dev is obviously broken, because
there is only one family so it would never work if there was more than
one ncsi netdev.

Fix the crash by registering the netlink family once on boot, and drop
the code to unregister it.

Fixes: 955dc68cb9b2 ("net/ncsi: Add generic netlink family")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Link: https://lore.kernel.org/r/20201112061210.914621-1-joel@jms.id.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-manage.c  |    5 -----
 net/ncsi/ncsi-netlink.c |   22 +++-------------------
 net/ncsi/ncsi-netlink.h |    3 ---
 3 files changed, 3 insertions(+), 27 deletions(-)

--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1484,9 +1484,6 @@ struct ncsi_dev *ncsi_register_dev(struc
 	ndp->ptype.dev = dev;
 	dev_add_pack(&ndp->ptype);
 
-	/* Set up generic netlink interface */
-	ncsi_init_netlink(dev);
-
 	return nd;
 }
 EXPORT_SYMBOL_GPL(ncsi_register_dev);
@@ -1566,8 +1563,6 @@ void ncsi_unregister_dev(struct ncsi_dev
 #endif
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
-	ncsi_unregister_netlink(nd->dev);
-
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -397,24 +397,8 @@ static struct genl_family ncsi_genl_fami
 	.n_ops = ARRAY_SIZE(ncsi_ops),
 };
 
-int ncsi_init_netlink(struct net_device *dev)
+static int __init ncsi_init_netlink(void)
 {
-	int rc;
-
-	rc = genl_register_family(&ncsi_genl_family);
-	if (rc)
-		netdev_err(dev, "ncsi: failed to register netlink family\n");
-
-	return rc;
-}
-
-int ncsi_unregister_netlink(struct net_device *dev)
-{
-	int rc;
-
-	rc = genl_unregister_family(&ncsi_genl_family);
-	if (rc)
-		netdev_err(dev, "ncsi: failed to unregister netlink family\n");
-
-	return rc;
+	return genl_register_family(&ncsi_genl_family);
 }
+subsys_initcall(ncsi_init_netlink);
--- a/net/ncsi/ncsi-netlink.h
+++ b/net/ncsi/ncsi-netlink.h
@@ -14,7 +14,4 @@
 
 #include "internal.h"
 
-int ncsi_init_netlink(struct net_device *dev);
-int ncsi_unregister_netlink(struct net_device *dev);
-
 #endif /* __NCSI_NETLINK_H__ */


