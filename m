Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBBF6A368F
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjB0CCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjB0CCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:02:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725FB168B2;
        Sun, 26 Feb 2023 18:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5793660CF7;
        Mon, 27 Feb 2023 02:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39B9C433D2;
        Mon, 27 Feb 2023 02:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463317;
        bh=AH+yBWaJqdyN/OLzLxrlP9N38NfLiZqRHtUyimwrrK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5XlRyNW1MtPlhkrNmoTBgCweyImLsD9VS2TAVsL5tF+QRhJLFjR6FqJi+ZgYjXgX
         V47y3/8DZKCgBMP97w9hCJStSSG1vyHknDkqkR0sBbxLgZsyZQg/B3yL7lk5HJukCA
         Y6PTJrlp0Qa98CTaWw/mkVHDiXyICPpiZgIx6Hy+KEdJUWbvmPInRp9H3sVlopAdhe
         wAcmqaXGyEyY7PflhOlTBI6JolP7yC/FOVgyIqEITT4kLFuOjaCiLMAgnMjsb081Ux
         wu8m+72Eu4t06WjKV43pXZzzANmryQ2edyO71S4pxRKjqs268bfVqsam86WZdOxDwd
         uJ/tqNiX3TyBg==
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
Subject: [PATCH AUTOSEL 6.2 16/60] drm: amd: display: Fix memory leakage
Date:   Sun, 26 Feb 2023 21:00:01 -0500
Message-Id: <20230227020045.1045105-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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
index 0cb8d1f934d12..c03e86e49fea3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -862,6 +862,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
-- 
2.39.0

