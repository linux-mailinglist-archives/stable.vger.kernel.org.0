Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E7B6A38D2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjB0CiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjB0Chy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:37:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6901B57F;
        Sun, 26 Feb 2023 18:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C414B80CAB;
        Mon, 27 Feb 2023 02:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A56BC433EF;
        Mon, 27 Feb 2023 02:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463762;
        bh=XgGRSJncKgK34kgFjt3EXwQp/2mDoKvUU4usqzeY/eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeuO8lBf1PqE2xfD9Tl781hER643oCcnxg/VK6YnP9I1CtjL15VixhbjPptqriD0o
         TAWgEfrx+WMm4x4PS3KAAGDc6BV3SV975zod8zzVF75vzQZLNUAEsHG/270arynDnx
         mhcElg6mbZ8EhVvJNKej5uAlXQ4HqyPmTZq6mstCY/sziawE41P50puzxs6URm1ohC
         dPWNzvu2EGilCTNzrAt4s/cT4F0U33Lxbpxn7mEvTm4XEax/itsPi0uVHloOkYKYut
         AZRYLV4kvD117Do8gPdUQZY9Bj/Nqmc95VERw1bGa2/LA/kfZbUuNU+La23XPEYLpB
         l7Guy0nGImL7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Alvin.Lee2@amd.com, Jun.Lei@amd.com,
        aurabindo.pillai@amd.com, samson.tam@amd.com,
        Dillon.Varone@amd.com, HaoPing.Liu@amd.com, qingqing.zhuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 09/25] drm: amd: display: Fix memory leakage
Date:   Sun, 26 Feb 2023 21:08:32 -0500
Message-Id: <20230227020855.1051605-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 6b8701be1f66064ca72733c5f6e13748cdbf8397 ]

This commit fixes memory leakage in dc_construct_ctx() function.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 6c9378208127d..eca882438f6ef 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -771,6 +771,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
-- 
2.39.0

