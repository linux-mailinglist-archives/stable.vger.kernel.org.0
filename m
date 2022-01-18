Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7025D4917DF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343899AbiARCnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343831AbiARCh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:37:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF77CC061753;
        Mon, 17 Jan 2022 18:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B6BEB81233;
        Tue, 18 Jan 2022 02:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695A1C36AEB;
        Tue, 18 Jan 2022 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473283;
        bh=4HZ6twDd3uZBRGOAKOIYoZ/dW23vMiKEUWjChiDBfqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjWJSsKNinuypfGubENNVWFqa2Knj31uyNh+EqF5y6ebVyCjbRWKApp1g5isVcXgR
         39XFbK0s4tfS386Suk4GNIuSPqLLn4SrYpB1YP8m30WcKbPF8w5O2dCHgs1Lm25YUJ
         96sCHoc2Lj75yt5+SbYKcTa9EcGp1SBz/RWO7nkolNvrAp43Pc6sGml9XntyBUKl1p
         jhQhmhgIygpdqsk2IFoOnwGuOYRiJLhVVEtN4JPYj6lGmSbSCV0P1s4DXUQkiBsN77
         j6soXLtgQoFMbYtMlbo5FpAu+sNRrA186t16FGF4ifa7sKbSGBCnCcSRpAk/PJC6bo
         SnncHYAekzW8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nathan@kernel.org, ndesaulniers@google.com,
        nicholas.kazlauskas@amd.com, Anson.Jacob@amd.com, aric.cyr@amd.com,
        Jun.Lei@amd.com, michael.strauss@amd.com,
        meenakshikumar.somasundaram@amd.com, haonan.wang2@amd.com,
        Martin.Leung@amd.com, Jimmy.Kizito@amd.com, Wayne.Lin@amd.com,
        Eric.Yang2@amd.com, lee.jones@linaro.org, Lewis.Huang@amd.com,
        roy.chan@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 052/188] drm/amd/display: check top_pipe_to_program pointer
Date:   Mon, 17 Jan 2022 21:29:36 -0500
Message-Id: <20220118023152.1948105-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit a689e8d1f80012f90384ebac9dcfac4201f9f77e ]

Clang static analysis reports this error

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:2870:7: warning:
Dereference of null pointer [clang-analyzer-core.NullDereference]
                if
(top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
                    ^

top_pipe_to_program being NULL is caught as an error
But then it is used to report the error.

So add a check before using it.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index c798c65d42765..1860ccc3f4f2c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2703,7 +2703,8 @@ static void commit_planes_for_stream(struct dc *dc,
 #endif
 
 	if ((update_type != UPDATE_TYPE_FAST) && stream->update_flags.bits.dsc_changed)
-		if (top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
+		if (top_pipe_to_program &&
+			top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
 			if (should_use_dmub_lock(stream->link)) {
 				union dmub_hw_lock_flags hw_locks = { 0 };
 				struct dmub_hw_lock_inst_flags inst_flags = { 0 };
-- 
2.34.1

