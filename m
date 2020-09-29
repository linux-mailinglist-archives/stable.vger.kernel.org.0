Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2000227C58D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgI2Lgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbgI2LgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF37D23D9C;
        Tue, 29 Sep 2020 11:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379059;
        bh=Fos8BaE3bYuVzPOI84cI9gq+tooOKMU1WwPwuUcClUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzTcw9NT787aKCop7CMG22gqHb6y/LyA67jcc/qsHdE9fcmjzHVczaFyRdNvLKsCN
         Xj3WlKNIS8MaGWwl/4elOjfHLoyyCgP4Z/p699iHBCJp2OvgONLK5lvMbam9fGzI6N
         2kphv25kaZL2gzOZOCZsOeM7VGe2MhoW01lZA/UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Dennis Li <Dennis.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/245] drm/amdkfd: fix a memory leak issue
Date:   Tue, 29 Sep 2020 13:01:03 +0200
Message-Id: <20200929105957.289993913@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 189212cb35475..bff39f561264e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1101,6 +1101,8 @@ static int stop_cpsch(struct device_queue_manager *dqm)
 	unmap_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES, 0);
 	dqm_unlock(dqm);
 
+	pm_release_ib(&dqm->packets);
+
 	kfd_gtt_sa_free(dqm->dev, dqm->fence_mem);
 	pm_uninit(&dqm->packets);
 
-- 
2.25.1



