Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864DC51A9BC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356910AbiEDRTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357623AbiEDRPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EBA55233;
        Wed,  4 May 2022 09:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 219ADCE28B9;
        Wed,  4 May 2022 16:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7DCC385B1;
        Wed,  4 May 2022 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683523;
        bh=BKUXDLzplQ5j6VjlLJEEr3gBKq6Qoso3pd32RExTUsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01BMEdh+W2sh+nUpH/VAFvt0aT3uQ7mr6RFFc5InfbJ94QL1v5FP2ASIlAnuCR+fv
         ptMW2FI2qNaqpbMIPWuv/DlmF5FdXqY+KPC4TYZ/gxe+WlqG6xpfQtkbDjJ+e2r5ph
         1zewA6GXw4vBgZWJ9XVm/TxLf4RMEj3I4xTtHtf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michele Ballabio <ballabio.m@gmail.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 185/225] drm/amdgpu: dont runtime suspend if there are displays attached (v3)
Date:   Wed,  4 May 2022 18:47:03 +0200
Message-Id: <20220504153126.888301268@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit f95af4a9236695caed24fe6401256bb974e8f2a7 upstream.

We normally runtime suspend when there are displays attached if they
are in the DPMS off state, however, if something wakes the GPU
we send a hotplug event on resume (in case any displays were connected
while the GPU was in suspend) which can cause userspace to light
up the displays again soon after they were turned off.

Prior to
commit 087451f372bf76 ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's."),
the driver took a runtime pm reference when the fbdev emulation was
enabled because we didn't implement proper shadowing support for
vram access when the device was off so the device never runtime
suspended when there was a console bound.  Once that commit landed,
we now utilize the core fb helper implementation which properly
handles the emulation, so runtime pm now suspends in cases where it did
not before.  Ultimately, we need to sort out why runtime suspend in not
working in this case for some users, but this should restore similar
behavior to before.

v2: move check into runtime_suspend
v3: wake ups -> wakeups in comment, retain pm_runtime behavior in
    runtime_idle callback

Fixes: 087451f372bf76 ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Link: https://lore.kernel.org/r/20220403132322.51c90903@darkstar.example.org/
Tested-by: Michele Ballabio <ballabio.m@gmail.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |  105 +++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 35 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2348,6 +2348,71 @@ static int amdgpu_pmops_restore(struct d
 	return amdgpu_device_resume(drm_dev, true);
 }
 
+static int amdgpu_runtime_idle_check_display(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
+
+	if (adev->mode_info.num_crtc) {
+		struct drm_connector *list_connector;
+		struct drm_connector_list_iter iter;
+		int ret = 0;
+
+		/* XXX: Return busy if any displays are connected to avoid
+		 * possible display wakeups after runtime resume due to
+		 * hotplug events in case any displays were connected while
+		 * the GPU was in suspend.  Remove this once that is fixed.
+		 */
+		mutex_lock(&drm_dev->mode_config.mutex);
+		drm_connector_list_iter_begin(drm_dev, &iter);
+		drm_for_each_connector_iter(list_connector, &iter) {
+			if (list_connector->status == connector_status_connected) {
+				ret = -EBUSY;
+				break;
+			}
+		}
+		drm_connector_list_iter_end(&iter);
+		mutex_unlock(&drm_dev->mode_config.mutex);
+
+		if (ret)
+			return ret;
+
+		if (amdgpu_device_has_dc_support(adev)) {
+			struct drm_crtc *crtc;
+
+			drm_for_each_crtc(crtc, drm_dev) {
+				drm_modeset_lock(&crtc->mutex, NULL);
+				if (crtc->state->active)
+					ret = -EBUSY;
+				drm_modeset_unlock(&crtc->mutex);
+				if (ret < 0)
+					break;
+			}
+		} else {
+			mutex_lock(&drm_dev->mode_config.mutex);
+			drm_modeset_lock(&drm_dev->mode_config.connection_mutex, NULL);
+
+			drm_connector_list_iter_begin(drm_dev, &iter);
+			drm_for_each_connector_iter(list_connector, &iter) {
+				if (list_connector->dpms ==  DRM_MODE_DPMS_ON) {
+					ret = -EBUSY;
+					break;
+				}
+			}
+
+			drm_connector_list_iter_end(&iter);
+
+			drm_modeset_unlock(&drm_dev->mode_config.connection_mutex);
+			mutex_unlock(&drm_dev->mode_config.mutex);
+		}
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int amdgpu_pmops_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2360,6 +2425,10 @@ static int amdgpu_pmops_runtime_suspend(
 		return -EBUSY;
 	}
 
+	ret = amdgpu_runtime_idle_check_display(dev);
+	if (ret)
+		return ret;
+
 	/* wait for all rings to drain before suspending */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
 		struct amdgpu_ring *ring = adev->rings[i];
@@ -2469,41 +2538,7 @@ static int amdgpu_pmops_runtime_idle(str
 		return -EBUSY;
 	}
 
-	if (amdgpu_device_has_dc_support(adev)) {
-		struct drm_crtc *crtc;
-
-		drm_for_each_crtc(crtc, drm_dev) {
-			drm_modeset_lock(&crtc->mutex, NULL);
-			if (crtc->state->active)
-				ret = -EBUSY;
-			drm_modeset_unlock(&crtc->mutex);
-			if (ret < 0)
-				break;
-		}
-
-	} else {
-		struct drm_connector *list_connector;
-		struct drm_connector_list_iter iter;
-
-		mutex_lock(&drm_dev->mode_config.mutex);
-		drm_modeset_lock(&drm_dev->mode_config.connection_mutex, NULL);
-
-		drm_connector_list_iter_begin(drm_dev, &iter);
-		drm_for_each_connector_iter(list_connector, &iter) {
-			if (list_connector->dpms ==  DRM_MODE_DPMS_ON) {
-				ret = -EBUSY;
-				break;
-			}
-		}
-
-		drm_connector_list_iter_end(&iter);
-
-		drm_modeset_unlock(&drm_dev->mode_config.connection_mutex);
-		mutex_unlock(&drm_dev->mode_config.mutex);
-	}
-
-	if (ret == -EBUSY)
-		DRM_DEBUG_DRIVER("failing to power off - crtc active\n");
+	ret = amdgpu_runtime_idle_check_display(dev);
 
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_autosuspend(dev);


