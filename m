Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8037CE80
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344958AbhELRF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235082AbhELQn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B90D561E65;
        Wed, 12 May 2021 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836034;
        bh=Uw4zMh0hffjrCLZweQDEHzwzp0y3nGZX4Zaz31ON8b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi0KUtdBMT4ZA6RX+tfYYZ2A4CWTG6cOgF5ywTCZ+6z6fbK+XshybPhvC4RneYwio
         XLN7roEV7pxQt+TScmUDppkzC2DvI5kZgegrWQZ+iOOaMW5KJxqECJkYbSmpBh315P
         FHyiMiWHb1zFPxsYneCGbsUnFBWN1VsWHwCrxmsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 583/677] drm/amdgpu: fix an error code in init_pmu_entry_by_type_and_add()
Date:   Wed, 12 May 2021 16:50:29 +0200
Message-Id: <20210512144856.758967825@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 90cb3d8aca1baea9471d28f28d5de1528dd5e424 ]

If the kmemdup() fails then this should return a negative error code
but it currently returns success

Fixes: b4a7db71ea06 ("drm/amdgpu: add per device user friendly xgmi events for vega20")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c
index 19c0a3655228..82e9ecf84352 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c
@@ -519,8 +519,10 @@ static int init_pmu_entry_by_type_and_add(struct amdgpu_pmu_entry *pmu_entry,
 	pmu_entry->pmu.attr_groups = kmemdup(attr_groups, sizeof(attr_groups),
 								GFP_KERNEL);
 
-	if (!pmu_entry->pmu.attr_groups)
+	if (!pmu_entry->pmu.attr_groups) {
+		ret = -ENOMEM;
 		goto err_attr_group;
+	}
 
 	snprintf(pmu_name, PMU_NAME_SIZE, "%s_%d", pmu_entry->pmu_file_prefix,
 				adev_to_drm(pmu_entry->adev)->primary->index);
-- 
2.30.2



