Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2BCD701
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbfJFRia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbfJFRi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:38:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F5420700;
        Sun,  6 Oct 2019 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383507;
        bh=Rq5KCnNb5DcsX1r+Iur5At0kw9Uc65vXdmpWwLR0yhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Liap6EdTLRkGrpSIfPfKJT6hs0YEohH75p+6qLEWGoXko4VB3j1e5sEWzykpTbWCO
         nZg3UNfgb8JkZQqX6MZekNHTti4zyp8/wuGnWnWqNBXDTZgcKh/QtDArmffEbInMOo
         ofu3UIo7k4iXVyPXBChsU3OphlJWz5MY4uW/cUhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        James Hogan <jhogan@kernel.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 128/137] arm: use STACK_TOP when computing mmap base address
Date:   Sun,  6 Oct 2019 19:21:52 +0200
Message-Id: <20191006171219.997391384@linuxfoundation.org>
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

[ Upstream commit 86e568e9c0525fc40e76d827212d5e9721cf7504 ]

mmap base address must be computed wrt stack top address, using TASK_SIZE
is wrong since STACK_TOP and TASK_SIZE are not equivalent.

Link: http://lkml.kernel.org/r/20190730055113.23635-8-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
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
 arch/arm/mm/mmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index bff3d00bda5be..0b94b674aa91f 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -19,7 +19,7 @@
 
 /* gap between mmap and stack */
 #define MIN_GAP		(128*1024*1024UL)
-#define MAX_GAP		((TASK_SIZE)/6*5)
+#define MAX_GAP		((STACK_TOP)/6*5)
 #define STACK_RND_MASK	(0x7ff >> (PAGE_SHIFT - 12))
 
 static int mmap_is_legacy(struct rlimit *rlim_stack)
@@ -51,7 +51,7 @@ static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
+	return PAGE_ALIGN(STACK_TOP - gap - rnd);
 }
 
 /*
-- 
2.20.1



