Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580343259C5
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 23:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBYWo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 17:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhBYWox (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 17:44:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E278864ED3;
        Thu, 25 Feb 2021 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614293052;
        bh=Cv8v/GiuqByyrsc3Zdvatk4vl+jl5WdA99J73Bv9URs=;
        h=From:To:Cc:Subject:Date:From;
        b=J2tQwbwhNvMJKH/6gGrjy3qmddFKuRCgNB06NY5U/f47LC3KrCxvGPRzFNXtgWMu/
         40V3qKjrZkdPC8j523yvMpN/z2q2zFQ4v6plwFk+sXozMqSr5kFxE+UQ7vOJ3GE0oX
         0jgGonicQZbQoZ7G9UBihklkxd+UXhCOSpuJRvDhKfASx+GP/kZMRZ7zNKSZ745PIE
         MGjSEkuQTniUdQdA69qGb9Y8nDdyA7R3nngyHk2V/bsI2sCaCpRv5+TmC/8OohqbxE
         Ha3ftfKMozIDLw1QfPOhf4itkHDOUhgHfQ4CctIn/0w43qAV2eUkAzDnelbRpChkYn
         tJoshxO34zTFg==
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
Subject: [PATCH v8 0/1] mm: fix initialization of struct page for holes in  memory layout
Date:   Fri, 26 Feb 2021 00:43:50 +0200
Message-Id: <20210225224351.7356-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Hi,

@Andrew, this is based on v5.11-mmotm-2021-02-18-18-29 with the previous
version reverted

Commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
that check each PFN") exposed several issues with the memory map
initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported back
in April [1]. It seemed back then that the problem was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and there was an additional
discussion at [3].

I didn't appreciate variety of ways BIOSes can report memory in the first
megabyte, so previous versions of this set caused all kinds of troubles.

The last version that implicitly extended node/zone to cover the complete
section might also have unexpected side effects, so this time I'm trying to
move in forward in baby steps.

This is mostly a return to the fist version that simply merges
init_unavailable_pages() into memmap_init() so that the only effective
change would be more sensible zone/node links in unavailable struct pages.

For now, I've dropped the patch that tried to make ZONE_DMA to span pfn 0
because it didn't cause any issues for really long time and there are way
to many hidden mines around this.

I have an ugly workaround for "pfn 0" issue that IMHO is the safest way to
deal with it until it could be gradually fixed properly:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/commit/?h=meminit/pfn0&id=90272f37151c6e1bc2610997310c51f4e984cf2f

v8:
* make comments and changelog more elaborate as per David, Linus and Vlastimil
* add Vlastimil's ack

v7: https://lore.kernel.org/lkml/20210224153950.20789-1-rppt@kernel.org
* add handling of section end that span beyond the populated zones

v6: https://lore.kernel.org/lkml/20210222105728.28636-1-rppt@kernel.org
* only interleave initialization of unavailable pages in memmap_init(), so
that it is essentially includes init_unavailable_pages().

v5: https://lore.kernel.org/lkml/20210208110820.6269-1-rppt@kernel.org
* extend node/zone spans to cover complete sections, this allows to interleave
  the initialization of unavailable pages with "normal" memory map init.
* drop modifications to x86 early setup

v4: https://lore.kernel.org/lkml/20210130221035.4169-1-rppt@kernel.org/
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

Mike Rapoport (1):
  mm/page_alloc.c: refactor initialization of struct page for holes in
    memory layout

 mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 83 deletions(-)

-- 
2.28.0

*** BLURB HERE ***

Mike Rapoport (1):
  mm/page_alloc.c: refactor initialization of struct page for holes in
    memory layout

 mm/page_alloc.c | 158 +++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 83 deletions(-)

-- 
2.28.0

