Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412CC5F952A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiJJAQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiJJAPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4207958DE5;
        Sun,  9 Oct 2022 16:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE10660D3F;
        Sun,  9 Oct 2022 23:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883FFC433D7;
        Sun,  9 Oct 2022 23:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359535;
        bh=Ol+2Xj2+b+tySJ+C/RyQP4TaRR4MLjLtzXy+zmFgurg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VU9kY46989hLIM5rIwfXnpo9UyI3qE6fEcgLZ4Hr+r/IWftgoUjPEA/nKFjKV/CKC
         +sqauSuxcjs+i8H5N9FH4hoMcjfUvei+ePugXeh016B/Bm6HLOPueyaGk66SS/7UNU
         DtdLsAPSGZFOuscLFQpAaipMUeDGmNznM5ADOOE4pHtkSHz/vxh8tU5kfyWUgLo7Rf
         vxnIecUqYyY+rR2HFy/n06nZ/VvGAUMbwBlJXUHSI5r7p1uemDzR25amRz1nCNeHUw
         S5xBjtGdXmYHmrPKme4SiADr/z6mIxd2hFcp1XIYiCDLbOAuiYkl0DrYl1mZnr2FV2
         Z9w8XkuW6Z4Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenjing Liu <wenjing.liu@amd.com>,
        Ariel Bernstein <Eric.Bernstein@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Jerry.Zuo@amd.com, wayne.lin@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 42/44] drm/amd/display: polling vid stream status in hpo dp blank
Date:   Sun,  9 Oct 2022 19:49:30 -0400
Message-Id: <20221009234932.1230196-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
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

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit e32df0c7ecead95d70ca89f39b1b2b02a59ff691 ]

[why]
vid stream control is double bufferred, if we don't wait for video
stream enable set to 0, we may get temporary image corruption
showing on the stream when setting PIXEL_TO_SYMBOL_FIFO_ENABLE to 0.

Reviewed-by: Ariel Bernstein <Eric.Bernstein@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c
index 23621ff08c90..52fb2bf3d578 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c
@@ -150,9 +150,9 @@ static void dcn31_hpo_dp_stream_enc_dp_blank(
 	 * 10us*5000=50ms. This covers 41.7ms of minimum 24 Hz mode +
 	 * a little more because we may not trust delay accuracy.
 	 */
-	//REG_WAIT(DP_SYM32_ENC_VID_STREAM_CONTROL,
-	//		VID_STREAM_STATUS, 0,
-	//		10, 5000);
+	REG_WAIT(DP_SYM32_ENC_VID_STREAM_CONTROL,
+			VID_STREAM_STATUS, 0,
+			10, 5000);
 
 	/* Disable SDP tranmission */
 	REG_UPDATE(DP_SYM32_ENC_SDP_CONTROL,
-- 
2.35.1

