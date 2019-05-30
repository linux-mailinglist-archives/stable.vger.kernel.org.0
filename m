Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A02EF74
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfE3Dzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbfE3DTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BE424837;
        Thu, 30 May 2019 03:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186347;
        bh=NmL3+EBASmUWcAlWbQujczKBhKSiMDrZbuESWkOqp/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKU1QDr1odGF4fGatDadfdZ7G5hFT54tzzVDOn41TaCRpyAzAFAj7f+P631KAXg87
         ecCWpx2KJNCRFCuNvRPsYhlG7WRMYDa5G3FGO/6pkQYPKQjKSpkcN7+Z8c9WO4v+Sb
         9PeK6s8vhVxuDXQXKAKJ1UavNr0wRWWb/nEsAeAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/193] x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc_fault()
Date:   Wed, 29 May 2019 20:05:35 -0700
Message-Id: <20190530030500.105596054@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a65c88e16f32aa9ef2e8caa68ea5c29bd5eb0ff0 ]

In-NMI warnings have been added to vmalloc_fault() via:

  ebc8827f75 ("x86: Barf when vmalloc and kmemcheck faults happen in NMI")

back in the time when our NMI entry code could not cope with nested NMIs.

These days, it's perfectly fine to take a fault in NMI context and we
don't have to care about the fact that IRET from the fault handler might
cause NMI nesting.

This warning has already been removed from 32-bit implementation of
vmalloc_fault() in:

  6863ea0cda8 ("x86/mm: Remove in_nmi() warning from vmalloc_fault()")

but the 64-bit version was omitted.

Remove the bogus warning also from 64-bit implementation of vmalloc_fault().

Reported-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 6863ea0cda8 ("x86/mm: Remove in_nmi() warning from vmalloc_fault()")
Link: http://lkml.kernel.org/r/nycvar.YFH.7.76.1904240902280.9803@cbobk.fhfr.pm
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/fault.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 794c35c4ca736..b162f92fd55cf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -426,8 +426,6 @@ static noinline int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
-	WARN_ON_ONCE(in_nmi());
-
 	/*
 	 * Copy kernel mappings over when needed. This can also
 	 * happen within a race in page table update. In the later
-- 
2.20.1



