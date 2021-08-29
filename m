Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517443FA99D
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhH2G5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2G5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E2B60F36;
        Sun, 29 Aug 2021 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630220189;
        bh=kIwpZ8GVPJbBJc6bHRmb8jC0lhzeFhCV0RZ08cDC0P0=;
        h=Subject:To:Cc:From:Date:From;
        b=hyU41tx4fwsJ1nrA4Je+BTyRX8CEVjGrOGV4tldAmMqfZ2a4EByl8DEIPFshWUQsf
         OzhdX8Y+Jxo4ktZMEo0kdmGEezKEPmSgHtwp8zdnrNl/5Ua6l9iNt+XUdSCFGEcZaH
         EiPS+nebajS8Yg4diJdZmHBnE92fRZYtgCCT1zwI=
Subject: FAILED: patch "[PATCH] net: stmmac: fix kernel panic due to NULL pointer dereference" failed to apply to 5.10-stable tree
To:     vee.khee.wong@linux.intel.com, davem@davemloft.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:56:21 +0200
Message-ID: <1630220181204200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82a44ae113b7b35850f4542f0443fcab221e376a Mon Sep 17 00:00:00 2001
From: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Date: Fri, 20 Aug 2021 21:26:22 +0800
Subject: [PATCH] net: stmmac: fix kernel panic due to NULL pointer dereference
 of plat->est

In the case of taprio offload is not enabled, the error handling path
causes a kernel crash due to kernel NULL pointer deference.

Fix this by adding check for NULL before attempt to access 'plat->est'
on the mutex_lock() call.

The following kernel panic is observed without this patch:

RIP: 0010:mutex_lock+0x10/0x20
Call Trace:
tc_setup_taprio+0x482/0x560 [stmmac]
kmem_cache_alloc_trace+0x13f/0x490
taprio_disable_offload.isra.0+0x9d/0x180 [sch_taprio]
taprio_destroy+0x6c/0x100 [sch_taprio]
qdisc_create+0x2e5/0x4f0
tc_modify_qdisc+0x126/0x740
rtnetlink_rcv_msg+0x12b/0x380
_raw_spin_lock_irqsave+0x19/0x40
_raw_spin_unlock_irqrestore+0x18/0x30
create_object+0x212/0x340
rtnl_calcit.isra.0+0x110/0x110
netlink_rcv_skb+0x50/0x100
netlink_unicast+0x191/0x230
netlink_sendmsg+0x243/0x470
sock_sendmsg+0x5e/0x60
____sys_sendmsg+0x20b/0x280
copy_msghdr_from_user+0x5c/0x90
__mod_memcg_state+0x87/0xf0
 ___sys_sendmsg+0x7c/0xc0
lru_cache_add+0x7f/0xa0
_raw_spin_unlock+0x16/0x30
wp_page_copy+0x449/0x890
handle_mm_fault+0x921/0xfc0
__sys_sendmsg+0x59/0xa0
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xa9
---[ end trace b1f19b24368a96aa ]---

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4f3b6437b114..8160087ee92f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -884,11 +884,13 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
-	mutex_lock(&priv->plat->est->lock);
-	priv->plat->est->enable = false;
-	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
-			     priv->plat->clk_ptp_rate);
-	mutex_unlock(&priv->plat->est->lock);
+	if (priv->plat->est) {
+		mutex_lock(&priv->plat->est->lock);
+		priv->plat->est->enable = false;
+		stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				     priv->plat->clk_ptp_rate);
+		mutex_unlock(&priv->plat->est->lock);
+	}
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,

