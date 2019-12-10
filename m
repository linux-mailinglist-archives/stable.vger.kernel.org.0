Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E01192C6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfLJVER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbfLJVEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D39C2465A;
        Tue, 10 Dec 2019 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011856;
        bh=7EI7P3PGp+T2fMFBwQoRHd94hkoswcoKdHg5xbodqNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgFM7ApjZSyNoUtxI1/CyhWeYj1yPW1+/7yjegTvI+wdbbzN4WmvAld7oxasmwLrO
         fJxna9i6u2JhF38H6vBCpUwKzJBOKeWWlrARuloWy2qIShbWJWJ32Vd65ssZ/8oSVK
         c4czsSQDKNMmGEU7592cTj1MHT0EtCeRUrJU5qGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehyun Chung <jaehyun.chung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 010/350] drm/amd/display: OTC underflow fix
Date:   Tue, 10 Dec 2019 15:58:22 -0500
Message-Id: <20191210210402.8367-10-sashal@kernel.org>
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

From: Jaehyun Chung <jaehyun.chung@amd.com>

[ Upstream commit 785908cf19c9eb4803f6bf9c0a7447dc3661d5c3 ]

[Why] Underflow occurs on some display setups(repro'd on 3x4K HDR) on boot,
mode set, and hot-plugs with. Underflow occurs because mem clk
is not set high after disabling pstate switching. This behaviour occurs
because some calculations assumed displays were synchronized.

[How] Add a condition to check if timing sync is disabled so that
synchronized vblank can be set to false.

Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 6b2f2f1a1c9ce..3980c7b782599 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1765,7 +1765,7 @@ int dcn20_populate_dml_pipes_from_context(
 			pipe_cnt = i;
 			continue;
 		}
-		if (!resource_are_streams_timing_synchronizable(
+		if (dc->debug.disable_timing_sync || !resource_are_streams_timing_synchronizable(
 				res_ctx->pipe_ctx[pipe_cnt].stream,
 				res_ctx->pipe_ctx[i].stream)) {
 			synchronized_vblank = false;
-- 
2.20.1

