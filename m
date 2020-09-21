Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11127284C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgIUOmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgIUOlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0C12311D;
        Mon, 21 Sep 2020 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699284;
        bh=Fos8BaE3bYuVzPOI84cI9gq+tooOKMU1WwPwuUcClUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWsl/s5tdTQDXrBn7HmgBRbwcMmqVQhmlSED2UaxjwJ1cwjEQLCmQpH3uPYXc4czI
         QYby9UE+IWZy2SiYaLsMOiDQHVFIAdXVkAAXDkF/wQcLiPAK8Hp/qKdPemMFt3kXD0
         jb6cK6cXWrY9Vkvbv0kxeNWzuRr0wrh4fP3CTdj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Li <Dennis.Li@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 7/9] drm/amdkfd: fix a memory leak issue
Date:   Mon, 21 Sep 2020 10:41:12 -0400
Message-Id: <20200921144114.2135773-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144114.2135773-1-sashal@kernel.org>
References: <20200921144114.2135773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

