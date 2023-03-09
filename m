Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC96B18E4
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 02:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCIBrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 20:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCIBrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 20:47:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE28F97B79;
        Wed,  8 Mar 2023 17:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC86B81E61;
        Thu,  9 Mar 2023 01:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B597BC433D2;
        Thu,  9 Mar 2023 01:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678326448;
        bh=TSwA4sCPOUdnPUXe4xRqLSNiwbySpkMRgb+wgZzjflc=;
        h=Date:To:From:Subject:From;
        b=rOm6gCJJSnPP7ZdzDVwRxUH1DO+FXqotUHGA/yGlgSdd4k0ppvibDA3q4m0h13lNW
         hi0h4DQmQoQyeuCUJrIfI4LSbHgbClCYVOX2zQg/+SiuPNq83plcb/Qyi/bvTa1Mmj
         cHHOjzZQIGkegXSmKtVqdrk+heZ/Sx6fCCgFducg=
Date:   Wed, 08 Mar 2023 17:47:28 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, eugenis@google.com,
        catalin.marinas@arm.com, andreyknvl@gmail.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch added to mm-hotfixes-unstable branch
Message-Id: <20230309014728.B597BC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch

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
From: Peter Collingbourne <pcc@google.com>
Subject: Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
Date: Tue, 28 Feb 2023 16:35:44 -0800

This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.

The should_skip_kasan_poison() function reads the PG_skip_kasan_poison
flag from page->flags.  However, this line of code in
free_pages_prepare():

page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;

clears most of page->flags, including PG_skip_kasan_poison, before calling
should_skip_kasan_poison(), which meant that it would never return true as
a result of the page flag being set.  Therefore, fix the code to call
should_skip_kasan_poison() before clearing the flags, as we were doing
before the reverted patch.

Link: https://lkml.kernel.org/r/20230301003545.282859-2-pcc@google.com
Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -1398,6 +1398,7 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1470,7 +1471,7 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!should_skip_kasan_poison(page, fpi_flags)) {
+	if (!skip_kasan_poison) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */
_

Patches currently in -mm which might be from pcc@google.com are

revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch
kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch
kasan-remove-pg_skip_kasan_poison-flag.patch

