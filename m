Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445FCF669C
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfKJCmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfKJCmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B9621924;
        Sun, 10 Nov 2019 02:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353727;
        bh=th7wnslhYVWbbN+bdqHK6xaJx3OkZv47yf17RpZ9reM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT+J4w7oobCBOEfdA6rsKsdlNiHocerTF0kGEsn4DFrW2FkThgy03AXIPBcpW4Ri/
         5IHqKK79ZY+fERAtSOkY03fcXzCgBpXon95gV9v/ALidAVOfrSAUOtlJBWMte3yb+m
         M7ElQmQD59QQ3VIsATt7c+cNC+fNjpA4lRpSOxa0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 056/191] s390/vdso: avoid 64-bit vdso mapping for compat tasks
Date:   Sat,  9 Nov 2019 21:37:58 -0500
Message-Id: <20191110024013.29782-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit d1befa65823e9c6d013883b8a41d081ec338c489 ]

vdso_fault used is_compat_task function (on s390 it tests "current"
thread_info flags) to distinguish compat tasks and map 31-bit vdso
pages. But "current" task might not correspond to mm context.

When 31-bit compat inferior is executed under gdb, gdb does
PTRACE_PEEKTEXT on vdso page, causing vdso_fault with "current" being
64-bit gdb process. So, 31-bit inferior ends up with 64-bit vdso mapped.

To avoid this problem a new compat_mm flag has been introduced into
mm context. This flag is used in vdso_fault and vdso_mremap instead
of is_compat_task.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/mmu.h         | 2 ++
 arch/s390/include/asm/mmu_context.h | 1 +
 arch/s390/kernel/vdso.c             | 8 +++++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index a8418e1379eb7..bcfb6371086f2 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -32,6 +32,8 @@ typedef struct {
 	unsigned int uses_cmm:1;
 	/* The gmaps associated with this context are allowed to use huge pages. */
 	unsigned int allow_gmap_hpage_1m:1;
+	/* The mmu context is for compat task */
+	unsigned int compat_mm:1;
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(name)						   \
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 09b61d0e491f6..e4462202200d7 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -25,6 +25,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	atomic_set(&mm->context.flush_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
+	mm->context.compat_mm = 0;
 #ifdef CONFIG_PGSTE
 	mm->context.alloc_pgste = page_table_allocate_pgste ||
 		test_thread_flag(TIF_PGSTE) ||
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 3031cc6dd0ab4..ec31b48a42a52 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -56,7 +56,7 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 	vdso_pagelist = vdso64_pagelist;
 	vdso_pages = vdso64_pages;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task()) {
+	if (vma->vm_mm->context.compat_mm) {
 		vdso_pagelist = vdso32_pagelist;
 		vdso_pages = vdso32_pages;
 	}
@@ -77,7 +77,7 @@ static int vdso_mremap(const struct vm_special_mapping *sm,
 
 	vdso_pages = vdso64_pages;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task())
+	if (vma->vm_mm->context.compat_mm)
 		vdso_pages = vdso32_pages;
 #endif
 
@@ -224,8 +224,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	vdso_pages = vdso64_pages;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task())
+	if (is_compat_task()) {
 		vdso_pages = vdso32_pages;
+		mm->context.compat_mm = 1;
+	}
 #endif
 	/*
 	 * vDSO has a problem and was disabled, just don't "enable" it for
-- 
2.20.1

