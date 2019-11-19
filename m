Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8B101559
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbfKSFnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730186AbfKSFnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 178FE218BA;
        Tue, 19 Nov 2019 05:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142191;
        bh=8cx90xcuJ2/7+XJQJkGSC6D0S1sN5k36Nt1id3Is/8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5QTPll3NbfGjbghRJRB8gz4uy+zG+gzPU0HY7xlAqxP1h4+J8aQzFsFu+xez0YCO
         Y9Tts9P51J3O2YgLGaJHGN33K7Oko0hldrD+utK1ILbPLKxys6IDtv4F9xrA9pEaMd
         y+FiYf9H9l0TNm6W2eMRpplxjb2Zj6QC/PcmNasc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 420/422] s390/vdso: correct vdso mapping for compat tasks
Date:   Tue, 19 Nov 2019 06:20:17 +0100
Message-Id: <20191119051426.410191997@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 190f056fba230abee80712eb810939ef9a8c462f ]

While "s390/vdso: avoid 64-bit vdso mapping for compat tasks" fixed
64-bit vdso mapping for compat tasks under gdb it introduced another
problem. "compat_mm" flag is not inherited during fork and when
31-bit process forks a child (but does not perform exec) it ends up
with 64-bit vdso. To address that, init_new_context (which is called
during fork and exec) now initialize compat_mm based on thread TIF_31BIT
flag. Later compat_mm is adjusted in arch_setup_additional_pages, which
is called during exec.

Fixes: d1befa65823e ("s390/vdso: avoid 64-bit vdso mapping for compat tasks")
Reported-by: Stefan Liebler <stli@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/mmu_context.h | 2 +-
 arch/s390/kernel/vdso.c             | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index e4462202200d7..8d04e6f3f7964 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -25,7 +25,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	atomic_set(&mm->context.flush_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
-	mm->context.compat_mm = 0;
+	mm->context.compat_mm = test_thread_flag(TIF_31BIT);
 #ifdef CONFIG_PGSTE
 	mm->context.alloc_pgste = page_table_allocate_pgste ||
 		test_thread_flag(TIF_PGSTE) ||
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index ec31b48a42a52..7ab7d256d1eb7 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -224,10 +224,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	vdso_pages = vdso64_pages;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task()) {
+	mm->context.compat_mm = is_compat_task();
+	if (mm->context.compat_mm)
 		vdso_pages = vdso32_pages;
-		mm->context.compat_mm = 1;
-	}
 #endif
 	/*
 	 * vDSO has a problem and was disabled, just don't "enable" it for
-- 
2.20.1



