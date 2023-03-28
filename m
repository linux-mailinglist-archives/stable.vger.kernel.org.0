Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1463A6CC3A4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjC1Oz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbjC1Oz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DD1D33A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC36B81D78
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A88C433EF;
        Tue, 28 Mar 2023 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015355;
        bh=Fmj3GXQ0MfvFPWQMLyj09CcA9vjy6HGTJVJ5PSxUX6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKFjzGGSBvAgAEKHBdn00BjGt54wJHOMfpkIVRrX20cYUakyXxt8GL9hG9yUpuiEF
         IS50mrDI7qX/rcRQH3SincLVOzJNdBlsd1P2lqBPmNyzs1kbe3oN6Ko5AOny1haHzz
         pBjvCkA4lqUNm+yGoVBz/c/jMTGUQH+vSiYp3abA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Samson Tam <Samson.Tam@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Saaem Rizvi <SyedSaaem.Rizvi@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/224] drm/amd/display: Remove OTG DIV register write for Virtual signals.
Date:   Tue, 28 Mar 2023 16:40:05 +0200
Message-Id: <20230328142617.620011336@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>

[ Upstream commit 709671ffb15dcd1b4f6afe2a9d8c67c7c4ead4a1 ]

[WHY]
Hot plugging and then hot unplugging leads to k1 and k2 values to
change, as signal is detected as a virtual signal on hot unplug. Writing
these values to OTG_PIXEL_RATE_DIV register might cause primary display
to blank (known hw bug).

[HOW]
No longer write k1 and k2 values to register if signal is virtual, we
have safe guards in place in the case that k1 and k2 is unassigned so
that an unknown value is not written to the register either.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index f108e82e70c8b..1a85509c12f23 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1180,7 +1180,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(stream->signal) || dc_is_virtual_signal(stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
-- 
2.39.2



