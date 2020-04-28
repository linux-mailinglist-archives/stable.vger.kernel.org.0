Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737E71BC7B3
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgD1S0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgD1S0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C631620730;
        Tue, 28 Apr 2020 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098361;
        bh=Fbzklwso61IMLOubYjfCEIBGHAuX+p6DKbIr5DOMRtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ihNLzPULseabd9+RtGvpec0vwhk0S2WW5iQXod52pIxgc6h6l714lXQiGHQIGpRX
         gdkt94BX9iPQMIyi/Gr8je7lsB1a61GNRpnj3tAXHaJFjb8PfYcgL0YB8GRArkf7qE
         hxa1CnRclEcrzcBVOMDKgUKYbmZ17AMNFZadHMzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Jann Horn <jannh@google.com>
Subject: [PATCH 5.6 001/167] mm: check that mm is still valid in madvise()
Date:   Tue, 28 Apr 2020 20:22:57 +0200
Message-Id: <20200428182225.685927310@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit bc0c4d1e176eeb614dc8734fc3ace34292771f11 ]

IORING_OP_MADVISE can end up basically doing mprotect() on the VM of
another process, which means that it can race with our crazy core dump
handling which accesses the VM state without holding the mmap_sem
(because it incorrectly thinks that it is the final user).

This is clearly a core dumping problem, but we've never fixed it the
right way, and instead have the notion of "check that the mm is still
ok" using mmget_still_valid() after getting the mmap_sem for writing in
any situation where we're not the original VM thread.

See commit 04f5866e41fb ("coredump: fix race condition between
mmget_not_zero()/get_task_mm() and core dumping") for more background on
this whole mmget_still_valid() thing.  You might want to have a barf bag
handy when you do.

We're discussing just fixing this properly in the only remaining core
dumping routines.  But even if we do that, let's make do_madvise() do
the right thing, and then when we fix core dumping, we can remove all
these mmget_still_valid() checks.

Reported-and-tested-by: Jann Horn <jannh@google.com>
Fixes: c1ca757bd6f4 ("io_uring: add IORING_OP_MADVISE")
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 4bb30ed6c8d21..8cbd8c1bfe159 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -27,6 +27,7 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/sched/mm.h>
 
 #include <asm/tlb.h>
 
@@ -1090,6 +1091,23 @@ int do_madvise(unsigned long start, size_t len_in, int behavior)
 	if (write) {
 		if (down_write_killable(&current->mm->mmap_sem))
 			return -EINTR;
+
+		/*
+		 * We may have stolen the mm from another process
+		 * that is undergoing core dumping.
+		 *
+		 * Right now that's io_ring, in the future it may
+		 * be remote process management and not "current"
+		 * at all.
+		 *
+		 * We need to fix core dumping to not do this,
+		 * but for now we have the mmget_still_valid()
+		 * model.
+		 */
+		if (!mmget_still_valid(current->mm)) {
+			up_write(&current->mm->mmap_sem);
+			return -EINTR;
+		}
 	} else {
 		down_read(&current->mm->mmap_sem);
 	}
-- 
2.20.1



