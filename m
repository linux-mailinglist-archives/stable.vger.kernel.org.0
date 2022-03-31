Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F4C4ED282
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiCaE2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiCaE2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB641255B4;
        Wed, 30 Mar 2022 21:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A48F61333;
        Thu, 31 Mar 2022 04:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5B6C340F0;
        Thu, 31 Mar 2022 04:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648700497;
        bh=Qmx7fhrl2oGChXBfgrLrzKPyxB5yQr7HoIHVvCz1seQ=;
        h=Date:To:From:Subject:From;
        b=TGh3NBTfCFF6sIuKQNcWfR5dtAEqr/26FrE7TjC7eQ7N0iNnfmRWNwoYF1ua7CWew
         08WdanSgh8J0kTZmnSeo6v4yBSo29y+bhlhvwz3iTXkxVcEeYQ4aNHFJU1kdGamHLx
         eF1yuaWvKexcA7cHlqr7J3Vh39znAgS7OqTU7t8Q=
Date:   Wed, 30 Mar 2022 21:21:36 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch added to -mm tree
Message-Id: <20220331042137.6F5B6C340F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)
has been added to the -mm tree.  Its filename is
     mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

If an mremap() syscall with old_size=0 ends up in move_page_tables(), it
will call invalidate_range_start()/invalidate_range_end() unnecessarily,
i.e.  with an empty range.

This causes a WARN in KVM's mmu_notifier.  In the past, empty ranges have
been diagnosed to be off-by-one bugs, hence the WARNing.  Given the low
(so far) number of unique reports, the benefits of detecting more buggy
callers seem to outweigh the cost of having to fix cases such as this one,
where userspace is doing something silly.  In this particular case, an
early return from move_page_tables() is enough to fix the issue.

Link: https://lkml.kernel.org/r/20220329173155.172439-1-pbonzini@redhat.com
Reported-by: syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mremap.c~mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0
+++ a/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
_

Patches currently in -mm which might be from pbonzini@redhat.com are

mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0.patch

