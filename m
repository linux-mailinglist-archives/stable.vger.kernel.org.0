Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9F815CB0
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEGFd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfEGFd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B7120989;
        Tue,  7 May 2019 05:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207234;
        bh=Edc69vRC5mKYb7QKWb3pJxpjsre7QfXtcHWI1l4CcIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVmCHkM7X4+AQwCt6a7cg8kE+ZLM/q6NsgD2AOfwDXzC6W7qW70rsehaE09jiIlSU
         xC8q/16GxP/Nq0SOCWfM5t0GFH96U/NQjpqQAeIPRZoB7aD8UIvNS8EIM05wZ2ATjK
         w/IW+PIfy0uEC3o9KjhrVBAOwGvj10fLiylvimxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 41/99] x86/mm: Prevent bogus warnings with "noexec=off"
Date:   Tue,  7 May 2019 01:31:35 -0400
Message-Id: <20190507053235.29900-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 510bb96fe5b3480b4b22d815786377e54cb701e7 ]

Xose Vazquez Perez reported boot warnings when NX is disabled on the kernel command line.

__early_set_fixmap() triggers this warning:

  attempted to set unsupported pgprot:    8000000000000163
			       bits:      8000000000000000
			       supported: 7fffffffffffffff

  WARNING: CPU: 0 PID: 0 at arch/x86/include/asm/pgtable.h:537
			    __early_set_fixmap+0xa2/0xff

because it uses __default_kernel_pte_mask to mask out unsupported bits.

Use __supported_pte_mask instead.

Disabling NX on the command line also triggers the NX warning in the page
table mapping check:

  WARNING: CPU: 1 PID: 1 at arch/x86/mm/dump_pagetables.c:262 note_page+0x2ae/0x650
  ....

Make the warning depend on NX set in __supported_pte_mask.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1904151037530.1729@nanos.tec.linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/dump_pagetables.c | 3 ++-
 arch/x86/mm/ioremap.c         | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index e3cdc85ce5b6..84304626b1cb 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -259,7 +259,8 @@ static void note_wx(struct pg_state *st)
 #endif
 	/* Account the WX pages */
 	st->wx_pages += npages;
-	WARN_ONCE(1, "x86/mm: Found insecure W+X mapping at address %pS\n",
+	WARN_ONCE(__supported_pte_mask & _PAGE_NX,
+		  "x86/mm: Found insecure W+X mapping at address %pS\n",
 		  (void *)st->start_address);
 }
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 5378d10f1d31..3b76fe954978 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -825,7 +825,7 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
 	pte = early_ioremap_pte(addr);
 
 	/* Sanitize 'prot' against any unsupported bits: */
-	pgprot_val(flags) &= __default_kernel_pte_mask;
+	pgprot_val(flags) &= __supported_pte_mask;
 
 	if (pgprot_val(flags))
 		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
-- 
2.20.1

