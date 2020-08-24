Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0762C24FA59
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgHXJzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgHXIg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16A82177B;
        Mon, 24 Aug 2020 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258185;
        bh=Mloi1uNo/05P0OXZvrdUoc2gOOK/bhXTK6JpgkvZEE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLntW7DHeErIUfPuoOXGd9tj4BGX+7IlAWWFaY0tZEaGOTHmz9YUAsfNYqNYZqmJz
         Lkpi1XIAGyFGs1Ox3JzEQLwCal6V0HtEEqjZ5+Y7ho6ttsNvq5NYqA3vrWI3CkM5RO
         d95S2QzW3ZYCXPPufTuleVCaUDolXesci73/zb6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Jessica Clarke <jrtc27@jrtc27.com>,
        Tony Luck <tony.luck@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 105/148] arch/ia64: Restore arch-specific pgd_offset_k implementation
Date:   Mon, 24 Aug 2020 10:30:03 +0200
Message-Id: <20200824082419.055928601@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Clarke <jrtc27@jrtc27.com>

[ Upstream commit bd05220c7be3356046861c317d9c287ca50445ba ]

IA-64 is special and treats pgd_offset_k() differently to pgd_offset(),
using different formulae to calculate the indices into the kernel and user
PGDs.  The index into the user PGDs takes into account the region number,
but the index into the kernel (init_mm) PGD always assumes a predefined
kernel region number. Commit 974b9b2c68f3 ("mm: consolidate pte_index() and
pte_offset_*() definitions") made IA-64 use a generic pgd_offset_k() which
incorrectly used pgd_index() for kernel page tables.  As a result, the
index into the kernel PGD was going out of bounds and the kernel hung
during early boot.

Allow overrides of pgd_offset_k() and override it on IA-64 with the old
implementation that will correctly index the kernel PGD.

Fixes: 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Jessica Clarke <jrtc27@jrtc27.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/include/asm/pgtable.h | 9 +++++++++
 include/linux/pgtable.h         | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
index 10850897a91c4..779b6972aa84b 100644
--- a/arch/ia64/include/asm/pgtable.h
+++ b/arch/ia64/include/asm/pgtable.h
@@ -366,6 +366,15 @@ pgd_index (unsigned long address)
 }
 #define pgd_index pgd_index
 
+/*
+ * In the kernel's mapped region we know everything is in region number 5, so
+ * as an optimisation its PGD already points to the area for that region.
+ * However, this also means that we cannot use pgd_index() and we must
+ * never add the region here.
+ */
+#define pgd_offset_k(addr) \
+	(init_mm.pgd + (((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1)))
+
 /* Look up a pgd entry in the gate area.  On IA-64, the gate-area
    resides in the kernel-mapped segment, hence we use pgd_offset_k()
    here.  */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 56c1e8eb7bb0a..8075f6ae185a1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -117,7 +117,9 @@ static inline pgd_t *pgd_offset_pgd(pgd_t *pgd, unsigned long address)
  * a shortcut which implies the use of the kernel's pgd, instead
  * of a process's
  */
+#ifndef pgd_offset_k
 #define pgd_offset_k(address)		pgd_offset(&init_mm, (address))
+#endif
 
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
-- 
2.25.1



