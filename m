Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930A9172178
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgB0Nl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgB0Nl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:41:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B66C21D7E;
        Thu, 27 Feb 2020 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810886;
        bh=B4UxOXXTuyg1PM+0VTgj7Q8Xn8Vzwhv8wqGqPLP1DYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/7zxPmWKQJrh49/TEQRvrpXqPn2nXm0m33E9VXHuco+XHVQlRNnN7KhkZn3k15Fy
         MTHmTHk73INOirOrxWTxNcXAgPp28LAs7SxuYfc9EWL02xZj5hqyAVPEjcekaKSKQq
         Wwbptx3zzdTqaxbBAiD0vo/nvhO90excS3pvOlls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 035/113] drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table
Date:   Thu, 27 Feb 2020 14:35:51 +0100
Message-Id: <20200227132217.325886959@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



