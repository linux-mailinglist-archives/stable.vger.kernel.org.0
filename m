Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CA7498F6F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351656AbiAXTw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44236 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356679AbiAXTrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:47:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F1196154E;
        Mon, 24 Jan 2022 19:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F1EC340E5;
        Mon, 24 Jan 2022 19:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053620;
        bh=FCtfFY34iZEwAr7Qu9zfh7qbShfAkumL+e4sa31RBqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4eWQ5Uzipr0o2KXi+umApYeWrZQQozPShsC/iTD1jhjzm5n1KpX92u1+8vS9y0kc
         c2XaLwKYTDVYlduJI92zKqwz/RW3vlpds/UFzqcePD3wJW4wQ4Vy/sgDWrNA9VHGge
         /mxM1aZq82t19UHlKUZtFKD+PVZ3kL7nm2eMfJjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/563] drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
Date:   Mon, 24 Jan 2022 19:38:08 +0100
Message-Id: <20220124184028.654486911@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit b220110e4cd442156f36e1d9b4914bb9e87b0d00 ]

In amdgpu_connector_lcd_native_mode(), the return value of
drm_mode_duplicate() is assigned to mode, and there is a dereference
of it in amdgpu_connector_lcd_native_mode(), which will lead to a NULL
pointer dereference on failure of drm_mode_duplicate().

Fix this bug add a check of mode.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_DRM_AMDGPU=m show no new warnings, and
our static analyzer no longer warns about this code.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 0de66f59adb8a..df1f9b88a53f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -387,6 +387,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
+
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -401,6 +404,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
 		 * simpler.
 		 */
 		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
+		if (!mode)
+			return NULL;
+
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
 	}
-- 
2.34.1



