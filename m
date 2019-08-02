Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0807F2E3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392205AbfHBJwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391927AbfHBJwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:52:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4952064A;
        Fri,  2 Aug 2019 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739536;
        bh=W49HWKwARpa5D/ym3uOo4LYKD8a8lHya8whk1BLO9Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4HcumaPgAmKWTgZeD/YZn+8WrSgqKPiqtVbuwjha6rRi9RBPpD0Smb3aInXF5ZkO
         +CGraq8HI0d6sFagmTmLBT66WUXNwD4Dg+AskLEMXW3RjUTssO4PzBROYvr+s/yZwV
         1+9B/+aNOrAr4DqjV62/M+gsz4o81YaBNsVWywUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 195/223] powerpc/eeh: Handle hugepages in ioremap space
Date:   Fri,  2 Aug 2019 11:37:00 +0200
Message-Id: <20190802092249.910684301@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 8336b9016ca9..a7f229e59892 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -362,10 +362,19 @@ static inline unsigned long eeh_token_to_phys(unsigned long token)
 					   NULL, &hugepage_shift);
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



