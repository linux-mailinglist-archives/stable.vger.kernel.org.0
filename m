Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2742C0888
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgKWMwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387674AbgKWMv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A4920888;
        Mon, 23 Nov 2020 12:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135918;
        bh=p7VRog/hrO3y+bkEpoqbzMPUGbz5HR/eZPD0vMqD/Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooNEzN0FNStqKni5UX9kFuomoOyuVUn9mGVM+wCGohdqsWq/PMTsmbvu0LmYymADp
         S6wXlocTloMIkCBbXvV84zmpUeEWeePn/Hh8tlVXtKKGzDh+g6g0sKZcyccaJcSjJJ
         p/Gf2WX0zjqsK//xaqxlKcNr0c6EQfiNl/LoV4+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 213/252] iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used
Date:   Mon, 23 Nov 2020 13:22:43 +0100
Message-Id: <20201123121845.849146781@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 6d6aa2907d59ddd3c0ebb2b93e1ddc84e474485b upstream.

When the command feature of the ADC is used, it is possible to program
the ADC, and specify at each step what input should be processed, and in
comparison to what reference.

This broke the AUX and battery readings when the touchscreen was
enabled, most likely because the CMD feature would change the VREF all
the time.

Now, when AUX or battery are read, we temporarily disable the CMD
feature, which means that we won't get touchscreen readings in that time
frame. But it now gives correct values for AUX / battery, and the
touchscreen isn't disabled for long enough to be an actual issue.

Fixes: b96952f498db ("IIO: Ingenic JZ47xx: Add touchscreen mode.")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Artur Rojek <contact@artur-rojek.eu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201103201238.161083-1-paul@crapouillou.net
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ingenic-adc.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/iio/adc/ingenic-adc.c
+++ b/drivers/iio/adc/ingenic-adc.c
@@ -177,13 +177,12 @@ static void ingenic_adc_set_config(struc
 	mutex_unlock(&adc->lock);
 }
 
-static void ingenic_adc_enable(struct ingenic_adc *adc,
-			       int engine,
-			       bool enabled)
+static void ingenic_adc_enable_unlocked(struct ingenic_adc *adc,
+					int engine,
+					bool enabled)
 {
 	u8 val;
 
-	mutex_lock(&adc->lock);
 	val = readb(adc->base + JZ_ADC_REG_ENABLE);
 
 	if (enabled)
@@ -192,20 +191,41 @@ static void ingenic_adc_enable(struct in
 		val &= ~BIT(engine);
 
 	writeb(val, adc->base + JZ_ADC_REG_ENABLE);
+}
+
+static void ingenic_adc_enable(struct ingenic_adc *adc,
+			       int engine,
+			       bool enabled)
+{
+	mutex_lock(&adc->lock);
+	ingenic_adc_enable_unlocked(adc, engine, enabled);
 	mutex_unlock(&adc->lock);
 }
 
 static int ingenic_adc_capture(struct ingenic_adc *adc,
 			       int engine)
 {
+	u32 cfg;
 	u8 val;
 	int ret;
 
-	ingenic_adc_enable(adc, engine, true);
+	/*
+	 * Disable CMD_SEL temporarily, because it causes wrong VBAT readings,
+	 * probably due to the switch of VREF. We must keep the lock here to
+	 * avoid races with the buffer enable/disable functions.
+	 */
+	mutex_lock(&adc->lock);
+	cfg = readl(adc->base + JZ_ADC_REG_CFG);
+	writel(cfg & ~JZ_ADC_REG_CFG_CMD_SEL, adc->base + JZ_ADC_REG_CFG);
+
+	ingenic_adc_enable_unlocked(adc, engine, true);
 	ret = readb_poll_timeout(adc->base + JZ_ADC_REG_ENABLE, val,
 				 !(val & BIT(engine)), 250, 1000);
 	if (ret)
-		ingenic_adc_enable(adc, engine, false);
+		ingenic_adc_enable_unlocked(adc, engine, false);
+
+	writel(cfg, adc->base + JZ_ADC_REG_CFG);
+	mutex_unlock(&adc->lock);
 
 	return ret;
 }


