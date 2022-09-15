Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E8D5B9914
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 12:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiIOKtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 06:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIOKtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 06:49:22 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2086B665
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 03:49:21 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p3so4706728iof.13
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 03:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=VTffAkY5nAfU7RQz8GskidlKA2MjXBoy/y8q2DzU0g8=;
        b=kKT0BVGi7yWPIzm+6azsg1oSTmUIG7CB46bHrQQMpplAzfb6etZgskVh6gfbgdsPfo
         dJLatjNVgxbvjXiKRXYVGOMtdXHpYiy5csCojxCZvb2O4nc7pQJ0cbH8nGlM1cfnAiHO
         3+4m6OFnPYps/oFsqjKLJimXeVBBajqs2X1WpWYf596cnFctJmBufByRz5b8JcQORSsV
         I+jEN9shvOj2NO8N/1k6oIsP/Y/JsVv8kTDTK0DssRskEFrm1BY/42AuzVE6MMBEh2Ca
         9pDn777JZloyInlsu3G5qgWukcAXnWJv1dBmvM6EfKlpegXq9VA370/xl+CVMKTe4vrp
         RdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=VTffAkY5nAfU7RQz8GskidlKA2MjXBoy/y8q2DzU0g8=;
        b=kVnWCTb9Te0uJF1HzlY/XJYfa6OMoGWDBQaeIBlZFAs3TC2XQLc6hp/ToP3C9ljZuf
         +5t5DaLS4PcWTrqxDP1Ol7PeCSWIJBdKQkg6u5QxQDmj9QFgKt4nBj+8lChmo4sIcW7T
         3bIDT2LRHL+9+sZE8NA4BgoNnvz9rwXL2/doXP5ZAQQqz/gklE2VuqbZ3NiCa/vGk3zn
         cH2HsawEYHwp27DyBMtxWEyCVqBWTG99X9nuHFAGgCQyfk+SwMRLtqSmZFDbxOXzRP9A
         o//FEaJKctM4UQaZCr1W3V8foNireoPPe2i4EZODaS40iIR/k/ZYsAyoQ9xC7UMyY4PW
         JWAQ==
X-Gm-Message-State: ACgBeo3vgLI903Pb43KSViVsInzL3w7KHVA/L3KixPTMqPrsXxflKALa
        a+FZqq4mG/XabboDTaTNozXVipdeJ7ghEitAghuD+Q==
X-Google-Smtp-Source: AA6agR4E+sIUSvLkVz4wd/OaJC327nIoNz+rIQlwBzM3Jv/mHBoDmqukPrcbd4KsFJrQSXMx16E1OEZbRq+jAxzEkMk=
X-Received: by 2002:a02:c543:0:b0:35a:51bb:f887 with SMTP id
 g3-20020a02c543000000b0035a51bbf887mr6833546jaj.58.1663238960674; Thu, 15 Sep
 2022 03:49:20 -0700 (PDT)
MIME-Version: 1.0
From:   Jann Horn <jannh@google.com>
Date:   Thu, 15 Sep 2022 12:48:44 +0200
Message-ID: <CAG48ez2sDEaDpiHBQJcDqPtvpCYK1JjLD=Jp8rE9ODnFW-MbRg@mail.gmail.com>
Subject: I botched the b67fbebd4cf9 (VM_PFNMAP TLB flush) stable backport, how
 do I have to fix it?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Hugh reached out to me and let me know (in nicer words) that I botched
my attempt to re-implement b67fbebd4cf9 for the stable backport; the
backport is an incomplete fix (because I forgot that in
unmap_region(), "vma" is just one of potentially several VMAs).

What should the commit message for fixing that look like? And should
we first revert the botched backport and then do a correct backport on
top of that, or should I write a single fix commit?

Sorry for causing you extra work, Greg...


Regarding how to actually fix it, one of the possible approaches
suggested by Hugh, and what I'd do, is something like this (not yet
tested) - unless someone thinks this is getting too far from upstream
and that we should backport the original fix instead, including the
refactoring?

diff --git a/mm/mmap.c b/mm/mmap.c
index 5ee3c91450de1..cee6593cbdbe3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2566,6 +2566,7 @@ static void unmap_region(struct mm_struct *mm,
                unsigned long start, unsigned long end)
 {
        struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
+       struct vm_area_struct *cur_vma;
        struct mmu_gather tlb;

        lru_add_drain();
@@ -2581,8 +2582,12 @@ static void unmap_region(struct mm_struct *mm,
         * concurrent flush in this region has to be coming through the rmap,
         * and we synchronize against that using the rmap lock.
         */
-       if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
-               tlb_flush_mmu(&tlb);
+       for (cur_vma = vma; cur_vma; cur_vma = cur_vma->next) {
+               if ((cur_vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0) {
+                       tlb_flush_mmu(&tlb);
+                       break;
+               }
+       }

        free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
                                 next ? next->vm_start : USER_PGTABLES_CEILING);
