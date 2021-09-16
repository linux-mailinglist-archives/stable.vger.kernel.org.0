Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3284940E848
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353950AbhIPRoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354952AbhIPRkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A1561244;
        Thu, 16 Sep 2021 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811092;
        bh=duPwwRI/sNDMgI0iJIvYfwe7W+VcfgeQB0WN2/IEVJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHvZYye9erEm22/FisdmhxP+xPal7y7+xviTgzEebl4uWyHE4v8yI2PnqWWhO7/6E
         svJw1ifU7xUSQZY4xyD2VGdh2qqThY5wDsmTEMzXhD9XttgnewIdq76sJSLAo/yKLm
         eNFO8BbGvAQzM8IE9jvaJ5WoKNOHXKVfizR38O+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 381/432] usb: isp1760: otg control register access
Date:   Thu, 16 Sep 2021 18:02:10 +0200
Message-Id: <20210916155823.730202342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit 9c1587d99f9305aa4f10b47fcf1981012aa5381f ]

The set/clear of the otg control values is done writing to
two different 16bit registers, however we setup the regmap
width for isp1760/61 to 32bit value bits.

So, just access the clear register address (0x376)as the high
part of the otg control register set (0x374), and write the
values in one go to make sure they get clear/set.

Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210827131154.4151862-6-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/isp1760/isp1760-core.c | 50 ++++++++++++++++--------------
 drivers/usb/isp1760/isp1760-regs.h | 16 ++++++++++
 2 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/isp1760/isp1760-core.c b/drivers/usb/isp1760/isp1760-core.c
index ff07e2890692..1f2ca22384b0 100644
--- a/drivers/usb/isp1760/isp1760-core.c
+++ b/drivers/usb/isp1760/isp1760-core.c
@@ -30,6 +30,7 @@ static int isp1760_init_core(struct isp1760_device *isp)
 {
 	struct isp1760_hcd *hcd = &isp->hcd;
 	struct isp1760_udc *udc = &isp->udc;
+	u32 otg_ctrl;
 
 	/* Low-level chip reset */
 	if (isp->rst_gpio) {
@@ -83,16 +84,17 @@ static int isp1760_init_core(struct isp1760_device *isp)
 	 *
 	 * TODO: Really support OTG. For now we configure port 1 in device mode
 	 */
-	if (((isp->devflags & ISP1760_FLAG_ISP1761) ||
-	     (isp->devflags & ISP1760_FLAG_ISP1763)) &&
-	    (isp->devflags & ISP1760_FLAG_PERIPHERAL_EN)) {
-		isp1760_field_set(hcd->fields, HW_DM_PULLDOWN);
-		isp1760_field_set(hcd->fields, HW_DP_PULLDOWN);
-		isp1760_field_set(hcd->fields, HW_OTG_DISABLE);
-	} else {
-		isp1760_field_set(hcd->fields, HW_SW_SEL_HC_DC);
-		isp1760_field_set(hcd->fields, HW_VBUS_DRV);
-		isp1760_field_set(hcd->fields, HW_SEL_CP_EXT);
+	if (isp->devflags & ISP1760_FLAG_ISP1761) {
+		if (isp->devflags & ISP1760_FLAG_PERIPHERAL_EN) {
+			otg_ctrl = (ISP176x_HW_DM_PULLDOWN_CLEAR |
+				    ISP176x_HW_DP_PULLDOWN_CLEAR |
+				    ISP176x_HW_OTG_DISABLE);
+		} else {
+			otg_ctrl = (ISP176x_HW_SW_SEL_HC_DC_CLEAR |
+				    ISP176x_HW_VBUS_DRV |
+				    ISP176x_HW_SEL_CP_EXT);
+		}
+		isp1760_reg_write(hcd->regs, ISP176x_HC_OTG_CTRL, otg_ctrl);
 	}
 
 	dev_info(isp->dev, "%s bus width: %u, oc: %s\n",
@@ -235,20 +237,20 @@ static const struct reg_field isp1760_hc_reg_fields[] = {
 	[HC_ISO_IRQ_MASK_AND]	= REG_FIELD(ISP176x_HC_ISO_IRQ_MASK_AND, 0, 31),
 	[HC_INT_IRQ_MASK_AND]	= REG_FIELD(ISP176x_HC_INT_IRQ_MASK_AND, 0, 31),
 	[HC_ATL_IRQ_MASK_AND]	= REG_FIELD(ISP176x_HC_ATL_IRQ_MASK_AND, 0, 31),
-	[HW_OTG_DISABLE]	= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 10, 10),
-	[HW_SW_SEL_HC_DC]	= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 7, 7),
-	[HW_VBUS_DRV]		= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 4, 4),
-	[HW_SEL_CP_EXT]		= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 3, 3),
-	[HW_DM_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 2, 2),
-	[HW_DP_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 1, 1),
-	[HW_DP_PULLUP]		= REG_FIELD(ISP176x_HC_OTG_CTRL_SET, 0, 0),
-	[HW_OTG_DISABLE_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 10, 10),
-	[HW_SW_SEL_HC_DC_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 7, 7),
-	[HW_VBUS_DRV_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 4, 4),
-	[HW_SEL_CP_EXT_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 3, 3),
-	[HW_DM_PULLDOWN_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 2, 2),
-	[HW_DP_PULLDOWN_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 1, 1),
-	[HW_DP_PULLUP_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL_CLEAR, 0, 0),
+	[HW_OTG_DISABLE_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 26, 26),
+	[HW_SW_SEL_HC_DC_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 23, 23),
+	[HW_VBUS_DRV_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 20, 20),
+	[HW_SEL_CP_EXT_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 19, 19),
+	[HW_DM_PULLDOWN_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 18, 18),
+	[HW_DP_PULLDOWN_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 17, 17),
+	[HW_DP_PULLUP_CLEAR]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 16, 16),
+	[HW_OTG_DISABLE]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 10, 10),
+	[HW_SW_SEL_HC_DC]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 7, 7),
+	[HW_VBUS_DRV]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 4, 4),
+	[HW_SEL_CP_EXT]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 3, 3),
+	[HW_DM_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 2, 2),
+	[HW_DP_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 1, 1),
+	[HW_DP_PULLUP]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 0, 0),
 };
 
 static const struct reg_field isp1763_hc_reg_fields[] = {
diff --git a/drivers/usb/isp1760/isp1760-regs.h b/drivers/usb/isp1760/isp1760-regs.h
index 94ea60c20b2a..3a6751197e97 100644
--- a/drivers/usb/isp1760/isp1760-regs.h
+++ b/drivers/usb/isp1760/isp1760-regs.h
@@ -61,6 +61,7 @@
 #define ISP176x_HC_INT_IRQ_MASK_AND	0x328
 #define ISP176x_HC_ATL_IRQ_MASK_AND	0x32c
 
+#define ISP176x_HC_OTG_CTRL		0x374
 #define ISP176x_HC_OTG_CTRL_SET		0x374
 #define ISP176x_HC_OTG_CTRL_CLEAR	0x376
 
@@ -179,6 +180,21 @@ enum isp176x_host_controller_fields {
 #define ISP176x_DC_IESUSP		BIT(3)
 #define ISP176x_DC_IEBRST		BIT(0)
 
+#define ISP176x_HW_OTG_DISABLE_CLEAR	BIT(26)
+#define ISP176x_HW_SW_SEL_HC_DC_CLEAR	BIT(23)
+#define ISP176x_HW_VBUS_DRV_CLEAR	BIT(20)
+#define ISP176x_HW_SEL_CP_EXT_CLEAR	BIT(19)
+#define ISP176x_HW_DM_PULLDOWN_CLEAR	BIT(18)
+#define ISP176x_HW_DP_PULLDOWN_CLEAR	BIT(17)
+#define ISP176x_HW_DP_PULLUP_CLEAR	BIT(16)
+#define ISP176x_HW_OTG_DISABLE		BIT(10)
+#define ISP176x_HW_SW_SEL_HC_DC		BIT(7)
+#define ISP176x_HW_VBUS_DRV		BIT(4)
+#define ISP176x_HW_SEL_CP_EXT		BIT(3)
+#define ISP176x_HW_DM_PULLDOWN		BIT(2)
+#define ISP176x_HW_DP_PULLDOWN		BIT(1)
+#define ISP176x_HW_DP_PULLUP		BIT(0)
+
 #define ISP176x_DC_ENDPTYP_ISOC		0x01
 #define ISP176x_DC_ENDPTYP_BULK		0x02
 #define ISP176x_DC_ENDPTYP_INTERRUPT	0x03
-- 
2.30.2



