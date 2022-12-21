Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009BC6538A7
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiLUWca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiLUWc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65DAFF0;
        Wed, 21 Dec 2022 14:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C54461973;
        Wed, 21 Dec 2022 22:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DE7C433F0;
        Wed, 21 Dec 2022 22:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661946;
        bh=RzeZua8y6jOaCBOoUA7epEzqUFk2MN54v/tpgHGytgU=;
        h=Date:To:From:Subject:From;
        b=DJJzii7yE5zsFvzlJAADUs8LdPjqADEToVWyii5cq98ffge/LJBF57djDZadrIlKY
         xu+cuQXHFcEETySQICcrl+3X1SB8kRsky8sakFH1UMVOhsr/FFbYDBPcryqMKZoeB9
         TSeZqXbw2P2yyOiXEl4BLhEg+YIRjii2DiZBeWI4=
Date:   Wed, 21 Dec 2022 14:32:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, matenajakub@gmail.com,
        liam.howlett@oracle.com, kirill@shutemov.name,
        jirislaby@kernel.org, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch removed from -mm tree
Message-Id: <20221221223226.D7DE7C433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm, mremap: fix mremap() expanding vma with addr inside vma
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mremap: fix mremap() expanding vma with addr inside vma
Date: Fri, 16 Dec 2022 17:32:27 +0100

Since 6.1 we have noticed random rpm install failures that were tracked to
mremap() returning -ENOMEM and to commit ca3d76b0aa80 ("mm: add merging
after mremap resize").

The problem occurs when mremap() expands a VMA in place, but using an
starting address that's not vma->vm_start, but somewhere in the middle. 
The extension_pgoff calculation introduced by the commit is wrong in that
case, so vma_merge() fails due to pgoffs not being compatible.  Fix the
calculation.

By the way it seems that the situations, where rpm now expands a vma from
the middle, were made possible also due to that commit, thanks to the
improved vma merging.  Yet it should work just fine, except for the buggy
calculation.

Link: https://lkml.kernel.org/r/20221216163227.24648-1-vbabka@suse.cz
Reported-by: Jiri Slaby <jirislaby@kernel.org>
  Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-mremap-expanding-vma-with-addr-inside-vma
+++ a/mm/mremap.c
@@ -1016,7 +1016,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			long pages = (new_len - old_len) >> PAGE_SHIFT;
 			unsigned long extension_start = addr + old_len;
 			unsigned long extension_end = addr + new_len;
-			pgoff_t extension_pgoff = vma->vm_pgoff + (old_len >> PAGE_SHIFT);
+			pgoff_t extension_pgoff = vma->vm_pgoff +
+				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
_

Patches currently in -mm which might be from vbabka@suse.cz are


