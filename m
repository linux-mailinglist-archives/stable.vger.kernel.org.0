Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D97CC3AC9
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfJAQjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbfJAQju (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2681321920;
        Tue,  1 Oct 2019 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947990;
        bh=WtMBOunqzYjl4jozG6r1PE63VrycBMI8XpYf9CAn4oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvjOxzlwCFZb8zWwrEKXl6qX/pdNv0YFBqc+whfan7GG7ZKf8MsOiDdtMZ/+D0uGo
         UPqhZ1EoGCT531ockbNEhlTyV2UPAHZzA6lkToiMnsMGDk3uCrAyE5eu8a2YTmn6RJ
         nHiXBNwxmC0/b3HpMM2e1varC4AzyX8VH179nKiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 19/71] drm/amdgpu: Fix KFD-related kernel oops on Hawaii
Date:   Tue,  1 Oct 2019 12:38:29 -0400
Message-Id: <20191001163922.14735-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit dcafbd50f2e4d5cc964aae409fb5691b743fba23 ]

Hawaii needs to flush caches explicitly, submitting an IB in a user
VMID from kernel mode. There is no s_fence in this case.

Fixes: eb3961a57424 ("drm/amdgpu: remove fence context from the job")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index 7850084a05e3a..60655834d6498 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -143,7 +143,8 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned num_ibs,
 	/* ring tests don't use a job */
 	if (job) {
 		vm = job->vm;
-		fence_ctx = job->base.s_fence->scheduled.context;
+		fence_ctx = job->base.s_fence ?
+			job->base.s_fence->scheduled.context : 0;
 	} else {
 		vm = NULL;
 		fence_ctx = 0;
-- 
2.20.1

