Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C412E6BBA
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgL1Wzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:51 -0500
Received: from lists.gateworks.com ([108.161.130.12]:47116 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgL1Vmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 16:42:43 -0500
X-Greylist: delayed 1916 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Dec 2020 16:42:43 EST
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <tharvey@gateworks.com>)
        id 1ktztW-0005XF-9V; Mon, 28 Dec 2020 21:17:34 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org
Subject: [PATCH] mfd: gateworks-gsc: fix interrupt type
Date:   Mon, 28 Dec 2020 13:10:04 -0800
Message-Id: <1609189804-10039-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Gateworks System Controller has an active-low interrupt.
Fix the interrupt request type.

Fixes: d85234994b2f ("mfd: Add Gateworks System Controller core driver")

Cc: <stable@vger.kernel.org>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/mfd/gateworks-gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/gateworks-gsc.c b/drivers/mfd/gateworks-gsc.c
index 576da62..d878767 100644
--- a/drivers/mfd/gateworks-gsc.c
+++ b/drivers/mfd/gateworks-gsc.c
@@ -234,7 +234,7 @@ static int gsc_probe(struct i2c_client *client)
 
 	ret = devm_regmap_add_irq_chip(dev, gsc->regmap, client->irq,
 				       IRQF_ONESHOT | IRQF_SHARED |
-				       IRQF_TRIGGER_FALLING, 0,
+				       IRQF_TRIGGER_LOW, 0,
 				       &gsc_irq_chip, &irq_data);
 	if (ret)
 		return ret;
-- 
2.7.4

