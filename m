Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB75A82E29
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfHFIwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 04:52:41 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:17886 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729987AbfHFIwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 04:52:41 -0400
X-IronPort-AV: E=Sophos;i="5.64,352,1559487600"; 
   d="scan'208";a="23240851"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 06 Aug 2019 17:52:38 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 79DEF4009423;
        Tue,  6 Aug 2019 17:52:38 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current
Date:   Tue,  6 Aug 2019 17:51:19 +0900
Message-Id: <1565081479-24340-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The hardware manual should be revised, but the initial value of
VBCTRL.OCCLREN is set to 1 actually. If the bit is set, the hardware
clears VBCTRL.VBOUT and ADPCTRL.DRVVBUS registers automatically
when the hardware detects over-current signal from a USB power switch.
However, since the hardware doesn't have any registers which
indicates over-current, the driver cannot handle it at all. So, if
"is_otg_channel" hardware detects over-current, since ADPCTRL.DRVVBUS
register is cleared automatically, the channel cannot be used after
that.

To resolve this behavior, this patch sets the VBCTRL.OCCLREN to 0
to keep ADPCTRL.DRVVBUS even if the "is_otg_channel" hardware
detects over-current. (We assume a USB power switch itself protects
over-current and turns the VBUS off.)

This patch is inspired by a BSP patch from Kazuya Mizuguchi.

Fixes: 1114e2d31731 ("phy: rcar-gen3-usb2: change the mode to OTG on the combined channel")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 This patch might be difficult to backport to v4.9 or older because
 the v4.13 added vendor specific directories by commit
 0b56e9a7e835 ("phy: Group vendor specific phy drivers").


 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 8ffba67..b7f6b13 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -61,6 +61,7 @@
 					 USB2_OBINT_IDDIGCHG)
 
 /* VBCTRL */
+#define USB2_VBCTRL_OCCLREN		BIT(16)
 #define USB2_VBCTRL_DRVVBUSSEL		BIT(8)
 
 /* LINECTRL1 */
@@ -374,6 +375,7 @@ static void rcar_gen3_init_otg(struct rcar_gen3_chan *ch)
 	writel(val, usb2_base + USB2_LINECTRL1);
 
 	val = readl(usb2_base + USB2_VBCTRL);
+	val &= ~USB2_VBCTRL_OCCLREN;
 	writel(val | USB2_VBCTRL_DRVVBUSSEL, usb2_base + USB2_VBCTRL);
 	val = readl(usb2_base + USB2_ADPCTRL);
 	writel(val | USB2_ADPCTRL_IDPULLUP, usb2_base + USB2_ADPCTRL);
-- 
2.7.4

