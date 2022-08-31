Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A85A8686
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiHaTOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiHaTOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:14:00 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2688D9D5F
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:13:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e20so19481271wri.13
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8sLBWkHL2F3tgHmo2cuyLBQwNw0vnhyyBy0UwKfDlZE=;
        b=q8oFBttYx0f3Wd2ZmWf8XWi/dlZjwg7Hl4RAJwXII6CS8iDXXwjcq0rxtCxSHQsFNx
         bc6uVvWCwhdvKpatiMZxjbq+7RqmfXldU5bM44hao0VhsUaNfGNqGJeMr+Y4NoLxmM9q
         csK18wAj231W38bRFNldowp4+Lrrw3MYnnxqYy8p6S4w2d0mOOfBCNK/+El+a2XSGail
         WRNuvVymZCzJGP9WFEA7LFdm5T736D3lpQwKpmPHiuuqgowU+XeGjT5JWpEeHZsfCdoB
         /JdS7i2OSqtSXBNhfCXqfgSBahBrRPOjoFKurH4xMGxx4Nq0LiFmmsPfca9BgxrotSRh
         d2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8sLBWkHL2F3tgHmo2cuyLBQwNw0vnhyyBy0UwKfDlZE=;
        b=lzmdKW3hzcVOUiOfCl9Von1aerVGXFduV4Ina/Ym2r0O9akeT6R3U7lsMiMZ+NU2Ya
         XDYOJvDQaiRDd6z320WIKJK4mw3dIU7hMSEeg9BfxcOqq+2SovXS3GA8J8zkun2xsay9
         8cppO5aDnFXNB22L9tklmsTxiIyl8/0tP2LOpwYp01GeNO6M0BTkWQO/9Vh5AaIPmjjI
         UFIq/f8BUJwsuflLjGsYYdQAE27EZ7210MDWEGFD9Dj0g1J/TnZwGge6Y5uRTL3f7Hij
         AWICD+JeNIwxWAiLrucSdI9oTEcaFG83xAeC2T5qf5TP3pfcEg6vq6A5rKZPr8e1yel8
         E47g==
X-Gm-Message-State: ACgBeo23Pe92T5HmjUPa1cPrRskzPwTz+CETLTzd7UzBwpH7rxkKpJn8
        GISNuHELaeBRgIkq5ECdfjXEFiYZabje+w==
X-Google-Smtp-Source: AA6agR79YigzOeCBHSuUHRcOWoqXNKQhsVX5NFeRyf/89IEt52A87vukeoYUSsDSVobHlyIc/ahBkg==
X-Received: by 2002:a5d:64e8:0:b0:226:e949:211a with SMTP id g8-20020a5d64e8000000b00226e949211amr3305114wri.661.1661973236916;
        Wed, 31 Aug 2022 12:13:56 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:8376:a6:aa63:8f64])
        by smtp.gmail.com with ESMTPSA id v14-20020a5d43ce000000b00226d1b81b45sm14331192wrr.27.2022.08.31.12.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:13:56 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH stable 4.9-5.15] mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
Date:   Wed, 31 Aug 2022 21:13:48 +0200
Message-Id: <20220831191348.3388208-1-jannh@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b67fbebd4cf980aecbcc750e1462128bffe8ae15 upstream.

Some drivers rely on having all VMAs through which a PFN might be
accessible listed in the rmap for correctness.
However, on X86, it was possible for a VMA with stale TLB entries
to not be listed in the rmap.

This was fixed in mainline with
commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"),
but that commit relies on preceding refactoring in
commit 18ba064e42df3 ("mmu_gather: Let there be one tlb_{start,end}_vma()
implementation") and commit 1e9fdf21a4339 ("mmu_gather: Remove per arch
tlb_{start,end}_vma()").

This patch provides equivalent protection without needing that
refactoring, by forcing a TLB flush between removing PTEs in
unmap_vmas() and the call to unlink_file_vma() in free_pgtables().

[This is a stable-specific rewrite of the upstream commit!]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/mmap.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 031fca1a7c65e..ce13266a55c69 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2639,6 +2639,18 @@ static void unmap_region(struct mm_struct *mm,
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
+
+	/*
+	 * Ensure we have no stale TLB entries by the time this mapping is
+	 * removed from the rmap.
+	 * Note that we don't have to worry about nested flushes here because
+	 * we're holding the mm semaphore for removing the mapping - so any
+	 * concurrent flush in this region has to be coming through the rmap,
+	 * and we synchronize against that using the rmap lock.
+	 */
+	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) !=3D 0)
+		tlb_flush_mmu(&tlb);
+
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);

base-commit: addc9003c2e895fe8a068a66de1de6fdb4c6ac60
--=20
2.37.2.672.g94769d06f0-goog

