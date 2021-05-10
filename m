Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A2378828
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhEJLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233615AbhEJLJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257B561090;
        Mon, 10 May 2021 11:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644697;
        bh=IB5885nBcjCJ6uioNxv2BLZa8I3+TDo3f5Y2+oOXSCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goqWCtGT5SBFg9sPxyBQu+XJ0Ly0mmJ78GCsI2wLjGDTdtEDH9lE2Yhu2XGobD2Tp
         iFHxlfMPOVXBUD87dGORGwhA/QALhZNIeVAvCersv62n9TUFhvh7xUiqqWvdAorL1k
         jJC4vKLoWAyZ3Ox6V+zCW1d+yRJf52Q7WXL0UCDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Kim <jonathan.kim@amd.com>,
        Amber Lin <amber.lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 186/384] drm/amdgpu: mask the xgmi number of hops reported from psp to kfd
Date:   Mon, 10 May 2021 12:19:35 +0200
Message-Id: <20210510102021.021283784@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 659b385b27b5..4d3a24fdeb9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -468,15 +468,22 @@ int amdgpu_xgmi_update_topology(struct amdgpu_hive_info *hive, struct amdgpu_dev
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



