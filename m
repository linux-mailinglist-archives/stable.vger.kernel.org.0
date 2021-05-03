Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D32371B4D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhECQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232747AbhECQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D997861404;
        Mon,  3 May 2021 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059883;
        bh=HiySFfQOrlishZToXs2C7ozH5DsG1MGVGwzpwso2/p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/8o1a5ma5BKpJMFq7VkBkipR3a3Ma7XLKSkjCvq4WLBkggwUco4d0FyjnwZ6OZxK
         c5NE4NDoL2kv1KjHFWzTZiVZne2YqEyIslOkyzZwMeMccPZHPNJqjkiduaq+MlnSjr
         V3MZwEiCo0DV4AbPqi/L7ZLCbuEmtTWVYHIZwScbTIWCubv6drdm3l2Q5fVrbjcxp0
         RcjiW2dPRCQtFt4ifmNv79+nN0/LW9PgQ0Mlmr0XzGmEmzOTkJCMzdTxfCOtMHURXj
         xGKbcnOUx0yZocf+CZQHMnCjuPPlzUfk2nU8HRaqszj6tTvRemDcEj3Boiml5ScSqG
         aNmwVuu9RaJ/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Kim <jonathan.kim@amd.com>, Amber Lin <amber.lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 042/115] drm/amdgpu: mask the xgmi number of hops reported from psp to kfd
Date:   Mon,  3 May 2021 12:35:46 -0400
Message-Id: <20210503163700.2852194-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 4ac5617c4b7d0f0a8f879997f8ceaa14636d7554 ]

The psp supplies the link type in the upper 2 bits of the psp xgmi node
information num_hops field.  With a new link type, Aldebaran has these
bits set to a non-zero value (1 = xGMI3) so the KFD topology will report
the incorrect IO link weights without proper masking.
The actual number of hops is located in the 3 least significant bits of
this field so mask if off accordingly before passing it to the KFD.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Amber Lin <amber.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 541ef6be390f..6ef374cb3ee2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -470,15 +470,22 @@ int amdgpu_xgmi_update_topology(struct amdgpu_hive_info *hive, struct amdgpu_dev
 }
 
 
+/*
+ * NOTE psp_xgmi_node_info.num_hops layout is as follows:
+ * num_hops[7:6] = link type (0 = xGMI2, 1 = xGMI3, 2/3 = reserved)
+ * num_hops[5:3] = reserved
+ * num_hops[2:0] = number of hops
+ */
 int amdgpu_xgmi_get_hops_count(struct amdgpu_device *adev,
 		struct amdgpu_device *peer_adev)
 {
 	struct psp_xgmi_topology_info *top = &adev->psp.xgmi_context.top_info;
+	uint8_t num_hops_mask = 0x7;
 	int i;
 
 	for (i = 0 ; i < top->num_nodes; ++i)
 		if (top->nodes[i].node_id == peer_adev->gmc.xgmi.node_id)
-			return top->nodes[i].num_hops;
+			return top->nodes[i].num_hops & num_hops_mask;
 	return	-EINVAL;
 }
 
-- 
2.30.2

