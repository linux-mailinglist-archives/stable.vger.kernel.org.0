Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF76D258B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387736AbfJJImK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388481AbfJJImI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25A721A4C;
        Thu, 10 Oct 2019 08:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696928;
        bh=WtMBOunqzYjl4jozG6r1PE63VrycBMI8XpYf9CAn4oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUY3j8Mzm+Xc3kO/xDGJadtj6RzS193Mjj/y/UREr75eacxEoSGKw5iQDByM9v3X0
         VGzrwvwBUeViOMSX+dBt4kMszXiAOYooDyznQTUmDy3ApSxaeCrTzLigDSmWAxkd9K
         WkWy9co/ASMmkEf2pemdVmZOIWW80bbnKoYjlfhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 104/148] drm/amdgpu: Fix KFD-related kernel oops on Hawaii
Date:   Thu, 10 Oct 2019 10:36:05 +0200
Message-Id: <20191010083617.506295681@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



