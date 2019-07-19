Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AAB6DCFD
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388972AbfGSEMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388958AbfGSEMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:12:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103B72189D;
        Fri, 19 Jul 2019 04:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509565;
        bh=70rOfI1NUMza8q/+UGj7NaQBTt0XEWgZa39z5HZ3bEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPJWQlRDVA3grWZ1HnK/ywiw8JzYFYaPNJ6DvU8ZA9ZwwTXLTJoDy1tG4kFPDqFfS
         lNFXfCu5w9X7uFb9PSHr5Y6/6qMNa8QgxkeGUU38U3Rae6Q+/MYp2HVtIVixwSFOlv
         Zkq6gKIAnjP2TtrzdDT1HOSU8DYLdej7thdmTLkE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 51/60] powerpc/eeh: Handle hugepages in ioremap space
Date:   Fri, 19 Jul 2019 00:11:00 -0400
Message-Id: <20190719041109.18262-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 33439620680be5225c1b8806579a291e0d761ca0 ]

In commit 4a7b06c157a2 ("powerpc/eeh: Handle hugepages in ioremap
space") support for using hugepages in the vmalloc and ioremap areas was
enabled for radix. Unfortunately this broke EEH MMIO error checking.

Detection works by inserting a hook which checks the results of the
ioreadXX() set of functions.  When a read returns a 0xFFs response we
need to check for an error which we do by mapping the (virtual) MMIO
address back to a physical address, then mapping physical address to a
PCI device via an interval tree.

When translating virt -> phys we currently assume the ioremap space is
only populated by PAGE_SIZE mappings. If a hugepage mapping is found we
emit a WARN_ON(), but otherwise handles the check as though a normal
page was found. In pathalogical cases such as copying a buffer
containing a lot of 0xFFs from BAR memory this can result in the system
not booting because it's too busy printing WARN_ON()s.

There's no real reason to assume huge pages can't be present and we're
prefectly capable of handling them, so do that.

Fixes: 4a7b06c157a2 ("powerpc/eeh: Handle hugepages in ioremap space")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190710150517.27114-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 45322b37669a..d2ba7936d0d3 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -361,10 +361,19 @@ static inline unsigned long eeh_token_to_phys(unsigned long token)
 	ptep = find_init_mm_pte(token, &hugepage_shift);
 	if (!ptep)
 		return token;
-	WARN_ON(hugepage_shift);
-	pa = pte_pfn(*ptep) << PAGE_SHIFT;
 
-	return pa | (token & (PAGE_SIZE-1));
+	pa = pte_pfn(*ptep);
+
+	/* On radix we can do hugepage mappings for io, so handle that */
+	if (hugepage_shift) {
+		pa <<= hugepage_shift;
+		pa |= token & ((1ul << hugepage_shift) - 1);
+	} else {
+		pa <<= PAGE_SHIFT;
+		pa |= token & (PAGE_SIZE - 1);
+	}
+
+	return pa;
 }
 
 /*
-- 
2.20.1

