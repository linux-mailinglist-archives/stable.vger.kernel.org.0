Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B684E45E573
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358598AbhKZCmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357809AbhKZCkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D481C61139;
        Fri, 26 Nov 2021 02:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894057;
        bh=/U9FxitpadGD+gXB9HlW7Ev7z2e8KTHdVeMPb3pDD9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mc1jq8f8SLjUCxpdTe2SthvM0fRV27actBnqMwPqxBXjdfyqU3RDUhz5soxlir1ET
         BH0UEA6PN3eMpyV4Ci73zBsBv2FqeDZe6PIWB7O+xAls3mVbKUfbpdr8lOOwlZKqfp
         TRty5SyuySkz6gZ0H0SCPZh1jIaazEP1tNZKyio2h323LQWpGw840B8NLQeP4PTWkt
         SO3C3THKkdAJcgGg0MQad/Zr5RdILVhlAQ356ulVfma7M1T3QHCJcnyXdNQ1LHLiWS
         iR5vrvZt8al84Dq7Bh2Uh4H1dw40/7icDwnNV3zGF6gttSHCCvYSFpcOSmChDGmmk4
         mG7GopDfdZOAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, jonathan.kim@amd.com,
        candice.li@amd.com, tao.zhou1@amd.com, kevin1.wang@amd.com,
        shaoyun.liu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 19/28] drm/amd/amdgpu: fix potential memleak
Date:   Thu, 25 Nov 2021 21:33:34 -0500
Message-Id: <20211126023343.442045-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 27dfaedc0d321b4ea4e10c53e4679d6911ab17aa ]

In function amdgpu_get_xgmi_hive, when kobject_init_and_add failed
There is a potential memleak if not call kobject_put.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Bernard Zhao <bernard@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 0526dec1d736e..042c85fc528bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -358,6 +358,7 @@ struct amdgpu_hive_info *amdgpu_get_xgmi_hive(struct amdgpu_device *adev)
 			"%s", "xgmi_hive_info");
 	if (ret) {
 		dev_err(adev->dev, "XGMI: failed initializing kobject for xgmi hive\n");
+		kobject_put(&hive->kobj);
 		kfree(hive);
 		hive = NULL;
 		goto pro_end;
-- 
2.33.0

