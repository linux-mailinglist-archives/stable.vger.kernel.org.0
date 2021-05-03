Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8949371C16
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhECQvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhECQtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53226162E;
        Mon,  3 May 2021 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060011;
        bh=U0vtZbOtbv/37FXM9sZyIvdfbCrAXZDCzwUYtGaShgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX9QEzRblCBjpqb5bg1WGy+BJZx0rgZiBK7mSuw1jzVy+huth+tGkMkwjq5RqblFk
         RqxzbjgSNnsyZbJwHTSE9gpwR94yztRiu40QniMRqqSdJJtgORN0lM7MLRZqwRoepl
         1HRZA/y8JHTys55oi2l+hmFKYv+MgK66pOauUsCXdQT8uYVMX/NfXx6Ju7l9TLbBi1
         bNxguCPiWxrwDjGGqTsvweO/mYt04x6R4FlnhFzDVqnyuVy19u3ZszDZ46tYDjT5hY
         qkkCTyN99YF0lTgJ9WBk6xBhrwxmvtvZrxweFYdqqYlXDqSilV+Ug5ekWgb7rW769d
         QnCOqSZmSScKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Kim <jonathan.kim@amd.com>, Amber Lin <amber.lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 20/57] drm/amdgpu: mask the xgmi number of hops reported from psp to kfd
Date:   Mon,  3 May 2021 12:39:04 -0400
Message-Id: <20210503163941.2853291-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 65aae75f80fd..ce1048bad158 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -311,15 +311,22 @@ int amdgpu_xgmi_update_topology(struct amdgpu_hive_info *hive, struct amdgpu_dev
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

