Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E18CD64D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbfJFRoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbfJFRoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA98D2087E;
        Sun,  6 Oct 2019 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383873;
        bh=w2whw1Hr/775putsFnagWM9RGPe7vXYrduAUtGNqhKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rE7Ude5h9TB2Y1O3qpmvgsi8NyEv2MCoCH0Mab+TSorU8LU5WJo57EnsVFn3LYjvd
         zWVVb7GmmInhFNleD0a6RjoHE7XTZUHz3PradAPwNFgss1WcyiAvttEhBaxBT16yq5
         3uYQjOf7HG2X779Q/UkMRqO6tRen9burrwGwvjU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Kees Cook <keescook@chromium.org>,
        Paul Burton <paul.burton@mips.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        James Hogan <jhogan@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 125/166] mips: properly account for stack randomization and stack guard gap
Date:   Sun,  6 Oct 2019 19:21:31 +0200
Message-Id: <20191006171223.824723710@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit b1f61b5bde3a1f50392c97b4c8513d1b8efb1cf2 ]

This commit takes care of stack randomization and stack guard gap when
computing mmap base address and checks if the task asked for
randomization.  This fixes the problem uncovered and not fixed for arm
here: https://lkml.kernel.org/r/20170622200033.25714-1-riel@redhat.com

Link: http://lkml.kernel.org/r/20190730055113.23635-10-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Paul Burton <paul.burton@mips.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Hogan <jhogan@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/mmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
index d79f2b4323187..f5c778113384b 100644
--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -21,8 +21,9 @@ unsigned long shm_align_mask = PAGE_SIZE - 1;	/* Sane caches */
 EXPORT_SYMBOL(shm_align_mask);
 
 /* gap between mmap and stack */
-#define MIN_GAP (128*1024*1024UL)
-#define MAX_GAP ((TASK_SIZE)/6*5)
+#define MIN_GAP		(128*1024*1024UL)
+#define MAX_GAP		((TASK_SIZE)/6*5)
+#define STACK_RND_MASK	(0x7ff >> (PAGE_SHIFT - 12))
 
 static int mmap_is_legacy(struct rlimit *rlim_stack)
 {
@@ -38,6 +39,15 @@ static int mmap_is_legacy(struct rlimit *rlim_stack)
 static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
+	unsigned long pad = stack_guard_gap;
+
+	/* Account for stack randomization if necessary */
+	if (current->flags & PF_RANDOMIZE)
+		pad += (STACK_RND_MASK << PAGE_SHIFT);
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
-- 
2.20.1



