Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB03378655
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbhEJLFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhEJK6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735F961968;
        Mon, 10 May 2021 10:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643940;
        bh=StED5C+9xFJIbXF5NNcYncqzgF/6dFP2+isRA9tQBtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUCX2OHZ5JGF8IRBF749XZCThbTrqyRdEoAAecG2mbyYKoPHANVbJGX6wdM2T6KA5
         Am8oXbrgJTck21Ih/KhdTDT8p/S2dcz1OQeBDps9ao14ccuFFrQSnuB0Lokzl2XXI/
         +TelM4+qVXmu26KY0dLT52/i8+/yWOPaF247OhfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Werner Sembach <wse@tuxedocomputers.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 223/342] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
Date:   Mon, 10 May 2021 12:20:13 +0200
Message-Id: <20210510102017.461162224@linuxfoundation.org>
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
index 2b957d60c7b5..fa4786a8296f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5735,6 +5735,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
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



