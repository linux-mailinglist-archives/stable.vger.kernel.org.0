Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3061834C80D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhC2IT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232298AbhC2ISt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2F561580;
        Mon, 29 Mar 2021 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005929;
        bh=bezWuvKKjJyUVUS4m+Azpk96eTuvitpgqODjRa0cNIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjhdF3IJbXUzY95tfuk/m6jj8TusxKDKdSmtAp2lv0aA9Tv69i0bCDkKwqd8Y2+A7
         6fQjSfTaCdWxrqte5BfnMdmKkRTg3s9Cpb/Jvj5wAAdtNGiPP0oeyoK91YgerI0wwD
         /JZu18PJXUTp+64Kzcr983VGn80gKLfpN2I4VBSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tony Luck <tony.luck@intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/221] mm/fork: clear PASID for new mm
Date:   Mon, 29 Mar 2021 09:56:25 +0200
Message-Id: <20210329075630.992429766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



