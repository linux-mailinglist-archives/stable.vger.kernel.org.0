Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F14141B34
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 03:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgASCiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 21:38:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:27432 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbgASCiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 21:38:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 18:38:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="426401716"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2020 18:38:17 -0800
Date:   Sun, 19 Jan 2020 10:38:28 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        richardw.yang@linux.intel.com, mhocko@suse.com,
        yang.shi@linux.alibaba.com
Subject: Re: +
 mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
 added to -mm tree
Message-ID: <20200119023828.GE9745@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <20200118224754.ufg_j%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118224754.ufg_j%akpm@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 02:47:54PM -0800, akpm@linux-foundation.org wrote:
>
>The patch titled
>     Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages
>has been added to the -mm tree.  Its filename is
>     mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
>
>This patch should soon appear at
>    http://ozlabs.org/~akpm/mmots/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
>and later at
>    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
>The -mm tree is included into linux-next and is updated
>there every 3-4 working days

Hi Andrew

I am afraid this patch doesn't fully fix the problem. Please wait a minute.

>
>------------------------------------------------------
>From: Yang Shi <yang.shi@linux.alibaba.com>
>Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages
>
>do_move_pages_to_node() might return > 0 value, the number of pages that
>are not migrated, then the value will be returned to userspace directly. 
>But, move_pages() syscall would just return 0 or errno.  So, we need reset
>the return value to 0 for such case as pre-v4.17 did.
>
>Link: http://lkml.kernel.org/r/1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com
>Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>Cc: Michal Hocko <mhocko@suse.com>
>Cc: Wei Yang <richardw.yang@linux.intel.com>
>Cc: <stable@vger.kernel.org>    [4.17+]
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> mm/migrate.c |    5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>--- a/mm/migrate.c~mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages
>+++ a/mm/migrate.c
>@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struc
> 			goto out_flush;
> 
> 		err = do_move_pages_to_node(mm, &pagelist, current_node);
>-		if (err)
>+		if (err) {
>+			if (err > 0)
>+				err = 0;
> 			goto out;
>+		}
> 		if (i > start) {
> 			err = store_status(status, start, current_node, i - start);
> 			if (err)
>_
>
>Patches currently in -mm which might be from yang.shi@linux.alibaba.com are
>
>mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

-- 
Wei Yang
Help you, Help me
