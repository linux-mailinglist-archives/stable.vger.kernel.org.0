Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3013783E5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhEJKsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233362AbhEJKpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3E0C619A3;
        Mon, 10 May 2021 10:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642973;
        bh=zhsHhDc8rziiQp8dl5aqQwPnQIfXVxWbAScbRMyCpp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7x11DXTohm/HXMi+FgOHSqxjsP9Wjqb+T9v+wjorrSRCR/oLcveK6tlx9kEZLVuK
         0HlPBi4SeLhN3Nq9r4ELfOMH5xc8dPza6v2HVxhhkwzhE+8mBvyNZ0QiNI9ttAbuJE
         syiiIIHn5FWpPng5dSIG8AmMeo47hXao5DRK4nU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/299] drm/amd/display: Dont optimize bandwidth before disabling planes
Date:   Mon, 10 May 2021 12:18:37 +0200
Message-Id: <20210510102008.940233346@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 6ad98e8aeb0106f453bb154933e8355849244990 ]

[Why]
There is a window of time where we optimize bandwidth due to no streams
enabled will enable PSTATE changing but HUBPs are not disabled yet.
This results in underflow counter increasing in some hotplug scenarios.

[How]
Set the optimize-bandwidth flag for later processing once all the HUBPs
are properly disabled.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index ffb21196bf59..921c4ca6e902 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2345,7 +2345,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					if (pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only)
 						pipe_ctx->stream_res.audio->funcs->az_disable(pipe_ctx->stream_res.audio);
 
-					dc->hwss.optimize_bandwidth(dc, dc->current_state);
+					dc->optimized_required = true;
+
 				} else {
 					if (dc->optimize_seamless_boot_streams == 0)
 						dc->hwss.prepare_bandwidth(dc, dc->current_state);
-- 
2.30.2



