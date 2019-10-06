Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B99FCD6FD
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfJFRiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbfJFRiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:38:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 986B920700;
        Sun,  6 Oct 2019 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383500;
        bh=XYxWmfkrAOzZbg8dXacVi8SYdT7TPR48wH7ingN4Pwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aexee1EBHtLpTUZFNh7YCSLRQNv/AloY8MyvgQaEjLHVBKRb0sopcNaa3Z1K6Wyq7
         jLpOiMr7LkYwGWhb+bCSrHlv8sjmi2MnhtsZe9/IezhYTHDARn/YRjwzWqU7GeyeZ+
         v4HTGhnGXLper1FarreB8ph2JqHvsUTCwv17EapY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        James Hogan <jhogan@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 125/137] arm64: consider stack randomization for mmap base only when necessary
Date:   Sun,  6 Oct 2019 19:21:49 +0200
Message-Id: <20191006171219.731258729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit e8d54b62c55ab6201de6d195fc2c276294c1f6ae ]

Do not offset mmap base address because of stack randomization if current
task does not want randomization.  Note that x86 already implements this
behaviour.

Link: http://lkml.kernel.org/r/20190730055113.23635-4-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index b050641b51392..8dac7110f0cb5 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -54,7 +54,11 @@ unsigned long arch_mmap_rnd(void)
 static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
-	unsigned long pad = (STACK_RND_MASK << PAGE_SHIFT) + stack_guard_gap;
+	unsigned long pad = stack_guard_gap;
+
+	/* Account for stack randomization if necessary */
+	if (current->flags & PF_RANDOMIZE)
+		pad += (STACK_RND_MASK << PAGE_SHIFT);
 
 	/* Values close to RLIM_INFINITY can overflow. */
 	if (gap + pad > gap)
-- 
2.20.1



