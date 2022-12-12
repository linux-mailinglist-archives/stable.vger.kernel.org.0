Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D6B64A0B5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLLN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLLN3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:29:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F35B1001
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEEB8B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B245CC433D2;
        Mon, 12 Dec 2022 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851744;
        bh=5RT5BuAUATRq46ujAMRHxk0cooShMeXn03rDRZ4l+z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PElXdKyOX/uqIe044Dwx6gHhNktnH0BfNWhEaXSGufMQYnPMuFPowJ8BQa7CNrvbv
         dpgA9/pr8lIn7apVqaoSnP4BpgbQekXUkuTnmC93D442idOQLwA8IyLvs+gJso05sD
         4MDiuxrY4u/AcA2Lbsq/iD9tfR2rvMHG7can8ugA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Xin Ji <xji@analogixsemi.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/123] drm/bridge: anx7625: Fix edid_read break case in sp_tx_edid_read()
Date:   Mon, 12 Dec 2022 14:16:41 +0100
Message-Id: <20221212130928.385932820@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 0bae5687bc689b64343fd8b52db2ad9e448f3f16 ]

edid_read() was assumed to return 0 on success. After commit
7f16d0f3b8e2("drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()"),
the function will return > 0 for successful case, representing the i2c
read bytes. Otherwise -EIO on failure cases. Update the g_edid_break
break condition accordingly.

Fixes: 7f16d0f3b8e2("drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Xin Ji <xji@analogixsemi.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118193002.407168-1-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 392a9c56e9a0..f895ef1939fa 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -796,7 +796,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 	int count, blocks_num;
 	u8 pblock_buf[MAX_DPCD_BUFFER_SIZE];
 	u8 i, j;
-	u8 g_edid_break = 0;
+	int g_edid_break = 0;
 	int ret;
 	struct device *dev = &ctx->client->dev;
 
@@ -827,7 +827,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 				g_edid_break = edid_read(ctx, offset,
 							 pblock_buf);
 
-				if (g_edid_break)
+				if (g_edid_break < 0)
 					break;
 
 				memcpy(&pedid_blocks_buf[offset],
-- 
2.35.1



