Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982496CC419
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjC1PAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjC1O7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D2AEB59
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A63A0B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31C5C433D2;
        Tue, 28 Mar 2023 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015586;
        bh=UK97T5PmoVCotjuwCVgiixwxJJu6uqXEcy8gW9ybzvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTBoI9KOX77okmGfuYXG8RBdnHTXFENxKmhgotG4n9IpFWUtXi6gaJmo9//UblisZ
         seSNi/jUl/vyi1F1eugc2puiKR1eBVnVW3Z0P0KAn5fNPDgSmTlgoJ3gy76pT9RvxV
         ZNSmrlj+05ISPlSPA+HpwtNZr830bJ3kFQwSDi2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Crawford <frank@crawford.emu.id.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/224] hwmon (it87): Fix voltage scaling for chips with 10.9mV  ADCs
Date:   Tue, 28 Mar 2023 16:41:38 +0200
Message-Id: <20230328142621.603758881@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index 7bd154ba351b9..b45bd3aa5a653 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -486,6 +486,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3098,7 +3100,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
-- 
2.39.2



