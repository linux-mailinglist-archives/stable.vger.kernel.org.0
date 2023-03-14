Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DF76B9491
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjCNMqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjCNMp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6555FE92;
        Tue, 14 Mar 2023 05:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614D76175A;
        Tue, 14 Mar 2023 12:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD10DC433EF;
        Tue, 14 Mar 2023 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797839;
        bh=j1MGEQmNXwRQZbXTFfs+jQOVxqSqFNMBQT1eucoL3Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgub9wu2g+tP8Aj4X7wCzfiJpWcpvrZFrQT6nJ51q1ymVvFSxMetAxU28zUSI1gdE
         JHptIOO8hwmrBy/Mc5syVfPtJp9w/+ggKFbrDE4aBdDyhM/XSI8SHsxzVlbtASn6Iz
         FFGsxZ5YZXuYpNjvXWPJ8BdaGzedH04IOG5sgF5O3H+ZTci7RSHD9p5fzKtPomfJeV
         qHv5sMkd9CqDhVTQmMiYdZaSS6rziCmd8ce9Q9UlZt+zHDuBWLAAjECqKNkHh4tzB/
         643DGtr6XXa0b8j+iPLw8osu5Ac5VaNbdXEH8DpQzmBeNR888CP/VGGdgJHhqq+Lo0
         J253yaYvIY6mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Hung <alex.hung@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        airlied@linux.ie, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 10/10] drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes
Date:   Tue, 14 Mar 2023 08:43:44 -0400
Message-Id: <20230314124344.471127-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124344.471127-1-sashal@kernel.org>
References: <20230314124344.471127-1-sashal@kernel.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 031f196d1b1b6d5dfcb0533b431e3ab1750e6189 ]

[WHY]
When PTEBufferSizeInRequests is zero, UBSAN reports the following
warning because dml_log2 returns an unexpected negative value:

  shift exponent 4294966273 is too large for 32-bit type 'int'

[HOW]

In the case PTEBufferSizeInRequests is zero, skip the dml_log2() and
assign the result directly.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c   | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 518672a2450f4..de0fa87b301a5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1868,7 +1868,10 @@ static unsigned int CalculateVMAndRowBytes(
 	}
 
 	if (SurfaceTiling == dm_sw_linear) {
-		*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
+		if (PTEBufferSizeInRequests == 0)
+			*dpte_row_height = 1;
+		else
+			*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
 		*dpte_row_width_ub = (dml_ceil(((double) SwathWidth - 1) / *PixelPTEReqWidth, 1) + 1) * *PixelPTEReqWidth;
 		*PixelPTEBytesPerRow = *dpte_row_width_ub / *PixelPTEReqWidth * *PTERequestSize;
 	} else if (ScanDirection != dm_vert) {
-- 
2.39.2

