Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65AB483387
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiACOiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiACOgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:36:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5203C08EA6F;
        Mon,  3 Jan 2022 06:33:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A836111B;
        Mon,  3 Jan 2022 14:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8CEC36AEB;
        Mon,  3 Jan 2022 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220394;
        bh=adsa5yIJ3KhbdWOnL5KPzA9BZ9b6uXnyfcdTxXVGTPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+n2cJ2/0uT/y1MMPIok8itGCtQhFDZDL3fcIxOECTpy5sR67ooczPZgwKnPH+aS5
         hjXRjbbCjtTbH9bvGOvxFm4O8avEcRL6B+ZooHMpYkFCaAYL7BqnKn1s/fxnMJ0oM2
         YNvzePVD1OxjcWzhpV7oUl23SuF57rcXuKLJJwOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chen gong <curry.gong@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 55/73] drm/amdgpu: When the VCN(1.0) block is suspended, powergating is explicitly enabled
Date:   Mon,  3 Jan 2022 15:24:16 +0100
Message-Id: <20220103142058.696993813@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chen gong <curry.gong@amd.com>

commit b7865173cf6ae59942e2c69326a06e1c1df5ecf6 upstream.

Play a video on the raven (or PCO, raven2) platform, and then do the S3
test. When resume, the following error will be reported:

amdgpu 0000:02:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring
vcn_dec test failed (-110)
[drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block
<vcn_v1_0> failed -110
amdgpu 0000:02:00.0: amdgpu: amdgpu_device_ip_resume failed (-110).
PM: dpm_run_callback(): pci_pm_resume+0x0/0x90 returns -110

[why]
When playing the video: The power state flag of the vcn block is set to
POWER_STATE_ON.

When doing suspend: There is no change to the power state flag of the
vcn block, it is still POWER_STATE_ON.

When doing resume: Need to open the power gate of the vcn block and set
the power state flag of the VCN block to POWER_STATE_ON.
But at this time, the power state flag of the vcn block is already
POWER_STATE_ON. The power status flag check in the "8f2cdef drm/amd/pm:
avoid duplicate powergate/ungate setting" patch will return the
amdgpu_dpm_set_powergating_by_smu function directly.
As a result, the gate of the power was not opened, causing the
subsequent ring test to fail.

[how]
In the suspend function of the vcn block, explicitly change the power
state flag of the vcn block to POWER_STATE_OFF.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1828
Signed-off-by: chen gong <curry.gong@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -253,6 +253,13 @@ static int vcn_v1_0_suspend(void *handle
 {
 	int r;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	bool idle_work_unexecuted;
+
+	idle_work_unexecuted = cancel_delayed_work_sync(&adev->vcn.idle_work);
+	if (idle_work_unexecuted) {
+		if (adev->pm.dpm_enabled)
+			amdgpu_dpm_enable_uvd(adev, false);
+	}
 
 	r = vcn_v1_0_hw_fini(adev);
 	if (r)


