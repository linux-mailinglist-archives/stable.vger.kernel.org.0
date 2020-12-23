Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DB2E1729
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgLWDGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgLWCS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11074225AA;
        Wed, 23 Dec 2020 02:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689886;
        bh=LDFuMUAXiZ3amM/WmFke8arjKEy476VT1qkqeIukd18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWCP9i3FnLwpEZoRZ7HCDmWfGHemA4hMdtwsNac5Jh4sk6DOv+gVThuq13I4G9uvZ
         cstBewP7jgXDQLXPYOf5SS70jrN+iBw90vrPUWVw3fHEG+IpQcUzAAoLwcmT0CoOjM
         84XQ4d9ZIKGF86BWwZ/S5rfLLlreJXzKqe2e9wXt1pY3eZJ9nosqZVKl0uo+jjZbDS
         XXn+HVx0Wd3ni0Eg6bf8N+TtLsPtOuOWFeNQvgslcEZxPW8w+D378Xvsexq2s5dnu7
         ueHC1gFywCQVBVqmhso6aZgX7OBzGg33NI98T1H/ck5JzlRk3aN14FbPfNi2FG7P0s
         2c/aPx0HGmiBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawking Zhang <Hawking.Zhang@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 075/217] drm/amdgpu: check hive pointer before access
Date:   Tue, 22 Dec 2020 21:14:04 -0500
Message-Id: <20201223021626.2790791-75-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit a9f5f98f796ee93a865b9886bf7cb694cf124eb5 ]

in case it is an invalid one

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 1162913c8bf42..ffb74fba9d867 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -395,12 +395,17 @@ void amdgpu_put_xgmi_hive(struct amdgpu_hive_info *hive)
 int amdgpu_xgmi_set_pstate(struct amdgpu_device *adev, int pstate)
 {
 	int ret = 0;
-	struct amdgpu_hive_info *hive = amdgpu_get_xgmi_hive(adev);
-	struct amdgpu_device *request_adev = hive->hi_req_gpu ?
-						hive->hi_req_gpu : adev;
+	struct amdgpu_hive_info *hive;
+	struct amdgpu_device *request_adev;
 	bool is_hi_req = pstate == AMDGPU_XGMI_PSTATE_MAX_VEGA20;
-	bool init_low = hive->pstate == AMDGPU_XGMI_PSTATE_UNKNOWN;
+	bool init_low;
+
+	hive = amdgpu_get_xgmi_hive(adev);
+	if (!hive)
+		return 0;
 
+	request_adev = hive->hi_req_gpu ? hive->hi_req_gpu : adev;
+	init_low = hive->pstate == AMDGPU_XGMI_PSTATE_UNKNOWN;
 	amdgpu_put_xgmi_hive(hive);
 	/* fw bug so temporarily disable pstate switching */
 	return 0;
-- 
2.27.0

