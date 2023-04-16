Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0D6E3ABE
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDPRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjDPRmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD235A3;
        Sun, 16 Apr 2023 10:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC4BF61C4F;
        Sun, 16 Apr 2023 17:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E00DC433D2;
        Sun, 16 Apr 2023 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666920;
        bh=jQnZb4WdN/QcHPXXZtD9tgjT61KcDnKHO+clYtadqL0=;
        h=Date:To:From:Subject:From;
        b=TFFvK9ZTZP+fP4h0iCX3ehViBPybl2dtoXQH/UCk9gIXErrLnMl12Wx4wlhcbYuZv
         SRN9bbVujK0TEsMOyYPbIjAiRxQ9w/pxh2R2xpbFUnqSGZJ2mrd6xAega71SYgUzD0
         KSfIPoF/KfQ4HTIeLLT36ZwgQxV3HX05Ooe3yRhA=
Date:   Sun, 16 Apr 2023 10:41:59 -0700
To:     mm-commits@vger.kernel.org, xuyu@linux.alibaba.com,
        stable@vger.kernel.org, shy828301@gmail.com,
        penguin-kernel@i-love.sakura.ne.jp, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch removed from -mm tree
Message-Id: <20230416174200.0E00DC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-warn-with-pr_warn_ratelimited-instead-of-vm_warn_on_once_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Xu Yu <xuyu@linux.alibaba.com>
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


