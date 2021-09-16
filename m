Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF1240E834
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbhIPRoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354605AbhIPRk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A54863254;
        Thu, 16 Sep 2021 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811089;
        bh=/7AEC3ilG/Z0kZyZJtcKVG5IiNVzFQK63um9OA45wwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRbwdrnEhJ9259iqJmOvaXEZovtxSqk2Xikd2DStd12RuUDaJ3ILrQBFf1GIMIYrG
         A4GiQg95snrKn3MY+bIQDo06sCdhIVRPGSPy2Yg4OBcKGy+tFFShPDOoySCywm0y+T
         eAjDYgqej35bE4PgxdL4FDQa1HYygctgp35Y+RSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 380/432] usb: isp1760: use the right irq status bit
Date:   Thu, 16 Sep 2021 18:02:09 +0200
Message-Id: <20210916155823.698180802@linuxfoundation.org>
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

[ Upstream commit 955d0fb590f18ec5c3a4085c7d0e39b6abde0dd6 ]

Instead of using the fields enum values to check interrupts
trigged, use the correct bit values.

Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210827131154.4151862-5-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/isp1760/isp1760-udc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/isp1760/isp1760-udc.c b/drivers/usb/isp1760/isp1760-udc.c
index a78da59d6417..5cafd23345ca 100644
--- a/drivers/usb/isp1760/isp1760-udc.c
+++ b/drivers/usb/isp1760/isp1760-udc.c
@@ -1363,7 +1363,7 @@ static irqreturn_t isp1760_udc_irq(int irq, void *dev)
 
 	status = isp1760_udc_irq_get_status(udc);
 
-	if (status & DC_IEVBUS) {
+	if (status & ISP176x_DC_IEVBUS) {
 		dev_dbg(udc->isp->dev, "%s(VBUS)\n", __func__);
 		/* The VBUS interrupt is only triggered when VBUS appears. */
 		spin_lock(&udc->lock);
@@ -1371,7 +1371,7 @@ static irqreturn_t isp1760_udc_irq(int irq, void *dev)
 		spin_unlock(&udc->lock);
 	}
 
-	if (status & DC_IEBRST) {
+	if (status & ISP176x_DC_IEBRST) {
 		dev_dbg(udc->isp->dev, "%s(BRST)\n", __func__);
 
 		isp1760_udc_reset(udc);
@@ -1391,18 +1391,18 @@ static irqreturn_t isp1760_udc_irq(int irq, void *dev)
 		}
 	}
 
-	if (status & DC_IEP0SETUP) {
+	if (status & ISP176x_DC_IEP0SETUP) {
 		dev_dbg(udc->isp->dev, "%s(EP0SETUP)\n", __func__);
 
 		isp1760_ep0_setup(udc);
 	}
 
-	if (status & DC_IERESM) {
+	if (status & ISP176x_DC_IERESM) {
 		dev_dbg(udc->isp->dev, "%s(RESM)\n", __func__);
 		isp1760_udc_resume(udc);
 	}
 
-	if (status & DC_IESUSP) {
+	if (status & ISP176x_DC_IESUSP) {
 		dev_dbg(udc->isp->dev, "%s(SUSP)\n", __func__);
 
 		spin_lock(&udc->lock);
@@ -1413,7 +1413,7 @@ static irqreturn_t isp1760_udc_irq(int irq, void *dev)
 		spin_unlock(&udc->lock);
 	}
 
-	if (status & DC_IEHS_STA) {
+	if (status & ISP176x_DC_IEHS_STA) {
 		dev_dbg(udc->isp->dev, "%s(HS_STA)\n", __func__);
 		udc->gadget.speed = USB_SPEED_HIGH;
 	}
-- 
2.30.2



