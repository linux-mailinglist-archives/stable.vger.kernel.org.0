Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5B3FDB11
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbhIAMhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343577AbhIAMgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F59D610D1;
        Wed,  1 Sep 2021 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499607;
        bh=ifS5Qzi2k5S0M7AjO1Tq/J2xLK4dJ1qHYzSKu7dnM/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9C4X8NAGFngZWDxdC1lbuZvN69tpy3aztkAOgpdGW7mIfJzEjOl4yQwb0sB/NDta
         vLUY/dPAtR98HzdB3RciCX24usjIuB2NdCRjRAy+7v0T7KdGSxGADitFPi0Njg0PAz
         PmSN9RBom1sGVyaMhKCSWDpwkdCabhFvb14pOGEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 016/103] drm/amdgpu: Cancel delayed work when GFXOFF is disabled
Date:   Wed,  1 Sep 2021 14:27:26 +0200
Message-Id: <20210901122301.075406014@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

commit 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016 upstream.

schedule_delayed_work does not push back the work if it was already
scheduled before, so amdgpu_device_delay_enable_gfx_off ran ~100 ms
after the first time GFXOFF was disabled and re-enabled, even if GFXOFF
was disabled and re-enabled again during those 100 ms.

This resulted in frame drops / stutter with the upcoming mutter 41
release on Navi 14, due to constantly enabling GFXOFF in the HW and
disabling it again (for getting the GPU clock counter).

To fix this, call cancel_delayed_work_sync when the disable count
transitions from 0 to 1, and only schedule the delayed work on the
reverse transition, not if the disable count was already 0. This makes
sure the delayed work doesn't run at unexpected times, and allows it to
be lock-free.

v2:
* Use cancel_delayed_work_sync & mutex_trylock instead of
  mod_delayed_work.
v3:
* Make amdgpu_device_delay_enable_gfx_off lock-free (Christian König)
v4:
* Fix race condition between amdgpu_gfx_off_ctrl incrementing
  adev->gfx.gfx_off_req_count and amdgpu_device_delay_enable_gfx_off
  checking for it to be 0 (Evan Quan)

Cc: stable@vger.kernel.org
Reviewed-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com> # v3
Acked-by: Christian König <christian.koenig@amd.com> # v3
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    |   38 +++++++++++++++++++----------
 2 files changed, 31 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2619,12 +2619,11 @@ static void amdgpu_device_delay_enable_g
 	struct amdgpu_device *adev =
 		container_of(work, struct amdgpu_device, gfx.gfx_off_delay_work.work);
 
-	mutex_lock(&adev->gfx.gfx_off_mutex);
-	if (!adev->gfx.gfx_off_state && !adev->gfx.gfx_off_req_count) {
-		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, true))
-			adev->gfx.gfx_off_state = true;
-	}
-	mutex_unlock(&adev->gfx.gfx_off_mutex);
+	WARN_ON_ONCE(adev->gfx.gfx_off_state);
+	WARN_ON_ONCE(adev->gfx.gfx_off_req_count);
+
+	if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, true))
+		adev->gfx.gfx_off_state = true;
 }
 
 /**
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -556,24 +556,38 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
 	mutex_lock(&adev->gfx.gfx_off_mutex);
 
-	if (!enable)
-		adev->gfx.gfx_off_req_count++;
-	else if (adev->gfx.gfx_off_req_count > 0)
+	if (enable) {
+		/* If the count is already 0, it means there's an imbalance bug somewhere.
+		 * Note that the bug may be in a different caller than the one which triggers the
+		 * WARN_ON_ONCE.
+		 */
+		if (WARN_ON_ONCE(adev->gfx.gfx_off_req_count == 0))
+			goto unlock;
+
 		adev->gfx.gfx_off_req_count--;
 
-	if (enable && !adev->gfx.gfx_off_state && !adev->gfx.gfx_off_req_count) {
-		schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
-	} else if (!enable && adev->gfx.gfx_off_state) {
-		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false)) {
-			adev->gfx.gfx_off_state = false;
-
-			if (adev->gfx.funcs->init_spm_golden) {
-				dev_dbg(adev->dev, "GFXOFF is disabled, re-init SPM golden settings\n");
-				amdgpu_gfx_init_spm_golden(adev);
+		if (adev->gfx.gfx_off_req_count == 0 && !adev->gfx.gfx_off_state)
+			schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
+	} else {
+		if (adev->gfx.gfx_off_req_count == 0) {
+			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
+
+			if (adev->gfx.gfx_off_state &&
+			    !amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false)) {
+				adev->gfx.gfx_off_state = false;
+
+				if (adev->gfx.funcs->init_spm_golden) {
+					dev_dbg(adev->dev,
+						"GFXOFF is disabled, re-init SPM golden settings\n");
+					amdgpu_gfx_init_spm_golden(adev);
+				}
 			}
 		}
+
+		adev->gfx.gfx_off_req_count++;
 	}
 
+unlock:
 	mutex_unlock(&adev->gfx.gfx_off_mutex);
 }
 


