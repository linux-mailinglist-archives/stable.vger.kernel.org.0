Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8446433E44D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhCQA7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhCQA6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A77C264FB4;
        Wed, 17 Mar 2021 00:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942678;
        bh=bezWuvKKjJyUVUS4m+Azpk96eTuvitpgqODjRa0cNIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaxaVArVwT9IInx8Yr5XQf7Y5wMn2c/tzQAnLX7WY9ULYLkKq/w3SsFfigBBawOFW
         veS6gmrsCzYXmQK+7g1a4+JTGSO7FkMMvOy7MAC3Ehu6fTsVwtGbdnl3F6SPVSpSwe
         sQnyJtO/6OgYGIfOrJf50F60Fs9HhHzDvCLcJrARDC2e1gWYk2h4SBJmSti/UucOVc
         i8+57YCiC6xGXUzNpAR9pU0DyJG4HizOek+iYQxS6tR2Aw0cP0oyYNtWSk3ZUW7lD+
         9yYnRCgikSaNevEK2U6nYNRZI8g3N+csZOAJ+OzOKtNJ7cY0mppbQVUQzOKhFKep8E
         0H/gAQ95woxIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fenghua Yu <fenghua.yu@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 52/54] mm/fork: clear PASID for new mm
Date:   Tue, 16 Mar 2021 20:56:51 -0400
Message-Id: <20210317005654.724862-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 82e69a121be4b1597ce758534816a8ee04c8b761 ]

When a new mm is created, its PASID should be cleared, i.e.  the PASID is
initialized to its init state 0 on both ARM and X86.

This patch was part of the series introducing mm->pasid, but got lost
along the way [1].  It still makes sense to have it, because each address
space has a different PASID.  And the IOMMU code in
iommu_sva_alloc_pasid() expects the pasid field of a new mm struct to be
cleared.

[1] https://lore.kernel.org/linux-iommu/YDgh53AcQHT+T3L0@otcwcpicx3.sc.intel.com/

Link: https://lkml.kernel.org/r/20210302103837.2562625-1-jean-philippe@linaro.org
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 1 +
 kernel/fork.c            | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 915f4f100383..3433ecc9c1f7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -23,6 +23,7 @@
 #endif
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
+#define INIT_PASID	0
 
 struct address_space;
 struct mem_cgroup;
diff --git a/kernel/fork.c b/kernel/fork.c
index c675fdbd3dce..7c044d377926 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -992,6 +992,13 @@ static void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 #endif
 }
 
+static void mm_init_pasid(struct mm_struct *mm)
+{
+#ifdef CONFIG_IOMMU_SUPPORT
+	mm->pasid = INIT_PASID;
+#endif
+}
+
 static void mm_init_uprobes_state(struct mm_struct *mm)
 {
 #ifdef CONFIG_UPROBES
@@ -1022,6 +1029,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm_init_cpumask(mm);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mm_init_pasid(mm);
 	RCU_INIT_POINTER(mm->exe_file, NULL);
 	mmu_notifier_subscriptions_init(mm);
 	init_tlb_flush_pending(mm);
-- 
2.30.1

