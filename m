Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A939D635E17
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiKWMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237885AbiKWMqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:46:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BE410FF8;
        Wed, 23 Nov 2022 04:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F4D2B81F40;
        Wed, 23 Nov 2022 12:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939BAC43144;
        Wed, 23 Nov 2022 12:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207375;
        bh=3VrYr1zEJ0SxNScNtndKFexlUKePXKAllikEjllQaz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjKpKiyEajtzrvB5OOJ8fThY4oA5xKTig6tPgze+ry55cE/3s4p9pDM4e+mfHfrh8
         QWDjy6lRE15Bown9ccrEEPFRpBIuJgetUcSTOwyFJHPQrlAyQ0c1x9IkmjSkHhmMyq
         8k/MeK17oAZaiV78b6bJLCZwnihkdxqk0sZD2JyyuMg3SLeH7KadJ79sSWyqqux2LC
         PofJlzd0yrlpAK3Me9EUKdfxTTupV1rjiYUt+LakdN0updjeD2r1ogCSNzHNZQp+1w
         whpTCQGezmpKYxL4BBE+FahivQ3XnDwMfAyGsZOQrKWb7vOKtpSABSDUvdHdqyh9O6
         x8a7SB98nGGZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/31] Input: goodix - try resetting the controller when no config is set
Date:   Wed, 23 Nov 2022 07:42:09 -0500
Message-Id: <20221123124234.265396-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c7e37cc6240767f794678d11704935d49cc81d59 ]

On ACPI systems (irq_pin_access_method == IRQ_PIN_ACCESS_ACPI_*) the driver
does not reset the controller at probe time, because sometimes the system
firmware loads a config and resetting might loose this config.

On the Nanote UMPC-01 device OTOH the config is in flash of the controller,
the controller needs a reset to load this; and the system firmware does not
reset the controller on a cold boot.

To fix the Nanote UMPC-01 touchscreen not working on a cold boot, try
resetting the controller and then re-reading the config when encountering
a config with 0 width/height/max_touch_num value and the controller has
not already been reset by goodix_ts_probe().

This should be safe to do in general because normally we should never
encounter a config with 0 width/height/max_touch_num. Doing this in
general not only avoids the need for a DMI quirk, but also might help
other systems.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20221025122930.421377-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 9a9deea51163..0b513fcd51d1 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1039,6 +1039,7 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	input_set_abs_params(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
 	input_set_abs_params(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
 
+retry_read_config:
 	/* Read configuration and apply touchscreen parameters */
 	goodix_read_config(ts);
 
@@ -1046,6 +1047,16 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	touchscreen_parse_properties(ts->input_dev, true, &ts->prop);
 
 	if (!ts->prop.max_x || !ts->prop.max_y || !ts->max_touch_num) {
+		if (!ts->reset_controller_at_probe &&
+		    ts->irq_pin_access_method != IRQ_PIN_ACCESS_NONE) {
+			dev_info(&ts->client->dev, "Config not set, resetting controller\n");
+			/* Retry after a controller reset */
+			ts->reset_controller_at_probe = true;
+			error = goodix_reset(ts);
+			if (error)
+				return error;
+			goto retry_read_config;
+		}
 		dev_err(&ts->client->dev,
 			"Invalid config (%d, %d, %d), using defaults\n",
 			ts->prop.max_x, ts->prop.max_y, ts->max_touch_num);
-- 
2.35.1

