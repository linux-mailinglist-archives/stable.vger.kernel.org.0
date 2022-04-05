Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B44F2E1B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347492AbiDEJ05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiDEIQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849166FA02;
        Tue,  5 Apr 2022 01:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AAD7B81BBC;
        Tue,  5 Apr 2022 08:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82335C385A4;
        Tue,  5 Apr 2022 08:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145830;
        bh=+dtZf56pDcVGj1Y2yGsngkE8Pr8vjsaRXriBUUn+Sa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIfGGpCvyIJgGXR2Jwu/4cS+3RAQHWFaiLZj2mGrr8eWoQDFUNjbb20RnW0/A2Qby
         irIo1Swi9CoruaIV83NPsY/5xlhA+x+pB1t1yudRIpJVoYw0c64ZNPSTOm+Eq53kgn
         dwnV3hcojviaJYRSXtOItVg2wZ7UI+jBs4dx9qG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pin-Yen Lin <treapking@chromium.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0544/1126] drm/bridge: anx7625: Fix overflow issue on reading EDID
Date:   Tue,  5 Apr 2022 09:21:31 +0200
Message-Id: <20220405070423.600520464@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-Yen Lin <treapking@chromium.org>

[ Upstream commit d5c6f647aec9ed524aedd04a3aec5ebc21d39007 ]

The length of EDID block can be longer than 256 bytes, so we should use
`int` instead of `u8` for the `edid_pos` variable.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Pin-Yen Lin <treapking@chromium.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220210103827.402436-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 2346dbcc505f..e596cacce9e3 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -846,7 +846,8 @@ static int segments_edid_read(struct anx7625_data *ctx,
 static int sp_tx_edid_read(struct anx7625_data *ctx,
 			   u8 *pedid_blocks_buf)
 {
-	u8 offset, edid_pos;
+	u8 offset;
+	int edid_pos;
 	int count, blocks_num;
 	u8 pblock_buf[MAX_DPCD_BUFFER_SIZE];
 	u8 i, j;
-- 
2.34.1



