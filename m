Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D410233F4BC
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 16:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhCQPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 11:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhCQPzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 11:55:18 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A174EC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 08:55:17 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 68668C800AA;
        Wed, 17 Mar 2021 16:14:34 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id ViZFGjpL2COx; Wed, 17 Mar 2021 16:14:34 +0100 (CET)
Received: from wsembach-tuxedo.fritz.box (host-212-18-30-247.customer.m-online.net [212.18.30.247])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id D5CAAC800A5;
        Wed, 17 Mar 2021 16:14:33 +0100 (CET)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     wse@tuxedocomputers.com, harry.wentland@amd.com,
        sunpeng.li@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
Date:   Wed, 17 Mar 2021 16:13:48 +0100
Message-Id: <20210317151348.11331-1-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
---

From c9398160caf4ff20e63b8ba3a4366d6ef95c4ac3 Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Wed, 17 Mar 2021 12:52:22 +0100
Subject: [PATCH] Retry forcing YCbCr420 color on failed encoder validation

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 961abf1cf040..2d16389b5f1e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5727,6 +5727,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
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
2.25.1

