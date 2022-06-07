Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5195419D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380496AbiFGV1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378416AbiFGVXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797D9227350;
        Tue,  7 Jun 2022 12:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E517A617DA;
        Tue,  7 Jun 2022 19:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057EC385A5;
        Tue,  7 Jun 2022 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628426;
        bh=F9dV5vWQHIX8olZhqFalnogpwZKt3tMjLk5mSopD5kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crf8z+WDs6h/sno02TN8CBxzCnmvsOMYPstJV0AaszusKYRGc76O54RI4N2DD1V7/
         0r0UcP/I3VKXFbWiMTsuaYLc/Cb3/7JuY6mSOIQlBcHPlWOyyJVi2+JGxMPbCPfDqD
         2/IhCqZXh2HSVjcxvZv4gI4LgL8/osBKA1bVZCYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 323/879] drm/bridge: anx7625: Use uint8 for lane-swing arrays
Date:   Tue,  7 Jun 2022 18:57:21 +0200
Message-Id: <20220607165012.228618630@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit fb8da7f3111ab500606960bef1bb32450c664750 ]

As defined in the anx7625 dt-binding, the analogix,lane0-swing and
analogix,lane1-swing properties are uint8 arrays. Yet, the driver was
reading the array as if it were of uint32 and masking to 8-bit before
writing to the registers. This means that a devicetree written in
accordance to the dt-binding would have its values incorrectly parsed.

Fix the issue by reading the array as uint8 and storing them as uint8
internally, so that we can also drop the masking when writing the
registers.

Fixes: fd0310b6fe7d ("drm/bridge: anx7625: add MIPI DPI input feature")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220408013034.673418-1-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 12 ++++++------
 drivers/gpu/drm/bridge/analogix/anx7625.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index a23e13c29a1d..060849f8ad8b 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1478,12 +1478,12 @@ static void anx7625_dp_adjust_swing(struct anx7625_data *ctx)
 	for (i = 0; i < ctx->pdata.dp_lane0_swing_reg_cnt; i++)
 		anx7625_reg_write(ctx, ctx->i2c.tx_p1_client,
 				  DP_TX_LANE0_SWING_REG0 + i,
-				  ctx->pdata.lane0_reg_data[i] & 0xFF);
+				  ctx->pdata.lane0_reg_data[i]);
 
 	for (i = 0; i < ctx->pdata.dp_lane1_swing_reg_cnt; i++)
 		anx7625_reg_write(ctx, ctx->i2c.tx_p1_client,
 				  DP_TX_LANE1_SWING_REG0 + i,
-				  ctx->pdata.lane1_reg_data[i] & 0xFF);
+				  ctx->pdata.lane1_reg_data[i]);
 }
 
 static void dp_hpd_change_handler(struct anx7625_data *ctx, bool on)
@@ -1590,8 +1590,8 @@ static int anx7625_get_swing_setting(struct device *dev,
 			num_regs = DP_TX_SWING_REG_CNT;
 
 		pdata->dp_lane0_swing_reg_cnt = num_regs;
-		of_property_read_u32_array(dev->of_node, "analogix,lane0-swing",
-					   pdata->lane0_reg_data, num_regs);
+		of_property_read_u8_array(dev->of_node, "analogix,lane0-swing",
+					  pdata->lane0_reg_data, num_regs);
 	}
 
 	if (of_get_property(dev->of_node,
@@ -1600,8 +1600,8 @@ static int anx7625_get_swing_setting(struct device *dev,
 			num_regs = DP_TX_SWING_REG_CNT;
 
 		pdata->dp_lane1_swing_reg_cnt = num_regs;
-		of_property_read_u32_array(dev->of_node, "analogix,lane1-swing",
-					   pdata->lane1_reg_data, num_regs);
+		of_property_read_u8_array(dev->of_node, "analogix,lane1-swing",
+					  pdata->lane1_reg_data, num_regs);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.h b/drivers/gpu/drm/bridge/analogix/anx7625.h
index edbbfe410a56..e257a84db962 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.h
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.h
@@ -426,9 +426,9 @@ struct anx7625_platform_data {
 	int mipi_lanes;
 	int audio_en;
 	int dp_lane0_swing_reg_cnt;
-	int lane0_reg_data[DP_TX_SWING_REG_CNT];
+	u8 lane0_reg_data[DP_TX_SWING_REG_CNT];
 	int dp_lane1_swing_reg_cnt;
-	int lane1_reg_data[DP_TX_SWING_REG_CNT];
+	u8 lane1_reg_data[DP_TX_SWING_REG_CNT];
 	u32 low_power_mode;
 	struct device_node *mipi_host_node;
 };
-- 
2.35.1



