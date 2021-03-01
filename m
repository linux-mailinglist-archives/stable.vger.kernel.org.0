Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF40328D0F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhCATFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235967AbhCAS6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2225465311;
        Mon,  1 Mar 2021 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620580;
        bh=78L9UvpVe9u+2zDPNCLPyU3oexpUEoatpEnz43cPFPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToJ4usS8fMVTI7ulX5kCNokDMrnb050ZFz2gEDBEENyzpc3HiN6WKHaVOL6mE9KHy
         Jsy5FHm8I+8pvS2+3YLUkqPGkNNSxk/bNNTA3RJ3g0z0cWmWqNmnaCzNURWZvQ8kQp
         dPDub6naY/NzFVsKDO39tjO83aMyiceW8dkynNxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 174/775] drm/panel: mantix: Tweak init sequence
Date:   Mon,  1 Mar 2021 17:05:42 +0100
Message-Id: <20210301161210.230643653@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit dd396dbc4d7811c1567cc43faa4b9ad68094c44d ]

We've seen some (non permanent) burn in and bad white balance
on some of the panels. Adding this bit from a vendor supplied
sequence fixes it.

Fixes: 72967d5616d3 ("drm/panel: Add panel driver for the Mantix MLAF057WE51-X DSI panel")
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/8451831b60d5ecb73a156613d98218a31bd55680.1605688147.git.agx@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c b/drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c
index 0c5f22e95c2db..624d17b96a693 100644
--- a/drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c
+++ b/drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c
@@ -22,6 +22,7 @@
 /* Manufacturer specific Commands send via DSI */
 #define MANTIX_CMD_OTP_STOP_RELOAD_MIPI 0x41
 #define MANTIX_CMD_INT_CANCEL           0x4C
+#define MANTIX_CMD_SPI_FINISH           0x90
 
 struct mantix {
 	struct device *dev;
@@ -66,6 +67,10 @@ static int mantix_init_sequence(struct mantix *ctx)
 	dsi_generic_write_seq(dsi, 0x80, 0x64, 0x00, 0x64, 0x00, 0x00);
 	msleep(20);
 
+	dsi_generic_write_seq(dsi, MANTIX_CMD_SPI_FINISH, 0xA5);
+	dsi_generic_write_seq(dsi, MANTIX_CMD_OTP_STOP_RELOAD_MIPI, 0x00, 0x2F);
+	msleep(20);
+
 	dev_dbg(dev, "Panel init sequence done\n");
 	return 0;
 }
-- 
2.27.0



