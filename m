Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D5A257D63
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgHaPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgHaPa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CCAC206F0;
        Mon, 31 Aug 2020 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887829;
        bh=eJeG5xJT/gGRtkMyOdssQU+oYgX6r/G8jIetuUHAuMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7k1zZ9I44A2czb4neETM+s+9zWYaPaAVg+d0W0BeLScyajEGXUu8qv9jtFFntA3K
         WFNtORpDvAibxUpjEtfrpC6Us6acXz85O72IXJfdjjR8KArrX71eYmqXddJP90NCMO
         uLV+FWpjBln3nSwBy33NhfDE8Gy1Ox3sWtxsbNuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehyun Chung <jaehyun.chung@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 36/42] drm/amd/display: Revert HDCP disable sequence change
Date:   Mon, 31 Aug 2020 11:29:28 -0400
Message-Id: <20200831152934.1023912-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehyun Chung <jaehyun.chung@amd.com>

[ Upstream commit b61f05622ace5b9498ae279cdfd1c9f0c1ce3f75 ]

[Why]
Revert HDCP disable sequence change that blanks stream before
disabling HDCP. PSP and HW teams are currently investigating the
root cause of why HDCP cannot be disabled before stream blank,
which is expected to work without issues.

Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 31aa31c280ee6..bdddb46727b1f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3265,10 +3265,10 @@ void core_link_disable_stream(struct pipe_ctx *pipe_ctx)
 		core_link_set_avmute(pipe_ctx, true);
 	}
 
-	dc->hwss.blank_stream(pipe_ctx);
 #if defined(CONFIG_DRM_AMD_DC_HDCP)
 	update_psp_stream_config(pipe_ctx, true);
 #endif
+	dc->hwss.blank_stream(pipe_ctx);
 
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 		deallocate_mst_payload(pipe_ctx);
-- 
2.25.1

