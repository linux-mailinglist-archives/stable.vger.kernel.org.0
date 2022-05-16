Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65C5290A8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346685AbiEPTz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbiEPTvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AA440A32;
        Mon, 16 May 2022 12:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ABB1B81611;
        Mon, 16 May 2022 19:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9B4C36AE7;
        Mon, 16 May 2022 19:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730430;
        bh=vUL0Aa1xEyJ5w91JIkpV0ws4cYYwzEznOgcrqrQatNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMdZ2f405eWeWVIbmJsxkqygoqXCEbdJg/9r5juZRad66V0dPrjm4H9yoT88oiILT
         Ma2uq5yKboL3Ji2HoUrfg3izsCgZsx9VsR4ak1y44I+FktXGY3WU3IN+A6FQTdQG2q
         ghSONojciNLn0iFZZiiLjoWvbQSDBWovwIW6Bumo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 62/66] net: phy: Fix race condition on link status change
Date:   Mon, 16 May 2022 21:37:02 +0200
Message-Id: <20220516193621.204866621@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 91a7cda1f4b8bdf770000a3b60640576dafe0cec upstream.

This fixes the following error caused by a race condition between
phydev->adjust_link() and a MDIO transaction in the phy interrupt
handler. The issue was reproduced with the ethernet FEC driver and a
micrel KSZ9031 phy.

[  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
[  146.201779] ------------[ cut here ]------------
[  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
[  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
[  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
[  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  146.236257]  unwind_backtrace from show_stack+0x10/0x14
[  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
[  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
[  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
[  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
[  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
[  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
[  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
[  146.279605]  irq_thread from kthread+0xe4/0x104
[  146.284267]  kthread from ret_from_fork+0x14/0x28
[  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
[  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
[  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  146.318262] irq event stamp: 12325
[  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
[  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
[  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
[  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
[  146.354447] ---[ end trace 0000000000000000 ]---

With the FEC driver phydev->adjust_link() calls fec_enet_adjust_link()
calls fec_stop()/fec_restart() and both these function reset and
temporary disable the FEC disrupting any MII transaction that
could be happening at the same time.

fec_enet_adjust_link() and phy_read() can be running at the same time
when we have one additional interrupt before the phy_state_machine() is
able to terminate.

Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
                           |
                           | phy_interrupt()            <-- PHY IRQ
                           |  handle_interrupt()
                           |   phy_read()
                           |   phy_trigger_machine()
                           |    --> schedule phylib WQ
                           |
                           |
phy_state_machine()        |
 phy_check_link_status()   |
  phy_link_change()        |
   phydev->adjust_link()   |
    fec_enet_adjust_link() |
     --> FEC reset         | phy_interrupt()            <-- PHY IRQ
                           |  phy_read()
                           |

Fix this by acquiring the phydev lock in phy_interrupt().

Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
cc: <stable@vger.kernel.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220506060815.327382-1-francesco.dolcini@toradex.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[fd: backport: adapt locking before did_interrupt()/ack_interrupt()
 callbacks removal ]
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -124,10 +124,15 @@ EXPORT_SYMBOL(phy_print_status);
  */
 static int phy_clear_interrupt(struct phy_device *phydev)
 {
-	if (phydev->drv->ack_interrupt)
-		return phydev->drv->ack_interrupt(phydev);
+	int ret = 0;
 
-	return 0;
+	if (phydev->drv->ack_interrupt) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->ack_interrupt(phydev);
+		mutex_unlock(&phydev->lock);
+	}
+
+	return ret;
 }
 
 /**
@@ -982,6 +987,36 @@ int phy_disable_interrupts(struct phy_de
 }
 
 /**
+ * phy_did_interrupt - Checks if the PHY generated an interrupt
+ * @phydev: target phy_device struct
+ */
+static int phy_did_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->did_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+/**
+ * phy_handle_interrupt - Handle PHY interrupt
+ * @phydev: target phy_device struct
+ */
+static irqreturn_t phy_handle_interrupt(struct phy_device *phydev)
+{
+	irqreturn_t ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->handle_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+/**
  * phy_interrupt - PHY interrupt handler
  * @irq: interrupt line
  * @phy_dat: phy_device pointer
@@ -994,9 +1029,9 @@ static irqreturn_t phy_interrupt(int irq
 	struct phy_driver *drv = phydev->drv;
 
 	if (drv->handle_interrupt)
-		return drv->handle_interrupt(phydev);
+		return phy_handle_interrupt(phydev);
 
-	if (drv->did_interrupt && !drv->did_interrupt(phydev))
+	if (drv->did_interrupt && !phy_did_interrupt(phydev))
 		return IRQ_NONE;
 
 	/* reschedule state queue work to run as soon as possible */


