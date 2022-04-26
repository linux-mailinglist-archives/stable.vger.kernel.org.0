Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3FE50F4EC
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbiDZIkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345580AbiDZIjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D9F19C34;
        Tue, 26 Apr 2022 01:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAF11B81CF9;
        Tue, 26 Apr 2022 08:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344FDC385A0;
        Tue, 26 Apr 2022 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961821;
        bh=MyWmK+PsAZoXKuUVRcLqfbxwM+xdMH/P2sk7Eu3KX8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwy2DfoP7aEsev8zoWfodw1eWJSAI8MIMiuqc/1CD9BtJe1RDyQ/3elvUITcon44H
         Le+wv7COtXtb2wGuPtN+kZUO2cyN5kKchjUONSZfAjZF4PfJ0N7++MuaJOtiOEdnYx
         /PHHV98k9X5GvZ8XjlwyBPxJMD6w7P1DJ+h4yQkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/62] drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised
Date:   Tue, 26 Apr 2022 10:21:20 +0200
Message-Id: <20220426081738.370466024@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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

[ Upstream commit f92055ae0acb035891e988ce345d6b81a0316423 ]

If a call to rpi_touchscreen_i2c_write from rpi_touchscreen_probe
fails before mipi_dsi_device_register_full is called, then
in trying to log the error message if uses ts->dsi->dev when
it is still NULL.

Use ts->i2c->dev instead, which is initialised earlier in probe.

Fixes: 2f733d6194bd ("drm/panel: Add support for the Raspberry Pi 7" Touchscreen.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220415162513.42190-2-stefan.wahren@i2se.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index bdb4d59c8127..6906f522521d 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -232,7 +232,7 @@ static void rpi_touchscreen_i2c_write(struct rpi_touchscreen *ts,
 
 	ret = i2c_smbus_write_byte_data(ts->i2c, reg, val);
 	if (ret)
-		dev_err(&ts->dsi->dev, "I2C write failed: %d\n", ret);
+		dev_err(&ts->i2c->dev, "I2C write failed: %d\n", ret);
 }
 
 static int rpi_touchscreen_write(struct rpi_touchscreen *ts, u16 reg, u32 val)
-- 
2.35.1



