Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29DE404331
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349631AbhIIBrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349449AbhIIBrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:47:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A1EE6069E;
        Thu,  9 Sep 2021 01:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631151994;
        bh=qgrvvbgVxAgBnFAp5WVpU5JvVXZIGj1Kxl6i3UuX4rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukQeNSNjpqkO/9VJqFChHuwJ9fk1T1my4fHzxd8t3yC/SVvyUlU6CdweVBARJqT52
         38ZODwEhKUGQ5w6q0PQKNNYWR1YiNaWzQyGq2GD01vvv1YS+HGBZZ9VtR8aknBQntj
         nl16F2anU9LuUiZ1t7MRKKp/dhjL+r559t4z8YAlL4RCzRCCNlvWa+2tHENP3FeZB7
         iHT8MxvnJUU0u1ks5B4l+rqystx8RGD06DNb5exkOkH5O1KC76e2yn7LfzuX2waM/C
         dB2HioSCPWYzABhUNVttF4R3PspsbFzjxZ8JLAcpWdKKwwDtd3aKyFUmNRyN0zrvVp
         V37+gK2I4FZoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        John Clements <john.clements@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 008/252] drm/amdgpu: Fix koops when accessing RAS EEPROM
Date:   Wed,  8 Sep 2021 21:42:18 -0400
Message-Id: <20210909014623.128976-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909014623.128976-1-sashal@kernel.org>
References: <20210909014623.128976-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 1d9d2ca85b32605ac9c74c8fa42d0c1cfbe019d4 ]

Debugfs RAS EEPROM files are available when
the ASIC supports RAS, and when the debugfs is
enabled, an also when "ras_enable" module
parameter is set to 0. However in this case,
we get a kernel oops when accessing some of
the "ras_..." controls in debugfs. The reason
for this is that struct amdgpu_ras::adev is
unset. This commit sets it, thus enabling access
to those facilities. Note that this facilitates
EEPROM access and not necessarily RAS features or
functionality.

Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Cc: John Clements <john.clements@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index fc66aca28594..95d5842385b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1966,11 +1966,20 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	bool exc_err_limit = false;
 	int ret;
 
-	if (adev->ras_enabled && con)
-		data = &con->eh_data;
-	else
+	if (!con)
+		return 0;
+
+	/* Allow access to RAS EEPROM via debugfs, when the ASIC
+	 * supports RAS and debugfs is enabled, but when
+	 * adev->ras_enabled is unset, i.e. when "ras_enable"
+	 * module parameter is set to 0.
+	 */
+	con->adev = adev;
+
+	if (!adev->ras_enabled)
 		return 0;
 
+	data = &con->eh_data;
 	*data = kmalloc(sizeof(**data), GFP_KERNEL | __GFP_ZERO);
 	if (!*data) {
 		ret = -ENOMEM;
@@ -1980,7 +1989,6 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	mutex_init(&con->recovery_lock);
 	INIT_WORK(&con->recovery_work, amdgpu_ras_do_recovery);
 	atomic_set(&con->in_recovery, 0);
-	con->adev = adev;
 
 	max_eeprom_records_len = amdgpu_ras_eeprom_get_record_max_length();
 	amdgpu_ras_validate_threshold(adev, max_eeprom_records_len);
-- 
2.30.2

