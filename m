Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6152363DDF4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiK3ScQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiK3ScP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352BB900E0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCBA4B81CA1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBE9C433D6;
        Wed, 30 Nov 2022 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833131;
        bh=AHuQ2crU9VmKDSrHaoFqqKvRP1+7eD8yQs5aVRFjzn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV9M0SvP/Fb2ZCeelBhA6o20Mo95IETUU48IfeGjZZzOR38cQyvgmABtkZizU/3yz
         E/hmWu/cdsqSVfdpuSOAgmVQelFtlCMRR0OvfAlSbesxdKouCOWqf9k46FVoMCkRGL
         kt2ZRz7N3qE4CMMSswGw/QWyhBpR12goVa2sQy4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/162] Input: goodix - try resetting the controller when no config is set
Date:   Wed, 30 Nov 2022 19:23:35 +0100
Message-Id: <20221130180532.119825215@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b23abde5d7db..b7f87ad4b9a9 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1059,6 +1059,7 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 	input_set_abs_params(ts->input_dev, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
 	input_set_abs_params(ts->input_dev, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
 
+retry_read_config:
 	/* Read configuration and apply touchscreen parameters */
 	goodix_read_config(ts);
 
@@ -1066,6 +1067,16 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
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



