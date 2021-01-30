Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66C5309898
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 23:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhA3WLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 17:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhA3WLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 17:11:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABFC764E13;
        Sat, 30 Jan 2021 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612044651;
        bh=NwGBqLKT4lv56fTEcCR2ndp0EzU/2WJrIaR7bVOuDq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYLXvtrD8alXfHilnW1A5oTqydktopfoSZwHOS/QQOtED+KBZs1Z4I7MOL76yYe8s
         6+CwAGpI0JrW0/OlZiYuELzreA0SC5h4cD7i7Np7kCuvLU0oAKFY0o4Lw60DYTjnKW
         N45agfUnpbuLNPpTPE5V32wNZF+GlF04S/NT/zC/NmYZaA/BjLQFFlX1opyi6rX5wh
         rDYj8xd63/Ud1rgDL3atULvLHGnCu7Qg9NkR2BxLecey5T7/jP6+LzdKuI8gBCKFAl
         9kukhwBWOhdrDmuYxmvRjcLE9/9boF1GFllpfX6wJdC2PgBtHeF44sfWDoYpmGWfel
         +OYGPt9m96CFg==
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?=C5=81ukasz=20Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as memblock.memory
Date:   Sun, 31 Jan 2021 00:10:34 +0200
Message-Id: <20210130221035.4169-2-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210130221035.4169-1-rppt@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

The physical memory on an x86 system starts at address 0, but this is not
always reflected in e820 map. For example, the BIOS can have e820 entries
like

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000001000-0x000000000009ffff] usable

or

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000001000-0x0000000000057fff] usable

In either case, e820__memblock_setup() won't add the range 0x0000 - 0x1000
to memblock.memory and later during memory map initialization this range is
left outside any zone.

With SPARSEMEM=y there is always a struct page for pfn 0 and this struct
page will have it's zone link wrong no matter what value will be set there.

To avoid this inconsistency, add the beginning of RAM to memblock.memory.
Limit the added chunk size to match the reserved memory to avoid
registering memory that may be used by the firmware but never reserved at
e820__memblock_setup() time.

Fixes: bde9cfa3afe4 ("x86/setup: don't remove E820_TYPE_RAM for pfn 0")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/setup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3412c4595efd..67c77ed6eef8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -727,6 +727,14 @@ static void __init trim_low_memory_range(void)
 	 * Kconfig help text for X86_RESERVE_LOW.
 	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
+
+	/*
+	 * Even if the firmware does not report the memory at address 0 as
+	 * usable, inform the generic memory management about its existence
+	 * to ensure it is a part of ZONE_DMA and the memory map for it is
+	 * properly initialized.
+	 */
+	memblock_add(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	
 /*
-- 
2.28.0

