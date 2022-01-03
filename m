Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44C4832B4
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiACOaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60946 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiACO3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B468B80EFC;
        Mon,  3 Jan 2022 14:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55C6C36AED;
        Mon,  3 Jan 2022 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220175;
        bh=uEmlorknZ4j1WY6HEon9h0FOTpjpcZa8gp1aoA334dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEAFXzkfK5Jq9KBj3MxoXx2xIO4is7K9vXU6Gub/HarV5/nYaAy88agZp6y0tgu29
         wLVYL5//CDGWRJ19oxPK7IX6XeMoOxG+eCRJDssxeVR43Y6ZhVQnpfExqp7zjsjGw4
         CZ4tcLGdZ+mAradUAjQDbwrms1OEepJ57YzduPuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chen gong <curry.gong@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 35/48] drm/amdgpu: When the VCN(1.0) block is suspended, powergating is explicitly enabled
Date:   Mon,  3 Jan 2022 15:24:12 +0100
Message-Id: <20220103142054.657357805@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
@@ -254,6 +254,13 @@ static int vcn_v1_0_suspend(void *handle
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


