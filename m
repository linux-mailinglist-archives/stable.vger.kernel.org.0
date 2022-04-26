Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575CE50F464
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiDZIf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242176AbiDZIfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C9B7EA31;
        Tue, 26 Apr 2022 01:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F44061862;
        Tue, 26 Apr 2022 08:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5AAC385A0;
        Tue, 26 Apr 2022 08:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961701;
        bh=znNaN40pmY2AdXWEBtRGKYdnNAEJBnzE65uE1lh9RXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe7hvPLSxxMEmoTsC8Yf4r7eJZv+bB0MdyfLVI3NJQ6UKXqzUQho5o9iFUs9+u0DW
         E+L03QiiyMVtpO3wkdwBqyK+FrECdfk/3PexIJu0DiuNLnX7yB9rn9MR8ynVI/NArR
         dgZIULUMTE3CbhSOF9KSFONYZyr1hMWzeche/bqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/53] drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare
Date:   Tue, 26 Apr 2022 10:21:12 +0200
Message-Id: <20220426081736.591376322@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 5f18c0782b99e26121efa93d20b76c19e17aa1dd ]

The panel has a prepare call which is before video starts, and an
enable call which is after.
The Toshiba bridge should be configured before video, so move
the relevant power and initialisation calls to prepare.

Fixes: 2f733d6194bd ("drm/panel: Add support for the Raspberry Pi 7" Touchscreen.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220415162513.42190-3-stefan.wahren@i2se.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 2073e0e43e2f..f57eec47ef6a 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -269,7 +269,7 @@ static int rpi_touchscreen_noop(struct drm_panel *panel)
 	return 0;
 }
 
-static int rpi_touchscreen_enable(struct drm_panel *panel)
+static int rpi_touchscreen_prepare(struct drm_panel *panel)
 {
 	struct rpi_touchscreen *ts = panel_to_ts(panel);
 	int i;
@@ -299,6 +299,13 @@ static int rpi_touchscreen_enable(struct drm_panel *panel)
 	rpi_touchscreen_write(ts, DSI_STARTDSI, 0x01);
 	msleep(100);
 
+	return 0;
+}
+
+static int rpi_touchscreen_enable(struct drm_panel *panel)
+{
+	struct rpi_touchscreen *ts = panel_to_ts(panel);
+
 	/* Turn on the backlight. */
 	rpi_touchscreen_i2c_write(ts, REG_PWM, 255);
 
@@ -353,7 +360,7 @@ static int rpi_touchscreen_get_modes(struct drm_panel *panel)
 static const struct drm_panel_funcs rpi_touchscreen_funcs = {
 	.disable = rpi_touchscreen_disable,
 	.unprepare = rpi_touchscreen_noop,
-	.prepare = rpi_touchscreen_noop,
+	.prepare = rpi_touchscreen_prepare,
 	.enable = rpi_touchscreen_enable,
 	.get_modes = rpi_touchscreen_get_modes,
 };
-- 
2.35.1



