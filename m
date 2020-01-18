Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12DA3141A27
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 23:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgARWrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 17:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgARWrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 17:47:55 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B0F246A9;
        Sat, 18 Jan 2020 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579387674;
        bh=bMrwPRoY+oe46T7LSVhy5E1uJ65snHjumdGm6bF2454=;
        h=Date:From:To:Subject:From;
        b=l9RtHassYwOqAeGxNUBWNtWJ0CiQWCFEEgVzGaADri4h9Z8HHyic5HIKRHrwoL3wQ
         bzfR0R1FYR1Y/kO4wjcZu0TEFQefBxbbst8Ybcf5ORY5L31icjhXKPGgLc3a70KO37
         sXHbAkFJFHXWtHj7RKmBc/CQFdnM4+J3qFTLymhI=
Date:   Sat, 18 Jan 2020 14:47:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        richardw.yang@linux.intel.com, mhocko@suse.com,
        yang.shi@linux.alibaba.com
Subject:  +
 mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
 added to -mm tree
Message-ID: <20200118224754.ufg_j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages
has been added to the -mm tree.  Its filename is
     mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages

do_move_pages_to_node() might return > 0 value, the number of pages that
are not migrated, then the value will be returned to userspace directly. 
But, move_pages() syscall would just return 0 or errno.  So, we need reset
the return value to 0 for such case as pre-v4.17 did.

Link: http://lkml.kernel.org/r/1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages
+++ a/mm/migrate.c
@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struc
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err = 0;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

