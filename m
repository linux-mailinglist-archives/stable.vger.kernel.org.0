Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A2A6ECE6E
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjDXNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjDXNcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53E7EC0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E153E6230D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E97C433EF;
        Mon, 24 Apr 2023 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343109;
        bh=+yTV0WLWqJzHYzsV2DuMvVc915oMZBAc/9+AmvPskkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zim65XuZuPyTp4G5pz6yz2+JHU8GNRXcF4UJTxZmP35YRi/eOztTgW01wTKWZU9X4
         /98if9SZ0KfpAH2NzKihfAGS19AVtO7PHdu3jAPDVCDdfCpnrt7pjj58fx0WdM7Ja3
         KGeGeUJtQ5uPNz29zRfb4frboyBHtLLluHQvANeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Liu <HaoPing.Liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 081/110] drm/amdgpu: Fix desktop freezed after gpu-reset
Date:   Mon, 24 Apr 2023 15:17:43 +0200
Message-Id: <20230424131139.495083118@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Liu <HaoPing.Liu@amd.com>

commit c8b5a95b570949536a2b75cd8fc4f1de0bc60629 upstream.

[Why]
After gpu-reset, sometimes the driver fails to enable vblank irq,
causing flip_done timed out and the desktop freezed.

During gpu-reset, we disable and enable vblank irq in dm_suspend() and
dm_resume(). Later on in amdgpu_irq_gpu_reset_resume_helper(), we check
irqs' refcount and decide to enable or disable the irqs again.

However, we have 2 sets of API for controling vblank irq, one is
dm_vblank_get/put() and another is amdgpu_irq_get/put(). Each API has
its own refcount and flag to store the state of vblank irq, and they
are not synchronized.

In drm we use the first API to control vblank irq but in
amdgpu_irq_gpu_reset_resume_helper() we use the second set of API.

The failure happens when vblank irq was enabled by dm_vblank_get()
before gpu-reset, we have vblank->enabled true. However, during
gpu-reset, in amdgpu_irq_gpu_reset_resume_helper() vblank irq's state
checked from amdgpu_irq_update() is DISABLED. So finally it disables
vblank irq again. After gpu-reset, if there is a cursor plane commit,
the driver will try to enable vblank irq by calling drm_vblank_enable(),
but the vblank->enabled is still true, so it fails to turn on vblank
irq and causes flip_done can't be completed in vblank irq handler and
desktop become freezed.

[How]
Combining the 2 vblank control APIs by letting drm's API finally calls
amdgpu_irq's API, so the irq's refcount and state of both APIs can be
synchronized. Also add a check to prevent refcount from being less then
0 in amdgpu_irq_put().

v2:
- Add warning in amdgpu_irq_enable() if the irq is already disabled.
- Call dc_interrupt_set() in dm_set_vblank() to avoid refcount change
  if it is in gpu-reset.

v3:
- Improve commit message and code comments.

Signed-off-by: Alan Liu <HaoPing.Liu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                |    3 +++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   17 ++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -597,6 +597,9 @@ int amdgpu_irq_put(struct amdgpu_device
 	if (!src->enabled_types || !src->funcs->set)
 		return -EINVAL;
 
+	if (WARN_ON(!amdgpu_irq_enabled(adev, src, type)))
+		return -EINVAL;
+
 	if (atomic_dec_and_test(&src->enabled_types[type]))
 		return amdgpu_irq_update(adev, src, type);
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -170,10 +170,21 @@ static inline int dm_set_vblank(struct d
 	if (rc)
 		return rc;
 
-	irq_source = IRQ_TYPE_VBLANK + acrtc->otg_inst;
+	if (amdgpu_in_reset(adev)) {
+		irq_source = IRQ_TYPE_VBLANK + acrtc->otg_inst;
+		/* During gpu-reset we disable and then enable vblank irq, so
+		 * don't use amdgpu_irq_get/put() to avoid refcount change.
+		 */
+		if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
+			rc = -EBUSY;
+	} else {
+		rc = (enable)
+			? amdgpu_irq_get(adev, &adev->crtc_irq, acrtc->crtc_id)
+			: amdgpu_irq_put(adev, &adev->crtc_irq, acrtc->crtc_id);
+	}
 
-	if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
-		return -EBUSY;
+	if (rc)
+		return rc;
 
 skip:
 	if (amdgpu_in_reset(adev))


