Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167645137E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348300AbhKOTvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343617AbhKOTV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A516C635BC;
        Mon, 15 Nov 2021 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001789;
        bh=eVdJx6LEFaICIzOpXoVjUMWi9onvmQSL0pE3vtaEBUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skz85cWi3iozdvswLV2gOrejHXOfMg5oldm9GZFxf7xKIFJevbt1+1af/8NhNZgdk
         Q90QAAqVdGJmqP2cCAEggrIJYV8+dp96xva/0Hc9fURMFsslWKwtobX6szEnBNMjmy
         PBUQ8IE4E2z+Q98k7lEijt0teTK7ViiAqGqRCVrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        kernel test robot <lkp@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/917] drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()
Date:   Mon, 15 Nov 2021 17:56:57 +0100
Message-Id: <20211115165439.657867117@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 7f16d0f3b8e2d13f940e944cd17044ca8eeb8b32 ]

The return value of sp_tx_rst_aux() is not propagated, which means
both compiler warnings and potential errors not being handled.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")

Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210818171318.1848272-1-robert.foss@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 14d73fb1dd15b..ea414cd349b5c 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -720,7 +720,7 @@ static int edid_read(struct anx7625_data *ctx,
 		ret = sp_tx_aux_rd(ctx, 0xf1);
 
 		if (ret) {
-			sp_tx_rst_aux(ctx);
+			ret = sp_tx_rst_aux(ctx);
 			DRM_DEV_DEBUG_DRIVER(dev, "edid read fail, reset!\n");
 		} else {
 			ret = anx7625_reg_block_read(ctx, ctx->i2c.rx_p0_client,
@@ -735,7 +735,7 @@ static int edid_read(struct anx7625_data *ctx,
 	if (cnt > EDID_TRY_CNT)
 		return -EIO;
 
-	return 0;
+	return ret;
 }
 
 static int segments_edid_read(struct anx7625_data *ctx,
@@ -785,7 +785,7 @@ static int segments_edid_read(struct anx7625_data *ctx,
 	if (cnt > EDID_TRY_CNT)
 		return -EIO;
 
-	return 0;
+	return ret;
 }
 
 static int sp_tx_edid_read(struct anx7625_data *ctx,
@@ -887,7 +887,11 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 	}
 
 	/* Reset aux channel */
-	sp_tx_rst_aux(ctx);
+	ret = sp_tx_rst_aux(ctx);
+	if (ret < 0) {
+		DRM_DEV_ERROR(dev, "Failed to reset aux channel!\n");
+		return ret;
+	}
 
 	return (blocks_num + 1);
 }
-- 
2.33.0



