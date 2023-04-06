Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72D36DA5E3
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 00:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjDFWho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 18:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjDFWhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 18:37:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824B69EF8;
        Thu,  6 Apr 2023 15:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A3060EF3;
        Thu,  6 Apr 2023 22:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A1C433EF;
        Thu,  6 Apr 2023 22:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680820661;
        bh=Z3Q5QZoGL0IwLv9ZHh1x4NgbK29AlS7wh0ViiXtdn8M=;
        h=Date:To:From:Subject:From;
        b=HF44PC3kXGMw/dlSLBfwX0JINYag0um3Ht0EoncwvKM2d9w80OLsjelU0TJKOsUWZ
         Dy55XhztzO2w2MEMURevc/M7BrDp+kpb6OcadQb2FnGfga1O7ejK5M3KLhJRiwVPq4
         2OLY5lYQBQ+vAE1tNXar/KxbW26DHW6KYCVkfKHs=
Date:   Thu, 06 Apr 2023 15:37:40 -0700
To:     mm-commits@vger.kernel.org, xuyu@linux.alibaba.com,
        stable@vger.kernel.org, shy828301@gmail.com,
        penguin-kernel@i-love.sakura.ne.jp, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20230406223741.5D1A1C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO
Date: Thu, 6 Apr 2023 17:20:04 +0900

split_huge_page_to_list() WARNs when called for huge zero pages, which
sounds to me too harsh because it does not imply a kernel bug, but just
notifies the event to admins.  On the other hand, this is considered as
critical by syzkaller and makes its testing less efficient, which seems to
me harmful.

So replace the VM_WARN_ON_ONCE_FOLIO with pr_warn_ratelimited.

Link: https://lkml.kernel.org/r/20230406082004.2185420-1-naoya.horiguchi@linux.dev
Fixes: 478d134e9506 ("mm/huge_memory: do not overkill when splitting huge_zero_page")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: syzbot+07a218429c8d19b1fb25@syzkaller.appspotmail.com
  Link: https://lore.kernel.org/lkml/000000000000a6f34a05e6efcd01@google.com/
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio
+++ a/mm/huge_memory.c
@@ -2665,9 +2665,10 @@ int split_huge_page_to_list(struct page
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
 	is_hzp = is_huge_zero_page(&folio->page);
-	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
-	if (is_hzp)
+	if (is_hzp) {
+		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
+	}
 
 	if (folio_test_writeback(folio))
 		return -EBUSY;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch

