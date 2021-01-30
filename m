Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E21309896
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 23:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhA3WL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 17:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhA3WL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 17:11:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C154561492;
        Sat, 30 Jan 2021 22:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612044645;
        bh=77YcxH+eCPwOFkQU6sZz0QWeMg6cwRdjlKD7GsMTqwU=;
        h=From:To:Cc:Subject:Date:From;
        b=iDaX/syaAW2XrojjStjvRMKYtZEIRJgVm71qjEFEjf+FqsqaAT0btQKSTi2eaB9mM
         nu+J+UhagiBUICloKRUDvnj0MtJ5G8uFg8g2o0e+n8k7qEXiDKfDMIeMWlc1fSzIpw
         a4AvQ2POs2C+tgLjyp+Wg2BtlCoxpumaKIUMYv6o0MUgf29HJkinzONA0rOa34KpS3
         0xo7x+9fgH6iAjBGcEb3rRkm02hlChI5rkh1rdGDIG60DeIssdPB+n1HHg2Pd2AbVv
         DfadvqxXZ09Qt+Q7cm3NQdvOCbFaOVH0ifYTglX4FhQDuenq3F7mQc43oP25nho5z/
         h4RLvojt2uqfw==
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
Subject: [PATCH v4 0/2] mm: fix initialization of struct page for holes in  memory layout
Date:   Sun, 31 Jan 2021 00:10:33 +0200
Message-Id: <20210130221035.4169-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Hi,

Commit 73a6e474cb37 ("mm: memmap_init: iterate over
memblock regions rather that check each PFN") exposed several issues with
the memory map initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported back
in April [1]. It seemed back then that the problem was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and there was an additional
discussion at [3].

I didn't appreciate variety of ways BIOSes can report memory in the first
megabyte, so v3 of this set caused boot failures on several x86 systems. 
Hopefully this time I covered all the bases.

The first patch here complements commit bde9cfa3afe4 ("x86/setup: don't
remove E820_TYPE_RAM for pfn 0") for the cases when BIOS reports the first
page as absent or reserved.

The second patch is a more robust version of d3921cb8be29 ("mm: fix
initialization of struct page for holes in memory layout") that can now
handle the above cases as well.

v4:
* make sure pages in the range 0 - start_pfn_of_lowest_zone are initialized
  even if an architecture hides them from the generic mm
* finally make pfn 0 on x86 to be a part of memory visible to the generic
  mm as reserved memory.

v3: https://lore.kernel.org/lkml/20210111194017.22696-1-rppt@kernel.org
* use architectural zone constraints to set zone links for struct pages
  corresponding to the holes
* drop implicit update of memblock.memory
* add a patch that sets pfn 0 to E820_TYPE_RAM on x86

v2: https://lore.kernel.org/lkml/20201209214304.6812-1-rppt@kernel.org/):
* added patch that adds all regions in memblock.reserved that do not
overlap with memblock.memory to memblock.memory in the beginning of
free_area_init()

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org

Mike Rapoport (2):
  x86/setup: always add the beginning of RAM as memblock.memory
  mm: fix initialization of struct page for holes in memory layout

 arch/x86/kernel/setup.c |  8 ++++
 mm/page_alloc.c         | 85 ++++++++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 34 deletions(-)

-- 
2.28.0

