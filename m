Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9982211931B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfLJVGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbfLJVEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424F7214AF;
        Tue, 10 Dec 2019 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011863;
        bh=S3vpO74YFSeyelz9fJZYMGlkUWvZr3I0b5tGoSAXwAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmGTRgb541ZIFb869zNJtlcYNS+AC/iFFTcbHjS/QuX/9kAe8vZ7h4pE/1PtZFDuB
         yzrkE6S/OIKM38SDrTK8NY4UzuO/QejYUhBScKcX39Jz/H2B6l52Qkv3++qMNm1Gi4
         xq4sLy/O0+1u8M1pZD9g5Mc26URm8Rw957kCwU9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikita Lipski <mikita.lipski@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 016/350] drm/amd/display: Rebuild mapped resources after pipe split
Date:   Tue, 10 Dec 2019 15:58:28 -0500
Message-Id: <20191210210402.8367-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

[ Upstream commit 387596ef2859c37d564ce15abddbc9063a132e2c ]

[why]
The issue is specific for linux, as on timings such as 8K@60
or 4K@144 DSC should be working in combination with ODM Combine
in order to ensure that we can run those timings. The validation
for those timings was passing, but when pipe split was happening
second pipe wasn't being programmed.

[how]
Rebuild mapped resources if we split stream for ODM.

Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 3980c7b782599..ebe67c34dabf6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2474,6 +2474,7 @@ bool dcn20_fast_validate_bw(
 							&context->res_ctx, dc->res_pool,
 							pipe, hsplit_pipe))
 						goto validate_fail;
+					dcn20_build_mapped_resource(dc, context, pipe->stream);
 				} else
 					dcn20_split_stream_for_mpc(
 						&context->res_ctx, dc->res_pool,
-- 
2.20.1

