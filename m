Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6C54A5457
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiBABAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBABAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:00:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46883C061714;
        Mon, 31 Jan 2022 17:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C33611DA;
        Tue,  1 Feb 2022 01:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3131C340E8;
        Tue,  1 Feb 2022 01:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643677230;
        bh=KZ1zVlzAn8MTA2ODFBbHYI8ityv0o2Qbe4l3A3e19fM=;
        h=Date:To:From:Subject:From;
        b=pZw9D9+FW4k9QcetL0Q6FUip/QvERqm5ySrAubBFPZwk0UGv3kZ/A1fmzxPmcjxNa
         ca64NJNmrQf8mee2jl2+biqZ6ftvGI6fy8KGchFyJw3YRkmQbpIBI/BkhLMLZWSejZ
         CQUYlHaTdY1US/Mh8t8d0o9Zc1zfsr9R2sLyBV2E=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 17:00:28 -0800
Date:   Mon, 31 Jan 2022 17:00:28 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rafael@kernel.org, osalvador@suse.de, mhocko@suse.com,
        gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch added to -mm tree
Message-Id: <20220201010028.C3131C340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: add memory block to memory group after registration succeeded
has been added to the -mm tree.  Its filename is
     drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: add memory block to memory group after registration succeeded

If register_memory() fails, we freed the memory block but already added
the memory block to the group list, not good.  Let's defer adding the
block to the memory group to after registering the memory block device.

We do handle it properly during unregister_memory(), but that's not
called when the registration fails.

Link: https://lkml.kernel.org/r/20220128144540.153902-1-david@redhat.com
Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded
+++ a/drivers/base/memory.c
@@ -663,14 +663,16 @@ static int init_memory_block(unsigned lo
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 	INIT_LIST_HEAD(&mem->group_next);
 
+	ret = register_memory(mem);
+	if (ret)
+		return ret;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
 	}
 
-	ret = register_memory(mem);
-
-	return ret;
+	return 0;
 }
 
 static int add_memory_block(unsigned long base_section_nr)
_

Patches currently in -mm which might be from david@redhat.com are

mm-optimize-do_wp_page-for-exclusive-pages-in-the-swapcache.patch
mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-streamline-cow-logic-in-do_swap_page.patch
mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
mm-khugepaged-remove-reuse_swap_page-usage.patch
mm-swapfile-remove-stale-reuse_swap_page.patch
mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch
drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch
proc-vmcore-fix-possible-deadlock-on-concurrent-mmap-and-read.patch

