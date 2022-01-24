Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C5D499426
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357646AbiAXUje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348182AbiAXUeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:34:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B048C07E2B8;
        Mon, 24 Jan 2022 11:47:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E267E61298;
        Mon, 24 Jan 2022 19:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5BAC340E5;
        Mon, 24 Jan 2022 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053673;
        bh=2oPRCzvY5dsRKRC7+16mS3DHzsCSSWf7cRER46nZmQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTVI4neVPrEmO8wQtd94+QPR4VQIpZazoV1HofX0pRVtjz7JJqErf8777ct5EJh4I
         e90DTH2kAChrewpiMT9wL8q7lrOk06Oyk0U/2m4nRU22piNs8AgxWRwjMMje3ZBhEW
         zQDLjnQyxKUviRhaxys9gs6tEPCsWKnsx80s/lgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/563] mfd: atmel-flexcom: Use .resume_noirq
Date:   Mon, 24 Jan 2022 19:37:52 +0100
Message-Id: <20220124184028.102081221@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



