Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66582D4D0A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 22:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLIVnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 16:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgLIVnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 16:43:52 -0500
From:   Mike Rapoport <rppt@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH v2 0/2] mm: fix initialization of struct page for holes in  memory layout
Date:   Wed,  9 Dec 2020 23:43:02 +0200
Message-Id: <20201209214304.6812-1-rppt@kernel.org>
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
in April [1]. It seemed back then that the probelm was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and after a long discussion
between us [3] I think these patches are the proper fix.

v2 changes:
* added patch that adds all regions in memblock.reserved that do not
overlap with memblock.memory to memblock.memory in the beginning of
free_area_init()

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org

Mike Rapoport (2):
  mm: memblock: enforce overlap of memory.memblock and memory.reserved
  mm: fix initialization of struct page for holes in memory layout

 include/linux/memblock.h |   1 +
 mm/memblock.c            |  24 ++++++
 mm/page_alloc.c          | 159 ++++++++++++++++++---------------------
 3 files changed, 97 insertions(+), 87 deletions(-)

-- 
2.28.0

