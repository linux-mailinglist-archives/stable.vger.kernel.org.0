Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E7E5A5349
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiH2Rgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiH2Rg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:36:27 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05877C33E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:36:24 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id t11so1735622ilf.3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=50PU5mc4GkjavRICrwmQCjjpwLHlE79osy79+PIByJk=;
        b=lPhbUW85OJKObE3ak5Wg/b4ZGlxFO9b4dV70N+M7vrx9BvjbxQlk76yyBCJLtgz5gi
         UW2nf/H8vJr6FTjOqcY89y3YXnSE5F0zI2OH7R2Oj+Zm2yH+i0Azs3Z9ENbys2carTXY
         IziYwgtf4pBq5JAR1m8wadPFbWkHk99c2Xb4WRQ5hdVWwaT9y3kQc3BJgBaAA14GuAyE
         cbnAgoKHZBSVzu9E1YusNWF+7c6c9J6+VJxRrrS8n1emVq+/T+6/Jv1QjvCHVkSAO+rg
         AVKqKCmdHtuE/S6APSvxXPCQbzz88StUgT25HiiIQ2E/gubqywjfN/yWOM3QWKWwNVJE
         8qCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=50PU5mc4GkjavRICrwmQCjjpwLHlE79osy79+PIByJk=;
        b=Ll5vZC2uKfxLPaQgMpUZxKe4Mj9FornZ8paWKg5j2ClWoPFJrIEvCfwsjV3LR0LNgJ
         O7eJGjcNAynOGkfyuhVGp5Wf7sY8xw8mLqTQf3bMT2OvOsA2+nlG8n3UvypKjnnZI1mh
         u02/5Nn76RCzyQFKNkUq4k+aOdjF76TYRcM5pHjL8ciRPJ7efoxoLQs4LQHErK3Qvt+K
         j93aYGEB76YuswFcGiMZRrMYWWJn3HZUi3bdQGWXrY9Ba6m+FY3OBId7USvDSXEv9H1H
         05/ZlFsQ6v1ZVWrQSUwNtWz5ejumJUG/fWekuQLgO7YTFMta9Jme0oklh8fv8AssFw9h
         hObA==
X-Gm-Message-State: ACgBeo17VKvwO0QKhPHs/th8Ygc7v6hgeR7LbeCZmrLqMhaOsc9emvW/
        xynv1WTAo4qPZIX8ElSBKiLYrbDvMQIZNR1baPv2jPjoDqP6SvIa
X-Google-Smtp-Source: AA6agR7aFXlN2/amqShfTc1i22qFeP/MfLVJm3apPIH0T1sxqSPBQdUO5gDedn7PHbJCotKm4TvGaiKYSJ2dtqKuFGU=
X-Received: by 2002:a05:6e02:1a63:b0:2e9:ec03:9618 with SMTP id
 w3-20020a056e021a6300b002e9ec039618mr10826989ilv.187.1661794583808; Mon, 29
 Aug 2022 10:36:23 -0700 (PDT)
MIME-Version: 1.0
From:   Jann Horn <jannh@google.com>
Date:   Mon, 29 Aug 2022 19:35:47 +0200
Message-ID: <CAG48ez3SEqOPcPCYGHVZv4iqEApujD5VtM3Re-tCKLDEFdEdbg@mail.gmail.com>
Subject: stable-backporting the VM_PFNMAP TLB flushing fix (b67fbebd4cf9)
To:     stable <stable@vger.kernel.org>,
        Security Officers <security@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas")
fixes a TLB flushing bug that probably affects some x86 graphics
drivers, although hitting the bug might be fairly gnarly. Still, it'd
probably be a bad idea to leave it unfixed in the stable kernels that
things like Debian stable rely on.

Unfortunately the way the fix is written, it relies on refactoring
prep work in the three preceding commits, and trying to apply those to
older kernels will result in a bunch of merge conflicts.

Would it be acceptable here to fix the issue in a completely different
way in stable to minimize merge conflicts? Or should the refactoring
prep work and the fix commit all be backported?

A minimal but also completely different fix would be:


diff --git a/mm/mmap.c b/mm/mmap.c
index a50042918cc7..c453a1274305 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2665,6 +2665,18 @@ static void unmap_region(struct mm_struct *mm,
        tlb_gather_mmu(&tlb, mm, start, end);
        update_hiwater_rss(mm);
        unmap_vmas(&tlb, vma, start, end);
+
+       /*
+        * Ensure we have no stale TLB entries by the time this mapping is
+        * removed from the rmap.
+        * Note that we don't have to worry about nested flushes here because
+        * we're holding the mm semaphore for removing the mapping - so any
+        * concurrent flush in this region has to be coming through the rmap,
+        * and we synchronize against that using the rmap lock.
+        */
+       if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
+               tlb_flush_mmu(&tlb);
+
        free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
                                 next ? next->vm_start : USER_PGTABLES_CEILING);
        tlb_finish_mmu(&tlb, start, end);
