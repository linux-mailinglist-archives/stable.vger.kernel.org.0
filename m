Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0740DAA4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhIPNGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239699AbhIPNGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB8860ED7;
        Thu, 16 Sep 2021 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797525;
        bh=tMCxi8HdimCGu2hYlHHllEj6eJ0aYHkjxfmMs9YhhYI=;
        h=Subject:To:Cc:From:Date:From;
        b=hoWypV/5gQ2/q2tfzkM4xH1mnuL9hu0LYishysyV7mQ7TR6MGMnFNSn/mub9FeJZ7
         JgwMce4sN8ajTLlAJ9P/KOafyzOfSFWeCDvMSNwsYYVEyYYcnQeQ3H4CqXTQal5hn8
         s1QeEw4vA0nL/SCVyJJho4SAXVfNAuGP+TIp3wUQ=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when GFXOFF is disabled" failed to apply to 5.14-stable tree
To:     mdaenzer@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, evan.quan@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:05:23 +0200
Message-ID: <163179752354221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90a9266269eb9f71af1f323c33e1dca53527bd22 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>
Date: Tue, 17 Aug 2021 10:23:25 +0200
Subject: [PATCH] drm/amdgpu: Cancel delayed work when GFXOFF is disabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 41cc00e489ac..41c6b3aacd37 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2829,12 +2829,11 @@ static void amdgpu_device_delay_enable_gfx_off(struct work_struct *work)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index e7e9655c5623..e7f06bd0f0cd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -563,24 +563,38 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable)
 
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
+		if (adev->gfx.gfx_off_req_count == 0 && !adev->gfx.gfx_off_state)
+			schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
+	} else {
+		if (adev->gfx.gfx_off_req_count == 0) {
+			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
+
+			if (adev->gfx.gfx_off_state &&
+			    !amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false)) {
+				adev->gfx.gfx_off_state = false;
 
-			if (adev->gfx.funcs->init_spm_golden) {
-				dev_dbg(adev->dev, "GFXOFF is disabled, re-init SPM golden settings\n");
-				amdgpu_gfx_init_spm_golden(adev);
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
 

