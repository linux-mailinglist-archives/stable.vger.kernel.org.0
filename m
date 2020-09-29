Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF9127C69E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgI2Lqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbgI2LqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F81F206F7;
        Tue, 29 Sep 2020 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379975;
        bh=ErXiNWoKcmCmnEdXX6jZjW74hGLhgx2pVYvyy1Unp98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObQdtaH6pcTEuQdD0wy/whdKbqNRMpLokUmjw2uE+SDJjXMtljlWUCEeB9DAT/c6u
         gvyB1r2rDa4Xb92cSqQkvV3vG/NA2hEd+ATr29GOMUKHIoo9BLczx7v+lFVnTkpDgu
         JuYV/481ehWHKFfHwQM6FkhWUQ0lKB9Iwwd8/gRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Dennis Li <Dennis.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 12/99] drm/amdkfd: fix a memory leak issue
Date:   Tue, 29 Sep 2020 13:00:55 +0200
Message-Id: <20200929105930.331442308@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Li <Dennis.Li@amd.com>

[ Upstream commit 087d764159996ae378b08c0fdd557537adfd6899 ]

In the resume stage of GPU recovery, start_cpsch will call pm_init
which set pm->allocated as false, cause the next pm_release_ib has
no chance to release ib memory.

Add pm_release_ib in stop_cpsch which will be called in the suspend
stage of GPU recovery.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Dennis Li <Dennis.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index aa1e0f0550835..6b00cdbb08368 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1177,6 +1177,8 @@ static int stop_cpsch(struct device_queue_manager *dqm)
 	dqm->sched_running = false;
 	dqm_unlock(dqm);
 
+	pm_release_ib(&dqm->packets);
+
 	kfd_gtt_sa_free(dqm->dev, dqm->fence_mem);
 	pm_uninit(&dqm->packets, hanging);
 
-- 
2.25.1



