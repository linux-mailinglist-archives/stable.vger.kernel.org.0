Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112C16A37E7
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjB0CM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjB0CMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:12:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325501A679;
        Sun, 26 Feb 2023 18:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DCA060DBB;
        Mon, 27 Feb 2023 02:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF81C4339C;
        Mon, 27 Feb 2023 02:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463751;
        bh=GVvMTvC/k/XZhy9Kg446CWymPmpcWb3olHw+POmvGXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps9rkOW6qXOmuF5YsoJ4UPQoxWFyag9U3DKQuMoOlZMxFoYU2BKKWh/R506hJ1R2J
         sEDTU23s35imiJ++X9/n2IGl+yU9OStA2iA6BZoMSNa4WISFMItVeoVBFad786n5dy
         EayDhMuzFoobcZP6RGoJwFvcSIWFXO+3MWiycvhHxFrjQIS/ZNfeC2OYa+YU77HVZA
         tZc4G76mGVOgQzBeh316euNUybJR+KR2BVTcDYCnHKVZ61NJH5/bXGCwdIjCxIbLdZ
         DDyNIyMKl9Q9ej+Ptn/7XDPmkW3QnbId/lOViFJM+mjmJ551yCPSckALytaf+MIQgo
         4xKC5gwcCa4ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carlo Caione <ccaione@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kamlesh Gurudasani <kamlesh.gurudasani@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 05/25] drm/tiny: ili9486: Do not assume 8-bit only SPI controllers
Date:   Sun, 26 Feb 2023 21:08:28 -0500
Message-Id: <20230227020855.1051605-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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

From: Carlo Caione <ccaione@baylibre.com>

[ Upstream commit 77772e607522daa61f3af74df018559db75c43d6 ]

The pixel data for the ILI9486 is always 16-bits wide and it must be
sent over the SPI bus. When the controller is only able to deal with
8-bit transfers, this 16-bits data needs to be swapped before the
sending to account for the big endian bus, this is on the contrary not
needed when the SPI controller already supports 16-bits transfers.

The decision about swapping the pixel data or not is taken in the MIPI
DBI code by probing the controller capabilities: if the controller only
suppors 8-bit transfers the data is swapped, otherwise it is not.

This swapping/non-swapping is relying on the assumption that when the
controller does support 16-bit transactions then the data is sent
unswapped in 16-bits-per-word over SPI.

The problem with the ILI9486 driver is that it is forcing 8-bit
transactions also for controllers supporting 16-bits, violating the
assumption and corrupting the pixel data.

Align the driver to what is done in the MIPI DBI code by adjusting the
transfer size to the maximum allowed by the SPI controller.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Carlo Caione <ccaione@baylibre.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh.gurudasani@gmail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221116-s905x_spi_ili9486-v4-2-f86b4463b9e4@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/ili9486.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tiny/ili9486.c b/drivers/gpu/drm/tiny/ili9486.c
index e9a63f4b2993c..e159dfb5f7fe5 100644
--- a/drivers/gpu/drm/tiny/ili9486.c
+++ b/drivers/gpu/drm/tiny/ili9486.c
@@ -43,6 +43,7 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 			     size_t num)
 {
 	struct spi_device *spi = mipi->spi;
+	unsigned int bpw = 8;
 	void *data = par;
 	u32 speed_hz;
 	int i, ret;
@@ -56,8 +57,6 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 	 * The displays are Raspberry Pi HATs and connected to the 8-bit only
 	 * SPI controller, so 16-bit command and parameters need byte swapping
 	 * before being transferred as 8-bit on the big endian SPI bus.
-	 * Pixel data bytes have already been swapped before this function is
-	 * called.
 	 */
 	buf[0] = cpu_to_be16(*cmd);
 	gpiod_set_value_cansleep(mipi->dc, 0);
@@ -71,12 +70,18 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 		for (i = 0; i < num; i++)
 			buf[i] = cpu_to_be16(par[i]);
 		num *= 2;
-		speed_hz = mipi_dbi_spi_cmd_max_speed(spi, num);
 		data = buf;
 	}
 
+	/*
+	 * Check whether pixel data bytes needs to be swapped or not
+	 */
+	if (*cmd == MIPI_DCS_WRITE_MEMORY_START && !mipi->swap_bytes)
+		bpw = 16;
+
 	gpiod_set_value_cansleep(mipi->dc, 1);
-	ret = mipi_dbi_spi_transfer(spi, speed_hz, 8, data, num);
+	speed_hz = mipi_dbi_spi_cmd_max_speed(spi, num);
+	ret = mipi_dbi_spi_transfer(spi, speed_hz, bpw, data, num);
  free:
 	kfree(buf);
 
-- 
2.39.0

