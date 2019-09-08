Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA343ACDE0
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbfIHMw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbfIHMw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:28 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9BC2082C;
        Sun,  8 Sep 2019 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947147;
        bh=9/U4RluLwjBShHS6HkVe0tSSUjQVbvUK7awAmo+VLKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBS3RmX7ExHuwNJvIhRr09Xh7DM8SWe34toJQO2schG0KDT1UctOJ1wwQj/K5hDtJ
         03E2HxHNy/X2ira6k6wYVEY+bUzsbKlr0evLVXvm7aTOBAVV1QFjM/gnRUZJfYXcmB
         IoH8v1eRZOVcKDAX6eqsLMC7qdZ0xuxCbxu0N+Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nicolai=20H=C3=A4hnle?= <nicolai.haehnle@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 79/94] drm/amdgpu: prevent memory leaks in AMDGPU_CS ioctl
Date:   Sun,  8 Sep 2019 13:42:15 +0100
Message-Id: <20190908121152.696934330@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



