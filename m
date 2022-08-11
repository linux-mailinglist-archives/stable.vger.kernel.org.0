Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A3590354
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiHKQVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiHKQVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F7B1BA4;
        Thu, 11 Aug 2022 09:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47ECAB821A0;
        Thu, 11 Aug 2022 16:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E12C433C1;
        Thu, 11 Aug 2022 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233807;
        bh=DETJOHCyZk9uMEeFcuyCR2LyeCUrvN5IBA3ErPll1DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiMV67ZjMWjx9hdll8K/GSuAHwPGbe9M87/9/+9NPSDmp/OiOTBDmud3i6t9nGEPA
         MQmTpO1pAREapvIIfs7APcM3iTuQVr2uLXhmb2pobbFUxxAVO89DvaDHNRVeELn4wN
         sCTVh1aLX+qp+222AzIy8GIMDJ7Zd7BpIucIcnSAUIoY8ezCBC2h/zvg88kkxXK7gB
         wEtfrLCb0uUDT8Vav36HTgmE922SwDtyiLioOCEjdErx9ZGqWSkWzjN8m5PYrHXKon
         T6Mogqrv1mR4iYuPcXwu/gZGVvvbm7uKxKJSOdFthfIjpsoORWdfuE6FljUJJVKqD2
         NtmcwIE5iF1Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 60/69] drm/amdkfd: Correct mmu_notifier_get failure handling
Date:   Thu, 11 Aug 2022 11:56:09 -0400
Message-Id: <20220811155632.1536867-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 0593ad215359d51514c1e6c81ce28ea598efed6b ]

If process has signal pending, mmu_notifier_get_locked fails and calls
ops->free_notifier, kfd_process_free_notifier will schedule
kfd_process_wq_release as process refcount is 1, but process structure
is already freed. This use after free bug causes system crash with
different backtrace.

The fix is to increase process refcount and then decrease the refcount
after mmu_notifier_get success.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 21ec8a18cad2..bc502c378281 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1340,6 +1340,11 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 	hash_add_rcu(kfd_processes_table, &process->kfd_processes,
 			(uintptr_t)process->mm);
 
+	/* Avoid free_notifier to start kfd_process_wq_release if
+	 * mmu_notifier_get failed because of pending signal.
+	 */
+	kref_get(&process->ref);
+
 	/* MMU notifier registration must be the last call that can fail
 	 * because after this point we cannot unwind the process creation.
 	 * After this point, mmu_notifier_put will trigger the cleanup by
@@ -1352,6 +1357,7 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 	}
 	BUG_ON(mn != &process->mmu_notifier);
 
+	kfd_unref_process(process);
 	get_task_struct(process->lead_thread);
 
 	return process;
-- 
2.35.1

