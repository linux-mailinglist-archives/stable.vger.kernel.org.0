Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CC1F04D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbfEOL1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731569AbfEOL1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A531206BF;
        Wed, 15 May 2019 11:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919667;
        bh=WP8nx96AyUwtzheXvIEkzb0woVh6i/h8Y4boJ+lHJWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkKSWTWxB4yIsvoPyiak/pcfgYMqWRnFUbe4GAqDqd1IuGkHQ+63FjUv3CAzWMFk8
         2r8WlJrnn6oVRsl0SpzgUJIDqQtoHUTfCEyBx5IqUvT6It+9aKb7H0hgxJxZ0zdOkg
         uQd7hKFDMSBTOlpsesNdEYJrjYpwbyMpFJbhXRzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 048/137] x86/mm: Prevent bogus warnings with "noexec=off"
Date:   Wed, 15 May 2019 12:55:29 +0200
Message-Id: <20190515090656.954493420@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e3cdc85ce5b6e..84304626b1cb8 100644
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
index 5378d10f1d31d..3b76fe954978c 100644
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



