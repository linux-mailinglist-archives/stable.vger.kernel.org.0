Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271124988B2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245426AbiAXSuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48050 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241947AbiAXStM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3FA1614B8;
        Mon, 24 Jan 2022 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE00C340E8;
        Mon, 24 Jan 2022 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050151;
        bh=mKsaHxbW+EPBqHsClG9z2i/y3TeiHVuQ+qwJ2i8cO6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chdsGUzjQTJ7s/P3PKTR5iuDDZ3vVqIQCVj/SI/Nj1KGNxPXlPUXM4VQGCpxEUsjp
         WVvCqQu+EPBfi+k3Rjv+pmHFE8BLHXoZ8MjQCvyfUZheJSfDHhnKDYAxnVyCcd3AqU
         rEW9BjHp9vGgU5lMy36EwNqmSCSX4GcS+DFhrtoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 027/114] drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
Date:   Mon, 24 Jan 2022 19:42:02 +0100
Message-Id: <20220124183927.960753077@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index e1d4115bd6732..80e3b41294e5f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -404,6 +404,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
+
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -418,6 +421,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
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



