Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A66D46F4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjDCOPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjDCOPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B64ED5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A419BB81B6B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1665C433D2;
        Mon,  3 Apr 2023 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531339;
        bh=lgZTDMT30Frdvpe4vETU0UvV89pHNQM/oabTMvup6s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkbhBaIx25nv+6EUaJ6CmkQzZhVPAigvpmCCCCFEjKx0RnkooB2DOCuHqu3jYhjY+
         +0ihWSAYSfTS/WiFLrtAJ1/g8cnbCovlRFsu8DjsJczzfuwBvQOYc+jsTyqg0RVyeL
         s8JbuXh/oXllMgNGVskdv5Ih2Fau+3Ojb+rAfnaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Crawford <frank@crawford.emu.id.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/84] hwmon (it87): Fix voltage scaling for chips with 10.9mV  ADCs
Date:   Mon,  3 Apr 2023 16:08:26 +0200
Message-Id: <20230403140354.220601792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Crawford <frank@crawford.emu.id.au>

[ Upstream commit 968b66ffeb7956acc72836a7797aeb7b2444ec51 ]

Fix voltage scaling for chips that have 10.9mV ADCs, where scaling was
not performed.

Fixes: ead8080351c9 ("hwmon: (it87) Add support for IT8732F")
Signed-off-by: Frank Crawford <frank@crawford.emu.id.au>
Link: https://lore.kernel.org/r/20230318080543.1226700-2-frank@crawford.emu.id.au
[groeck: Update subject and description to focus on bug fix]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index f8499cb95fec8..4e4e151760db2 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -495,6 +495,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3107,7 +3109,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
-- 
2.39.2



