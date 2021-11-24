Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A544145C643
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354117AbhKXOGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356549AbhKXOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687E763339;
        Wed, 24 Nov 2021 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759480;
        bh=SFu95jzYMAn0O+nI+6/w3Lfa6B70SH31MwIdr7W4dCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9lPWvKc9alBOop58h98nU72zLFhMilMAYo+Icbq7FbkdGR7pryT5Aguo0aLmhW7v
         UPvVDIrS5+bhzTnH48ND7QnKzbW97qHZ4EYvJg7LP19+HcuGAdOjgTmuwOxJxeIbs9
         vgrZLV7AoozlwOAcTocLE32guqcbwNbBtbXiNfS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Borislav Petkov <bp@suse.de>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 255/279] drm/amd/pm: avoid duplicate powergate/ungate setting
Date:   Wed, 24 Nov 2021 12:59:02 +0100
Message-Id: <20211124115727.540167372@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 6ee27ee27ba8b2e725886951ba2d2d87f113bece upstream.

Just bail out if the target IP block is already in the desired
powergate/ungate state. This can avoid some duplicate settings
which sometimes may cause unexpected issues.

Link: https://lore.kernel.org/all/YV81vidWQLWvATMM@zn.tnic/
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214921
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=215025
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1789
Fixes: bf756fb833cb ("drm/amdgpu: add missing cleanups for Polaris12 UVD/VCE on suspend")
Signed-off-by: Evan Quan <evan.quan@amd.com>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +++
 drivers/gpu/drm/amd/include/amd_shared.h   |    3 ++-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c        |   10 ++++++++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h    |    8 ++++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3532,6 +3532,9 @@ int amdgpu_device_init(struct amdgpu_dev
 		adev->rmmio_size = pci_resource_len(adev->pdev, 2);
 	}
 
+	for (i = 0; i < AMD_IP_BLOCK_TYPE_NUM; i++)
+		atomic_set(&adev->pm.pwr_state[i], POWER_STATE_UNKNOWN);
+
 	adev->rmmio = ioremap(adev->rmmio_base, adev->rmmio_size);
 	if (adev->rmmio == NULL) {
 		return -ENOMEM;
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -98,7 +98,8 @@ enum amd_ip_block_type {
 	AMD_IP_BLOCK_TYPE_ACP,
 	AMD_IP_BLOCK_TYPE_VCN,
 	AMD_IP_BLOCK_TYPE_MES,
-	AMD_IP_BLOCK_TYPE_JPEG
+	AMD_IP_BLOCK_TYPE_JPEG,
+	AMD_IP_BLOCK_TYPE_NUM,
 };
 
 enum amd_clockgating_state {
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -927,6 +927,13 @@ int amdgpu_dpm_set_powergating_by_smu(st
 {
 	int ret = 0;
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
+	enum ip_power_state pwr_state = gate ? POWER_STATE_OFF : POWER_STATE_ON;
+
+	if (atomic_read(&adev->pm.pwr_state[block_type]) == pwr_state) {
+		dev_dbg(adev->dev, "IP block%d already in the target %s state!",
+				block_type, gate ? "gate" : "ungate");
+		return 0;
+	}
 
 	switch (block_type) {
 	case AMD_IP_BLOCK_TYPE_UVD:
@@ -979,6 +986,9 @@ int amdgpu_dpm_set_powergating_by_smu(st
 		break;
 	}
 
+	if (!ret)
+		atomic_set(&adev->pm.pwr_state[block_type], pwr_state);
+
 	return ret;
 }
 
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -417,6 +417,12 @@ struct amdgpu_dpm {
 	enum amd_dpm_forced_level forced_level;
 };
 
+enum ip_power_state {
+	POWER_STATE_UNKNOWN,
+	POWER_STATE_ON,
+	POWER_STATE_OFF,
+};
+
 struct amdgpu_pm {
 	struct mutex		mutex;
 	u32                     current_sclk;
@@ -452,6 +458,8 @@ struct amdgpu_pm {
 	struct i2c_adapter smu_i2c;
 	struct mutex		smu_i2c_mutex;
 	struct list_head	pm_attr_list;
+
+	atomic_t		pwr_state[AMD_IP_BLOCK_TYPE_NUM];
 };
 
 #define R600_SSTU_DFLT                               0


