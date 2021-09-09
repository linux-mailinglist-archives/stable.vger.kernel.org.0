Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E3404D8D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbhIIMDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243185AbhIIMBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F332C61526;
        Thu,  9 Sep 2021 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187980;
        bh=/7AEC3ilG/Z0kZyZJtcKVG5IiNVzFQK63um9OA45wwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JykPtzfnVOZyRXCwQagIkJmfNThTCZurDJqxDVaPA7SXPUA+NvZdWdqy6fyWuuNBc
         kuraDyXVs15+Mim8KzkjWj0NCtdKXD1t1X6GLeLjxQTqpdumTENiZ5O+GvBsjsJsCs
         IwGiMXbhRFdHhcv+AWrbh5oiGtNx5B6rweRONXYLwbp28yFM62VmTnyoYup6GCnUOD
         O7BmzLNm7/h4kR9gjrQX5hKLzbJKt5DYzmteyoA/7UOqMNPp+n+T56cVpmYK7cghgN
         uNwcvkiJK2aSRWmdqcUShaggviD8QGX2qfVKyYnyJzQ12Y2y+pDn0QNVuRw6jYt6xF
         h0VpVTOp0XiRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 242/252] usb: isp1760: use the right irq status bit
Date:   Thu,  9 Sep 2021 07:40:56 -0400
Message-Id: <20210909114106.141462-242-sashal@kernel.org>
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

