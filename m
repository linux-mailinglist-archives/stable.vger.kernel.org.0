Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA4655B6E
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 23:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiLXWSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 17:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiLXWSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 17:18:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4689FFD;
        Sat, 24 Dec 2022 14:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D4A60B0D;
        Sat, 24 Dec 2022 22:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F2CC433EF;
        Sat, 24 Dec 2022 22:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671920330;
        bh=a8sbHrjzFWKIpszR2VatqyiutB7CKA6Flq4QIUvYTNE=;
        h=Date:To:From:Subject:From;
        b=qPENd+LUIaI2kB1KD062h0zuoIaK3Fs7rVTf/zUDRsZzmI5cFCIdeEoBIVPv5JSPK
         T4Iq8r7fZ2GGPm9uBfwINtf7qajMcySVK7O91W4vvgcMIrrWDXDjCQ1m38fC/RJk2N
         dbMecYpGAWyNGKSOE6CvbOuZLiHt1I37GIzS1lkc=
Date:   Sat, 24 Dec 2022 14:18:49 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, hughd@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch added to mm-hotfixes-unstable branch
Message-Id: <20221224221850.84F2CC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
Date: Sat, 24 Dec 2022 00:20:35 -0800

SHMEM_HUGE_DENY is for emergency use by the admin, to disable allocation
of shmem huge pages if, for example, a dangerous bug is found in their
usage: see "deny" in Documentation/mm/transhuge.rst.  An app using
madvise(,,MADV_COLLAPSE) should not be allowed to override it: restore its
precedence over shmem_huge_force.

Restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE.

Link: https://lkml.kernel.org/r/20221224082035.3197140-2-zokeefe@google.com
Fixes: 7c6c6cc4d3a2 ("mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse
+++ a/mm/shmem.c
@@ -478,12 +478,10 @@ bool shmem_is_huge(struct vm_area_struct
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
-	if (shmem_huge_force)
-		return true;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
+	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-madv_collapse-dont-expand-collapse-when-vm_end-is-past-requested-end.patch
mm-shmem-restore-shmem_huge_deny-precedence-over-madv_collapse.patch

