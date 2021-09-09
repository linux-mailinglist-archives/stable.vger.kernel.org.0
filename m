Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE476404D88
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243263AbhIIMDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244557AbhIIMBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B89B661440;
        Thu,  9 Sep 2021 11:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187979;
        bh=TazWVnaXvlgPzxziINEoLaxVj7c0EuAsDDIxn6rASDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRJN3K8uYpDqqQBN4FzNeXY23aM/YtAOwnErEF52SGRduDM7ZyqfR/+GDqziAehHD
         AuAaElbE1Ewmuh7kt42PirIfRa6+1b2GkhkyBneCxDhdLUFlOA2NceHo6Y5EGsqYKt
         2EG8nTQ4bUBdFx4r1QZhenPWX/IUsSInAtjgfeRUJtdfYuLL1Ne9WoriPNda8Py4oi
         MCrKp/iCtwwRILEj2P9lhKXExupAEdT+bXv0S0nmDVAqrYl/A52BVDrgz5hvbiaoGk
         laDyNGCoL6U7gHVdaVNvBrZm22t68O3qDD7MNtp963aM4Hh9liUb8sekdXJSwl16tB
         uXxEzDTieBGeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 241/252] usb: isp1760: write to status and address register
Date:   Thu,  9 Sep 2021 07:40:55 -0400
Message-Id: <20210909114106.141462-241-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit 36815a4a0763bb405ebd776c45553005c1ef7a15 ]

We were already writing directly the port status register to
trigger changes in isp1763. The same is needed in other IP
from the family, including also to setup the read address
before reading from device.

Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210827131154.4151862-4-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/isp1760/isp1760-hcd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/isp1760/isp1760-hcd.c b/drivers/usb/isp1760/isp1760-hcd.c
index d2d19548241e..e517376c3291 100644
--- a/drivers/usb/isp1760/isp1760-hcd.c
+++ b/drivers/usb/isp1760/isp1760-hcd.c
@@ -182,7 +182,7 @@ struct urb_listitem {
 	struct urb *urb;
 };
 
-static const u32 isp1763_hc_portsc1_fields[] = {
+static const u32 isp176x_hc_portsc1_fields[] = {
 	[PORT_OWNER]		= BIT(13),
 	[PORT_POWER]		= BIT(12),
 	[PORT_LSTATUS]		= BIT(10),
@@ -205,27 +205,28 @@ static u32 isp1760_hcd_read(struct usb_hcd *hcd, u32 field)
 }
 
 /*
- * We need, in isp1763, to write directly the values to the portsc1
+ * We need, in isp176x, to write directly the values to the portsc1
  * register so it will make the other values to trigger.
  */
 static void isp1760_hcd_portsc1_set_clear(struct isp1760_hcd *priv, u32 field,
 					  u32 val)
 {
-	u32 bit = isp1763_hc_portsc1_fields[field];
-	u32 port_status = readl(priv->base + ISP1763_HC_PORTSC1);
+	u32 bit = isp176x_hc_portsc1_fields[field];
+	u16 portsc1_reg = priv->is_isp1763 ? ISP1763_HC_PORTSC1 :
+		ISP176x_HC_PORTSC1;
+	u32 port_status = readl(priv->base + portsc1_reg);
 
 	if (val)
-		writel(port_status | bit, priv->base + ISP1763_HC_PORTSC1);
+		writel(port_status | bit, priv->base + portsc1_reg);
 	else
-		writel(port_status & ~bit, priv->base + ISP1763_HC_PORTSC1);
+		writel(port_status & ~bit, priv->base + portsc1_reg);
 }
 
 static void isp1760_hcd_write(struct usb_hcd *hcd, u32 field, u32 val)
 {
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 
-	if (unlikely(priv->is_isp1763 &&
-		     (field >= PORT_OWNER && field <= PORT_CONNECT)))
+	if (unlikely((field >= PORT_OWNER && field <= PORT_CONNECT)))
 		return isp1760_hcd_portsc1_set_clear(priv, field, val);
 
 	isp1760_field_write(priv->fields, field, val);
@@ -367,8 +368,7 @@ static void isp1760_mem_read(struct usb_hcd *hcd, u32 src_offset, void *dst,
 {
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 
-	isp1760_hcd_write(hcd, MEM_BANK_SEL, ISP_BANK_0);
-	isp1760_hcd_write(hcd, MEM_START_ADDR, src_offset);
+	isp1760_reg_write(priv->regs, ISP176x_HC_MEMORY, src_offset);
 	ndelay(100);
 
 	bank_reads8(priv->base, src_offset, ISP_BANK_0, dst, bytes);
@@ -496,8 +496,7 @@ static void isp1760_ptd_read(struct usb_hcd *hcd, u32 ptd_offset, u32 slot,
 	u16 src_offset = ptd_offset + slot * sizeof(*ptd);
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 
-	isp1760_hcd_write(hcd, MEM_BANK_SEL, ISP_BANK_0);
-	isp1760_hcd_write(hcd, MEM_START_ADDR, src_offset);
+	isp1760_reg_write(priv->regs, ISP176x_HC_MEMORY, src_offset);
 	ndelay(90);
 
 	bank_reads8(priv->base, src_offset, ISP_BANK_0, (void *)ptd,
-- 
2.30.2

