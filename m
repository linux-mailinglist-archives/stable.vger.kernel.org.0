Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB31915EA59
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404023AbgBNRND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403824AbgBNQM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:12:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88132246A1;
        Fri, 14 Feb 2020 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696777;
        bh=RqJS7QbbRmZS0WLnFBjn58eX5kSMkaGaf7vbD4wQ2l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUDSUXEcWdkDnfrucWXHoJzitJgvz1u3AGcUCtZyiHpReMVd8FePgnG3YEFaSPpim
         Dw5dMbd6MnsFN9x2Vp3rQaWfL1TeOqx4uiQroJ2oT6Od1NyB88Twb8vEnLkbKBLT+V
         +Zebow2LRUgnKnfcxG50m8d/LXfu3RUcF/AKcFzc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 054/252] drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table
Date:   Fri, 14 Feb 2020 11:08:29 -0500
Message-Id: <20200214161147.15842-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
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
index bf872f694f509..d1fbaea91f580 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -337,17 +337,9 @@ bool amdgpu_atombios_get_connector_info_from_object_table(struct amdgpu_device *
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
@@ -372,14 +364,7 @@ bool amdgpu_atombios_get_connector_info_from_object_table(struct amdgpu_device *
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

