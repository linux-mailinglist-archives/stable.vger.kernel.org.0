Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C354996DF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354502AbiAXVHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55712 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444931AbiAXVBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF926B8121C;
        Mon, 24 Jan 2022 21:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E786C340E8;
        Mon, 24 Jan 2022 21:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058103;
        bh=2oPRCzvY5dsRKRC7+16mS3DHzsCSSWf7cRER46nZmQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvPh9DgtWvYpuh7FWaILLyvGmXYTK+zC1LGZdT+y4hRWmyEbUpC/DqjQnfzgD9Rtg
         Lyuq+JnbR91jB6mS3xfMkYcDCegTwsljlVfk07XPV1m411aPVqVMD/yYfoonG2mywx
         FSMs0TrhWhI+vndxaDDzMy0M/4fhYvFK1MJY8nvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0182/1039] mfd: atmel-flexcom: Use .resume_noirq
Date:   Mon, 24 Jan 2022 19:32:51 +0100
Message-Id: <20220124184131.397925606@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 5d051cf94fd5834a1513aa77e542c49fd973988a ]

Flexcom IP embeds 3 other IPs: usart, i2c, spi and selects the operation
mode (usart, i2c, spi) via mode register (FLEX_MR). On i2c bus there might
be connected critical devices (like PMIC) which on suspend/resume should
be suspended/resumed at the end/beginning. i2c uses
.suspend_noirq/.resume_noirq for this kind of purposes. Align flexcom
to use .resume_noirq as it should be resumed before the embedded IPs.
Otherwise the embedded devices might behave badly.

Fixes: 7fdec11015c3 ("atmel_flexcom: Support resuming after a chip reset")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211028135138.3481166-3-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/atmel-flexcom.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/atmel-flexcom.c b/drivers/mfd/atmel-flexcom.c
index 962f66dc8813e..559eb4d352b68 100644
--- a/drivers/mfd/atmel-flexcom.c
+++ b/drivers/mfd/atmel-flexcom.c
@@ -87,7 +87,7 @@ static const struct of_device_id atmel_flexcom_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, atmel_flexcom_of_match);
 
-static int __maybe_unused atmel_flexcom_resume(struct device *dev)
+static int __maybe_unused atmel_flexcom_resume_noirq(struct device *dev)
 {
 	struct atmel_flexcom *ddata = dev_get_drvdata(dev);
 	int err;
@@ -105,8 +105,9 @@ static int __maybe_unused atmel_flexcom_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(atmel_flexcom_pm_ops, NULL,
-			 atmel_flexcom_resume);
+static const struct dev_pm_ops atmel_flexcom_pm_ops = {
+	.resume_noirq = atmel_flexcom_resume_noirq,
+};
 
 static struct platform_driver atmel_flexcom_driver = {
 	.probe	= atmel_flexcom_probe,
-- 
2.34.1



