Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41A378619
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhEJLDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhEJK5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D436194B;
        Mon, 10 May 2021 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643820;
        bh=gAVXaa3NI2xdJ61efYa5M26EA5yeVATgEjR2hwATB8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sh6zz6SHysadeCowgvh2p+IYJPxPhRu/jDRELrK9eBN5dW1cQTrN7g76EH0S6lrAZ
         x1WHuiV+uinV8Ed51/dK+/AhfCK1fScKb4ZZp9MyaDBJHXmVDtuBeEeBBAr0F3HUUe
         Gxa+IrlcBzkbGOcmUVKjsOwTkn8ZTZTrSXoFvJJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 137/342] drm/amd/display: Dont optimize bandwidth before disabling planes
Date:   Mon, 10 May 2021 12:18:47 +0200
Message-Id: <20210510102014.598779176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
index 58eb0d69873a..ccac86347315 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2380,7 +2380,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
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



