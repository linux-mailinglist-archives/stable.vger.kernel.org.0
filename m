Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138CD15E2B3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406010AbgBNQYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406006AbgBNQYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14B6247A6;
        Fri, 14 Feb 2020 16:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697491;
        bh=B4UxOXXTuyg1PM+0VTgj7Q8Xn8Vzwhv8wqGqPLP1DYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZ97afB+Pbq/HkbqgjLb5uzx6FUKPFAEfpRJ/MblqrdtpECCS6gjaiZFKTu4mkJva
         1y4oz8ESwFrNi4q77QeqFv8JDEcSYKuHzYf3KrKpdQWjYNVHITUFUCcvbglOSiblU0
         1zTC3zAA+/D+TjhIWlfi20jcLkd1u5kq6hehPT80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 021/100] drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table
Date:   Fri, 14 Feb 2020 11:23:05 -0500
Message-Id: <20200214162425.21071-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit bae028e3e521e8cb8caf2cc16a455ce4c55f2332 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c: In function
'amdgpu_atombios_get_connector_info_from_object_table':
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c:376:26: warning: variable
'grph_obj_num' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c:376:13: warning: variable
'grph_obj_id' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c:341:37: warning: variable
'con_obj_type' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c:341:24: warning: variable
'con_obj_num' set but not used [-Wunused-but-set-variable]

They are never used, so can be removed.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 3e90ddcbb24a7..d799927d3a5de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -319,17 +319,9 @@ bool amdgpu_atombios_get_connector_info_from_object_table(struct amdgpu_device *
 		path_size += le16_to_cpu(path->usSize);
 
 		if (device_support & le16_to_cpu(path->usDeviceTag)) {
-			uint8_t con_obj_id, con_obj_num, con_obj_type;
-
-			con_obj_id =
+			uint8_t con_obj_id =
 			    (le16_to_cpu(path->usConnObjectId) & OBJECT_ID_MASK)
 			    >> OBJECT_ID_SHIFT;
-			con_obj_num =
-			    (le16_to_cpu(path->usConnObjectId) & ENUM_ID_MASK)
-			    >> ENUM_ID_SHIFT;
-			con_obj_type =
-			    (le16_to_cpu(path->usConnObjectId) &
-			     OBJECT_TYPE_MASK) >> OBJECT_TYPE_SHIFT;
 
 			/* Skip TV/CV support */
 			if ((le16_to_cpu(path->usDeviceTag) ==
@@ -354,14 +346,7 @@ bool amdgpu_atombios_get_connector_info_from_object_table(struct amdgpu_device *
 			router.ddc_valid = false;
 			router.cd_valid = false;
 			for (j = 0; j < ((le16_to_cpu(path->usSize) - 8) / 2); j++) {
-				uint8_t grph_obj_id, grph_obj_num, grph_obj_type;
-
-				grph_obj_id =
-				    (le16_to_cpu(path->usGraphicObjIds[j]) &
-				     OBJECT_ID_MASK) >> OBJECT_ID_SHIFT;
-				grph_obj_num =
-				    (le16_to_cpu(path->usGraphicObjIds[j]) &
-				     ENUM_ID_MASK) >> ENUM_ID_SHIFT;
+				uint8_t grph_obj_type=
 				grph_obj_type =
 				    (le16_to_cpu(path->usGraphicObjIds[j]) &
 				     OBJECT_TYPE_MASK) >> OBJECT_TYPE_SHIFT;
-- 
2.20.1

