Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7416C5C29
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjCWBeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjCWBd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902729D;
        Wed, 22 Mar 2023 18:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B0F6B81EAA;
        Thu, 23 Mar 2023 01:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDAEC433D2;
        Thu, 23 Mar 2023 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535140;
        bh=14M42uhV4zu4PgCmd3RQCvVN8RgkortgaFK7+XIfTk4=;
        h=Date:To:From:Subject:From;
        b=IBwjAyvUHVUfyonhhnHRsFc3i1k3jOVo+4NnAn+Ef3E8s1GXxY6GH4ndaPeedJx+d
         M0j12BuQTbroL3GBtYxOPbrsKr2ZqcNHwUEnwJ6zC5yD92KvwWSSgo5x80TpDzGYEJ
         f9SopkSJZHdLlUyrWhQCGuMwo9yUfZ1RJwflUgjU=
Date:   Wed, 22 Mar 2023 18:32:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, eugenis@google.com,
        catalin.marinas@arm.com, andreyknvl@gmail.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch removed from -mm tree
Message-Id: <20230323013219.DCDAEC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
has been removed from the -mm tree.  Its filename was
     revert-kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
Date: Thu, 9 Mar 2023 20:29:13 -0800

This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.

should_skip_kasan_poison() reads the PG_skip_kasan_poison flag from
page->flags.  However, this line of code in free_pages_prepare():

	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;

clears most of page->flags, including PG_skip_kasan_poison, before calling
should_skip_kasan_poison(), which meant that it would never return true as
a result of the page flag being set.  Therefore, fix the code to call
should_skip_kasan_poison() before clearing the flags, as we were doing
before the reverted patch.

This fixes a measurable performance regression introduced in the reverted
commit, where munmap() takes longer than intended if HW tags KASAN is
supported and enabled at runtime.  Without this patch, we see a
single-digit percentage performance regression in a particular
mmap()-heavy benchmark when enabling HW tags KASAN, and with the patch,
there is no statistically significant performance impact when enabling HW
tags KASAN.

Link: https://lkml.kernel.org/r/20230310042914.3805818-2-pcc@google.com
Fixes: 487a32ec24be ("kasan: drop skip_kasan_poison variable in free_pages_prepare")
  Link: https://linux-review.googlesource.com/id/Ic4f13affeebd20548758438bb9ed9ca40e312b79
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com> [arm64]
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>	[6.1]
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

kasan-call-clear_page-with-a-match-all-tag-instead-of-changing-page-tag.patch
kasan-remove-pg_skip_kasan_poison-flag.patch

