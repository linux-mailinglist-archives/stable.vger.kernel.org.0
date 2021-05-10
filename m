Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587DD378617
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhEJLDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234885AbhEJK5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83614619CB;
        Mon, 10 May 2021 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643811;
        bh=HiySFfQOrlishZToXs2C7ozH5DsG1MGVGwzpwso2/p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc53j1r32RlierhYBFgKrJT0YrtHlmTCvADw2EmYDRJc2i+MtL6t8OnLz1Guf33tU
         f6FHrNutz2yE3k7+uuF99Ncm30hGUtiyyOeq+3YqSXHmdiB40E60D79lneGfefloJ3
         qzhT+BUAgL+aR8/M4RXNp/hB+LabtU9gfWI03unU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Kim <jonathan.kim@amd.com>,
        Amber Lin <amber.lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 167/342] drm/amdgpu: mask the xgmi number of hops reported from psp to kfd
Date:   Mon, 10 May 2021 12:19:17 +0200
Message-Id: <20210510102015.606305050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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



