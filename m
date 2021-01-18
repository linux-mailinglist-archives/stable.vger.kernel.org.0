Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6344A2FA306
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbhARO3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:29:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390139AbhARLos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6050622D6D;
        Mon, 18 Jan 2021 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970224;
        bh=HV2frnwtu6B74HzSNuvEVkClN8N/xniPy+m3wZZ1cuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCUEMhm6RlvodN1Ql94QjtLrYsQgt0iubAaRr7TT0S90bZjL2DWk6cI/9WrkWfq6g
         gTe/jYI1tFhS0MsCWkW5fZBm7w3E5rPL3jOmvavNjLsZe+JhJ1qtCY7j5+3AkiooIy
         7ppEx/ct5lhxLHZQcvqobax1RRAaF0wZLBe6XCkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Li <Dennis.Li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/152] drm/amdgpu: fix a GPU hang issue when remove device
Date:   Mon, 18 Jan 2021 12:34:24 +0100
Message-Id: <20210118113357.021053981@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Li <Dennis.Li@amd.com>

[ Upstream commit 88e21af1b3f887d217f2fb14fc7e7d3cd87ebf57 ]

When GFXOFF is enabled and GPU is idle, driver will fail to access some
registers. Therefore change to disable power gating before all access
registers with MMIO.

Dmesg log is as following:
amdgpu 0000:03:00.0: amdgpu: amdgpu: finishing device.
amdgpu: cp queue pipe 4 queue 0 preemption failed
amdgpu 0000:03:00.0: amdgpu: failed to write reg 2890 wait reg 28a2
amdgpu 0000:03:00.0: amdgpu: failed to write reg 1a6f4 wait reg 1a706
amdgpu 0000:03:00.0: amdgpu: failed to write reg 2890 wait reg 28a2
amdgpu 0000:03:00.0: amdgpu: failed to write reg 1a6f4 wait reg 1a706

Signed-off-by: Dennis Li <Dennis.Li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 523fbef67591c..2ddbcfe0a72ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2524,11 +2524,11 @@ static int amdgpu_device_ip_fini(struct amdgpu_device *adev)
 	if (adev->gmc.xgmi.num_physical_nodes > 1)
 		amdgpu_xgmi_remove_device(adev);
 
-	amdgpu_amdkfd_device_fini(adev);
-
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
+	amdgpu_amdkfd_device_fini(adev);
+
 	/* need to disable SMC first */
 	for (i = 0; i < adev->num_ip_blocks; i++) {
 		if (!adev->ip_blocks[i].status.hw)
-- 
2.27.0



