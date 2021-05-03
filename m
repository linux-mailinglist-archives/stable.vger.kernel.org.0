Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC8A371A3C
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhECQjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhECQiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 579C0613C5;
        Mon,  3 May 2021 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059791;
        bh=6SZ9VbDmdYWkxPim/GHW/e26KKZS/got/wGz+DLlaDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxKTCeEz7eGU+dWh4CAZC42CZYWq0t50QiEs2vmKniWUh9cPeu9aBZnkump/CsZDx
         0bKxqHtfC3wqyE5m4EO0jJgHFuURMITkzfdNwoDJTwyvpw6rUcwxm0H//237wExmWR
         bUrYwk9ey4na3HNRJ34uUe3FwqdcLb20/GkKLI7GDlzXlUCMUT9C4yxzR0adjsgD4S
         rR2BXxXTeRCYh0DV+2PqCMJQHUwE/1/fe0rfxXwdBPdUOTdgocSlR2wjYPWP6fb6ZA
         dueEWIr2KWcpb989Qvke1U3lxYw4nnhEhHX1zlGgXVFx6Q7l34X87vKMYy6ECfKBtN
         CHnhduVB36s3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Jacob <Anson.Jacob@amd.com>, Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 050/134] drm/amdkfd: Fix UBSAN shift-out-of-bounds warning
Date:   Mon,  3 May 2021 12:33:49 -0400
Message-Id: <20210503163513.2851510-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 50e2fc36e72d4ad672032ebf646cecb48656efe0 ]

If get_num_sdma_queues or get_num_xgmi_sdma_queues is 0, we end up
doing a shift operation where the number of bits shifted equals
number of bits in the operand. This behaviour is undefined.

Set num_sdma_queues or num_xgmi_sdma_queues to ULLONG_MAX, if the
count is >= number of bits in the operand.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1472

Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c   | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4598a9a58125..a4266c4bca13 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1128,6 +1128,9 @@ static int set_sched_resources(struct device_queue_manager *dqm)
 
 static int initialize_cpsch(struct device_queue_manager *dqm)
 {
+	uint64_t num_sdma_queues;
+	uint64_t num_xgmi_sdma_queues;
+
 	pr_debug("num of pipes: %d\n", get_pipes_per_mec(dqm));
 
 	mutex_init(&dqm->lock_hidden);
@@ -1136,8 +1139,18 @@ static int initialize_cpsch(struct device_queue_manager *dqm)
 	dqm->active_cp_queue_count = 0;
 	dqm->gws_queue_count = 0;
 	dqm->active_runlist = false;
-	dqm->sdma_bitmap = ~0ULL >> (64 - get_num_sdma_queues(dqm));
-	dqm->xgmi_sdma_bitmap = ~0ULL >> (64 - get_num_xgmi_sdma_queues(dqm));
+
+	num_sdma_queues = get_num_sdma_queues(dqm);
+	if (num_sdma_queues >= BITS_PER_TYPE(dqm->sdma_bitmap))
+		dqm->sdma_bitmap = ULLONG_MAX;
+	else
+		dqm->sdma_bitmap = (BIT_ULL(num_sdma_queues) - 1);
+
+	num_xgmi_sdma_queues = get_num_xgmi_sdma_queues(dqm);
+	if (num_xgmi_sdma_queues >= BITS_PER_TYPE(dqm->xgmi_sdma_bitmap))
+		dqm->xgmi_sdma_bitmap = ULLONG_MAX;
+	else
+		dqm->xgmi_sdma_bitmap = (BIT_ULL(num_xgmi_sdma_queues) - 1);
 
 	INIT_WORK(&dqm->hw_exception_work, kfd_process_hw_exception);
 
-- 
2.30.2

