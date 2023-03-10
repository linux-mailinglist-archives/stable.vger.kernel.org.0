Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C066B43E2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjCJOTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjCJOTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:19:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7EA2471A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:17:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A7BA617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1CCC433EF;
        Fri, 10 Mar 2023 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457842;
        bh=VE4MHrucOyK2W8f1KtIu+LxGm3Ke51nXPM+xQIEg2WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8IgEcZ5aw+lQsnovLfZw4PaY/5FflEw7rTSqAvL63ypMHXMzUYRmoGXh5OWXOWX4
         OCU7VomW+GYykMCcsQSLGjqM5oGoZdrd8F08rtUowwZ/5h0qKnY+sDXXeUI19wndv3
         rsnJJVaS7Xq18cov/2896bbMmvP9sbh4pyoWwTnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Mentz <danielmentz@google.com>,
        Richard Acayan <mailingradian@gmail.com>,
        Caleb Connolly <caleb@connolly.tech>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/252] drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness
Date:   Fri, 10 Mar 2023 14:37:26 +0100
Message-Id: <20230310133721.131658514@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mentz <danielmentz@google.com>

[ Upstream commit c9d27c6be518b4ef2966d9564654ef99292ea1b3 ]

The MIPI DCS specification demands that brightness values are sent in
big endian byte order. It also states that one parameter (i.e. one byte)
shall be sent/received for 8 bit wide values, and two parameters shall
be used for values that are between 9 and 16 bits wide.

Add new functions to properly handle 16-bit brightness in big endian,
since the two 8- and 16-bit cases are distinct from each other.

[richard: use separate functions instead of switch/case]
[richard: split into 16-bit component]

Fixes: 1a9d759331b8 ("drm/dsi: Implement DCS set/get display brightness")
Signed-off-by: Daniel Mentz <danielmentz@google.com>
Link: https://android.googlesource.com/kernel/msm/+/754affd62d0ee268c686c53169b1dbb7deac8550
[richard: fix 16-bit brightness_get]
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Tested-by: Caleb Connolly <caleb@connolly.tech>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230116224909.23884-2-mailingradian@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 52 ++++++++++++++++++++++++++++++++++
 include/drm/drm_mipi_dsi.h     |  4 +++
 2 files changed, 56 insertions(+)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index c8c9daecd00da..81923442b42d0 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -1096,6 +1096,58 @@ int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 }
 EXPORT_SYMBOL(mipi_dsi_dcs_get_display_brightness);
 
+/**
+ * mipi_dsi_dcs_set_display_brightness_large() - sets the 16-bit brightness value
+ *    of the display
+ * @dsi: DSI peripheral device
+ * @brightness: brightness value
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness)
+{
+	u8 payload[2] = { brightness >> 8, brightness & 0xff };
+	ssize_t err;
+
+	err = mipi_dsi_dcs_write(dsi, MIPI_DCS_SET_DISPLAY_BRIGHTNESS,
+				 payload, sizeof(payload));
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL(mipi_dsi_dcs_set_display_brightness_large);
+
+/**
+ * mipi_dsi_dcs_get_display_brightness_large() - gets the current 16-bit
+ *    brightness value of the display
+ * @dsi: DSI peripheral device
+ * @brightness: brightness value
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness)
+{
+	u8 brightness_be[2];
+	ssize_t err;
+
+	err = mipi_dsi_dcs_read(dsi, MIPI_DCS_GET_DISPLAY_BRIGHTNESS,
+				brightness_be, sizeof(brightness_be));
+	if (err <= 0) {
+		if (err == 0)
+			err = -ENODATA;
+
+		return err;
+	}
+
+	*brightness = (brightness_be[0] << 8) | brightness_be[1];
+
+	return 0;
+}
+EXPORT_SYMBOL(mipi_dsi_dcs_get_display_brightness_large);
+
 static int mipi_dsi_drv_probe(struct device *dev)
 {
 	struct mipi_dsi_driver *drv = to_mipi_dsi_driver(dev->driver);
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 4fef19064b0f1..689f615471ab1 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -274,6 +274,10 @@ int mipi_dsi_dcs_set_display_brightness(struct mipi_dsi_device *dsi,
 					u16 brightness);
 int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 					u16 *brightness);
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness);
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness);
 
 /**
  * struct mipi_dsi_driver - DSI driver
-- 
2.39.2



