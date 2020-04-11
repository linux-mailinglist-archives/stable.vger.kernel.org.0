Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB01A5AC6
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgDKXp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgDKXFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752ED21835;
        Sat, 11 Apr 2020 23:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646340;
        bh=h7bIQ/J1z0zSTp+AbT7/HkqsVIeJEoQSgkH8AnSejOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2Mj35PGBSocNb+b0gR22ZVmTE/dfktY8u1kX6lPTQLrttWaq3EKN1aeIXAB0WZ1Q
         6POKmV6N4PRREodFCW4jw574U5K6l0+NzWlc4Ec7q+N3P/R33B++cR+Wgj/yEWkMVd
         E39pz0Uc7eehKvkgGx+Pxa0CKnF4bL5ixn8yvwtk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Zhao <Yong.Zhao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 090/149] drm/amdkfd: Fix a memory leak in queue creation error handling
Date:   Sat, 11 Apr 2020 19:02:47 -0400
Message-Id: <20200411230347.22371-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhao <Yong.Zhao@amd.com>

[ Upstream commit 66f28b9a169855367d6e3ef71001969a8bffb19b ]

When the queue creation failed, some resources were not freed. Fix it.

Signed-off-by: Yong Zhao <Yong.Zhao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 31fcd1b51f00f..4f7927b661ff4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -328,6 +328,9 @@ int pqm_create_queue(struct process_queue_manager *pqm,
 	return retval;
 
 err_create_queue:
+	uninit_queue(q);
+	if (kq)
+		kernel_queue_uninit(kq, false);
 	kfree(pqn);
 err_allocate_pqn:
 	/* check if queues list is empty unregister process from device */
-- 
2.20.1

