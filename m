Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92A06CC2F2
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbjC1OuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbjC1Otr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB420E040
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C54ACE1DAE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E87AC433A0;
        Tue, 28 Mar 2023 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014949;
        bh=E3f5CO2Pd5Nru0Fhy3TS3qaKvgDNqHpWMAJkRW1MqFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m959KE1HGnagoNEN1VzCjCDo7BJvAe758+npRMGmcTrTIg9iVxYx3QifUPQk7Gu2U
         VsnBl8cnkJcWy3IHy07oZEqv95IcbysYMeGEqIEp9E4B8sSzgnhu8On29ddf5G2D88
         CnqR5qfhsCBu4l7Gc1P8O1pvQxaLcR9KeOwtWL44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Crawford <frank@crawford.emu.id.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 112/240] hwmon (it87): Fix voltage scaling for chips with 10.9mV  ADCs
Date:   Tue, 28 Mar 2023 16:41:15 +0200
Message-Id: <20230328142624.446836814@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
index 9997f76b1f4aa..b7c7cf2157018 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -490,6 +490,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3100,7 +3102,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
-- 
2.39.2



