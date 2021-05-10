Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78137887D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhEJLVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237137AbhEJLL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AE8861864;
        Mon, 10 May 2021 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644852;
        bh=Uue73P2CCD+HKmLk4FjmAwNtBdF6wSFYVPw16mUU0O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVIV2CU5BnP1V0rmnTLBE2GDP6lIRIYakyu4orxF3mJJGRYQjdQkZZW6QxYvmFQrh
         VFm3pPPkQ6UUtVujTCmdPbVAIq7mhiaav4X6TpM0F5SOlJlkm4RIhoUOIIJ5YTB9KW
         0fEw1dU2TzmMaOja1m+tQt8g2GvRVSYP9vgQvCHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Werner Sembach <wse@tuxedocomputers.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 250/384] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
Date:   Mon, 10 May 2021 12:20:39 +0200
Message-Id: <20210510102023.124676468@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 68eb3ae3c63708f823aeeb63bb15197c727bd9bf ]

When encoder validation of a display mode fails, retry with less bandwidth
heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
to support 4k60Hz output, which previously failed silently.

On some setups, while the monitor and the gpu support display modes with
pixel clocks of up to 600MHz, the link encoder might not. This prevents
YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
possible. However, which color mode is used is decided before the link
encoder capabilities are checked. This patch fixes the problem by retrying
to find a display mode with YCbCr420 enforced and using it, if it is
valid.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9c243f66867a..29ca1708458c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5872,6 +5872,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
 	} while (stream == NULL && requested_bpc >= 6);
 
+	if (dc_result == DC_FAIL_ENC_VALIDATE && !aconnector->force_yuv420_output) {
+		DRM_DEBUG_KMS("Retry forcing YCbCr420 encoding\n");
+
+		aconnector->force_yuv420_output = true;
+		stream = create_validate_stream_for_sink(aconnector, drm_mode,
+						dm_state, old_stream);
+		aconnector->force_yuv420_output = false;
+	}
+
 	return stream;
 }
 
-- 
2.30.2



