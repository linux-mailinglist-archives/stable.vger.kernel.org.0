Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1AE390C7
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfFGPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbfFGPqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3589C214D8;
        Fri,  7 Jun 2019 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922390;
        bh=jvTtpQzbG1cEkU2B5JHc/GMR/EeiGG8BhcO0B2EMUYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxMBQTHt23EGSUv07w7Co1XOTr25WXvCJaq2htMeqNKzNLdIgjc65cAVryTL+hCZw
         78kFvQZE0GEmM8Hv+3G/+ZpdbORjDXuQjhq3BX4ZpBJ0noc/ztLGRSCYKMVLl55GzX
         bRhl1KbEj+bH4/KdB/+SwYsOCNJ5TLiFG9dKsQBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        akpm@linux-foundation.org, ard.biesheuvel@linaro.org,
        deneen.t.dock@intel.com, kernel-hardening@lists.openwall.com,
        kristen@linux.intel.com, linux_dti@icloud.com, will.deacon@arm.com,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 69/73] x86/kprobes: Set instruction page as executable
Date:   Fri,  7 Jun 2019 17:39:56 +0200
Message-Id: <20190607153856.531407540@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7298e24f904224fa79eb8fd7e0fbd78950ccf2db ]

Set the page as executable after allocation.  This patch is a
preparatory patch for a following patch that makes module allocated
pages non-executable.

While at it, do some small cleanup of what appears to be unnecessary
masking.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-11-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 544bc2dfe408..e83a057564d1 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -431,8 +431,20 @@ void *alloc_insn_page(void)
 	void *page;
 
 	page = module_alloc(PAGE_SIZE);
-	if (page)
-		set_memory_ro((unsigned long)page & PAGE_MASK, 1);
+	if (!page)
+		return NULL;
+
+	/*
+	 * First make the page read-only, and only then make it executable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_ro((unsigned long)page, 1);
+
+	/*
+	 * TODO: Once additional kernel code protection mechanisms are set, ensure
+	 * that the page was not maliciously altered and it is still zeroed.
+	 */
+	set_memory_x((unsigned long)page, 1);
 
 	return page;
 }
@@ -440,8 +452,12 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	set_memory_nx((unsigned long)page & PAGE_MASK, 1);
-	set_memory_rw((unsigned long)page & PAGE_MASK, 1);
+	/*
+	 * First make the page non-executable, and only then make it writable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_nx((unsigned long)page, 1);
+	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
-- 
2.20.1



