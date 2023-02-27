Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4AB6A374E
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjB0CIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjB0CIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:08:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2D86590;
        Sun, 26 Feb 2023 18:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C487EB80CAF;
        Mon, 27 Feb 2023 02:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7906CC433EF;
        Mon, 27 Feb 2023 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463542;
        bh=3oJe9ZFHRxrJlsZBgZlKAG3xSb8P8ndY3G4IeDVQAkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK4HzRTyOwXPX2SpU/SDZe6BW0CHepLJvmdpNtqYft0jCDL/9Fcbr8ksTj2mjJwvX
         mSxgk2ZjhDP6HFOfc280HzGqR4hiCO5+POn+F3ro0vVfgkGrRh1jHBIBr55gSu7rvU
         LliVNKBfVGHsVwQgTDbxIe7bKyrx/tegTrNmaf8UmucDFod18XOFjg5R+M8kRFjnQH
         svDFRAqHS+on5z+/qDFNhrcoSWqmXNBVauhf2pAFALNni9O6sXjgtGuOUpGIqFBxFe
         HkscNpstj9XRcKkLgd5tHkJojGn1mzJuRg6vFcai7n4pzHdJew58WRjZbuX09YXT80
         01DaSV3DJtP6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Syed Hassan <Syed.Hassan@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Charlene.Liu@amd.com, wenjing.liu@amd.com,
        sancchen@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 09/58] drm/amd/display: Defer DIG FIFO disable after VID stream enable
Date:   Sun, 26 Feb 2023 21:04:07 -0500
Message-Id: <20230227020457.1048737-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 2d90a1c054831338d57b39aec4d273cf3e867590 ]

[Why]
On some monitors we see a brief flash of corruption during the
monitor disable sequence caused by FIFO being disabled in the middle
of an active DP stream.

[How]
Wait until DP vid stream is disabled before turning off the FIFO.

The FIFO reset on DP unblank should take care of clearing any FIFO
error, if any.

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Syed Hassan <Syed.Hassan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c   | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
index 38842f938bed0..0926db0183383 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
@@ -278,10 +278,10 @@ static void enc314_stream_encoder_dp_blank(
 	struct dc_link *link,
 	struct stream_encoder *enc)
 {
-	/* New to DCN314 - disable the FIFO before VID stream disable. */
-	enc314_disable_fifo(enc);
-
 	enc1_stream_encoder_dp_blank(link, enc);
+
+	/* Disable FIFO after the DP vid stream is disabled to avoid corruption. */
+	enc314_disable_fifo(enc);
 }
 
 static void enc314_stream_encoder_dp_unblank(
-- 
2.39.0

