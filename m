Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35505A2369
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbfH2SPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfH2SPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DAC23403;
        Thu, 29 Aug 2019 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102529;
        bh=daF/PX4Ijm80cFU8SbPUPm1tciP79fQ1UuLIBgd+6cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekIR7PTNPIiLkcRN2lZpzqWOCTeHU+qlFkpxr2MdvtnRkJ6pn+/Nv/GQec1BcJWip
         7yz0/Nn48qGiWXJxEscfPPH2sFkaJqQhSsXZHjNvL6i6qB1490zz0jq/mwEFD37Pgc
         bJvC2HxvjJ3ARCH+/5yVhP9j76q5GRqLU9Z6YU+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Nicolai=20H=C3=A4hnle?= <nicolai.haehnle@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 65/76] drm/amdgpu: prevent memory leaks in AMDGPU_CS ioctl
Date:   Thu, 29 Aug 2019 14:13:00 -0400
Message-Id: <20190829181311.7562-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolai Hähnle <nicolai.haehnle@amd.com>

[ Upstream commit 1a701ea924815b0518733aa8d5d05c1f6fa87062 ]

Error out if the AMDGPU_CS ioctl is called with multiple SYNCOBJ_OUT and/or
TIMELINE_SIGNAL chunks, since otherwise the last chunk wins while the
allocated array as well as the reference counts of sync objects are leaked.

Signed-off-by: Nicolai Hähnle <nicolai.haehnle@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index fe028561dc0e6..bc40d6eabce7d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1192,6 +1192,9 @@ static int amdgpu_cs_process_syncobj_out_dep(struct amdgpu_cs_parser *p,
 	num_deps = chunk->length_dw * 4 /
 		sizeof(struct drm_amdgpu_cs_chunk_sem);
 
+	if (p->post_deps)
+		return -EINVAL;
+
 	p->post_deps = kmalloc_array(num_deps, sizeof(*p->post_deps),
 				     GFP_KERNEL);
 	p->num_post_deps = 0;
@@ -1215,8 +1218,7 @@ static int amdgpu_cs_process_syncobj_out_dep(struct amdgpu_cs_parser *p,
 
 
 static int amdgpu_cs_process_syncobj_timeline_out_dep(struct amdgpu_cs_parser *p,
-						      struct amdgpu_cs_chunk
-						      *chunk)
+						      struct amdgpu_cs_chunk *chunk)
 {
 	struct drm_amdgpu_cs_chunk_syncobj *syncobj_deps;
 	unsigned num_deps;
@@ -1226,6 +1228,9 @@ static int amdgpu_cs_process_syncobj_timeline_out_dep(struct amdgpu_cs_parser *p
 	num_deps = chunk->length_dw * 4 /
 		sizeof(struct drm_amdgpu_cs_chunk_syncobj);
 
+	if (p->post_deps)
+		return -EINVAL;
+
 	p->post_deps = kmalloc_array(num_deps, sizeof(*p->post_deps),
 				     GFP_KERNEL);
 	p->num_post_deps = 0;
-- 
2.20.1

