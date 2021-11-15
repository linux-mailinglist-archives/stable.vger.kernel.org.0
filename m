Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2771E451059
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhKOSqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242747AbhKOSo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CB9463361;
        Mon, 15 Nov 2021 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999550;
        bh=aGY6niSSEdrXyluydsOi1K+XDPSsHcsyuIhPv3fm/tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrSRw8hgWcgj4+OAsr/cok49xPQepcLtCdTMP7Mntyg5pno4UoP+qhVh1BKSC07Xk
         0+NbmRhUpvmqAkwDnN9yn5shpeqfpTtjN281ozG2LERCeocDH1btDXStopjFbDzNtu
         WGr7zIl3oI3qEzcyUJHBS5Rp32CkKpKhfeR3anwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        kernel test robot <lkp@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 338/849] drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()
Date:   Mon, 15 Nov 2021 17:57:01 +0100
Message-Id: <20211115165431.667318228@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 7519b7a0f29dd..439c7bed33ff2 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -702,7 +702,7 @@ static int edid_read(struct anx7625_data *ctx,
 		ret = sp_tx_aux_rd(ctx, 0xf1);
 
 		if (ret) {
-			sp_tx_rst_aux(ctx);
+			ret = sp_tx_rst_aux(ctx);
 			DRM_DEV_DEBUG_DRIVER(dev, "edid read fail, reset!\n");
 		} else {
 			ret = anx7625_reg_block_read(ctx, ctx->i2c.rx_p0_client,
@@ -717,7 +717,7 @@ static int edid_read(struct anx7625_data *ctx,
 	if (cnt > EDID_TRY_CNT)
 		return -EIO;
 
-	return 0;
+	return ret;
 }
 
 static int segments_edid_read(struct anx7625_data *ctx,
@@ -767,7 +767,7 @@ static int segments_edid_read(struct anx7625_data *ctx,
 	if (cnt > EDID_TRY_CNT)
 		return -EIO;
 
-	return 0;
+	return ret;
 }
 
 static int sp_tx_edid_read(struct anx7625_data *ctx,
@@ -869,7 +869,11 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
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



