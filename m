Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D8428FC6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhJKOBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234625AbhJKN7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5EBC60C49;
        Mon, 11 Oct 2021 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960572;
        bh=FjsnDtrggRwGPAXemP/SeC+RtEGOVmRcjOrNEKPRu30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/Ge9jMBF/yxPtIk3HHNleplcVvgiC4LvLZulIfSy1BbMxoihDIolEgIy5PiEeYSx
         SSmRV5OpLVqB5RNN4TGnEkOZYL2o2Kl08kcLfXDUK9hWojKsu3usxtFHJTuFo7w+wC
         wHUdZLgFhnxa731wv7N9YiNN2AY1y+81WJHUug0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciell@amd.com>
Subject: [PATCH 5.14 012/151] drm/amdgpu: During s0ix dont wait to signal GFXOFF
Date:   Mon, 11 Oct 2021 15:44:44 +0200
Message-Id: <20211011134518.256868054@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

commit 1d617c029fd9c960f8ba7a8d1a10699d820bd6b9 upstream.

In the rare event when GFX IP suspend coincides with a s0ix entry, don't
schedule a delayed work, instead signal PMFW immediately to allow GFXOFF
entry. GFXOFF is a prerequisite for s0ix entry. PMFW needs to be
signaled about GFXOFF status before amd-pmc module passes OS HINT
to PMFW telling that everything is ready for a safe s0ix entry.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1712

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -31,6 +31,8 @@
 /* delay 0.1 second to enable gfx off feature */
 #define GFX_OFF_DELAY_ENABLE         msecs_to_jiffies(100)
 
+#define GFX_OFF_NO_DELAY 0
+
 /*
  * GPU GFX IP block helpers function.
  */
@@ -558,6 +560,8 @@ int amdgpu_gfx_enable_kcq(struct amdgpu_
 
 void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable)
 {
+	unsigned long delay = GFX_OFF_DELAY_ENABLE;
+
 	if (!(adev->pm.pp_feature & PP_GFXOFF_MASK))
 		return;
 
@@ -573,8 +577,14 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
 		adev->gfx.gfx_off_req_count--;
 
-		if (adev->gfx.gfx_off_req_count == 0 && !adev->gfx.gfx_off_state)
-			schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
+		if (adev->gfx.gfx_off_req_count == 0 &&
+		    !adev->gfx.gfx_off_state) {
+			/* If going to s2idle, no need to wait */
+			if (adev->in_s0ix)
+				delay = GFX_OFF_NO_DELAY;
+			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+					      delay);
+		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {
 			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);


