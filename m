Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15BD2B5C44
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgKQJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgKQJwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D2A2467B;
        Tue, 17 Nov 2020 09:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606770;
        bh=MoO7y59lQNOYBbnNsqOuyI+GVpm1jjVhRWvvTyijiMk=;
        h=Subject:To:From:Date:From;
        b=gkwCrwID0Ve8W+2UqzP838GJl8bejpbneICP45GHp/Gzk39qC3qjBf0ZGqCkj2XCm
         1rvOCjLhMBWZ4mtgCKWZ8KUWXaZ55FhZj7LVo+vquwL39jOgTA+K2+TRDEFN2cseeY
         ADTafi7HunMpg+cNz7QfYt5hscz7epEe++knD+fI=
Subject: patch "iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used" added to staging-linus
To:     paul@crapouillou.net, Jonathan.Cameron@huawei.com,
        contact@artur-rojek.eu, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:25 +0100
Message-ID: <1605606805232237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6d6aa2907d59ddd3c0ebb2b93e1ddc84e474485b Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Tue, 3 Nov 2020 20:12:38 +0000
Subject: iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used

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
---
 drivers/iio/adc/ingenic-adc.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/ingenic-adc.c b/drivers/iio/adc/ingenic-adc.c
index 973e84deebea..1aafbe2cfe67 100644
--- a/drivers/iio/adc/ingenic-adc.c
+++ b/drivers/iio/adc/ingenic-adc.c
@@ -177,13 +177,12 @@ static void ingenic_adc_set_config(struct ingenic_adc *adc,
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
@@ -192,20 +191,41 @@ static void ingenic_adc_enable(struct ingenic_adc *adc,
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
-- 
2.29.2


