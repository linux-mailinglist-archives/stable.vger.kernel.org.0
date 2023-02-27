Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772596A38A9
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjB0Cew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjB0Cec (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0D71ABE8;
        Sun, 26 Feb 2023 18:33:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DE360DB5;
        Mon, 27 Feb 2023 02:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2461C433D2;
        Mon, 27 Feb 2023 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463812;
        bh=TwtVg78a8oTEEKnfF1q80K61lOdmyLTEqacOb8nA99g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=couoRQF0O2W/IXXTBzx5bY48W6F4EGny3Fnm0ZjXltaknUhuAGntWkSnS35jmD4mY
         cyGCO5Cllf2OKOTey4Rfn3RtzuQ7Uy91AliCJQxv84Fb8o87T5leg/CI/vMu7jqtU5
         TEZrQYMoPsi9+AF/c6UjGAcZFQ7328qpimyGsEmloVCb/YxlUNwJKJBLiafpSOHA8c
         lpgi1DKvm9CRYjP1nTV0oxqBNWFbxG2N6LPLCGeFDko5CvIMI6xELK0uMd3kF6aIwJ
         hY2VNAl1z5JQZZf6r/w2jY5FLvrcagLBwlN5XbZL3K4IPua3/chcMp2UloKniJswJQ
         ykfhJi00qzb9w==
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
Subject: [PATCH AUTOSEL 5.10 06/19] drm: amd: display: Fix memory leakage
Date:   Sun, 26 Feb 2023 21:09:41 -0500
Message-Id: <20230227020957.1052252-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020957.1052252-1-sashal@kernel.org>
References: <20230227020957.1052252-1-sashal@kernel.org>
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
index 99887bcfada04..7e0a55aa2b180 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -616,6 +616,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
-- 
2.39.0

