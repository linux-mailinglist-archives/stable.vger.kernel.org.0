Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF66573C74
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 20:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbiGMSVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 14:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiGMSVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 14:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE632CE20;
        Wed, 13 Jul 2022 11:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29ACB61D59;
        Wed, 13 Jul 2022 18:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C06DC34114;
        Wed, 13 Jul 2022 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657736512;
        bh=la1r15x4KQLNGJA82valO7UZA8IXV/V5m6AHmO1sSv8=;
        h=Date:To:From:Subject:From;
        b=plPx68RCPjJzbM0nqp1RHw/Ge0jXx70eRyfx93EV0V/oSr+MFl9/0SzwKdckjBVEw
         wD4Q3V3nKIJU6ALKFfNVBoSXu+Fz0noymAxoM6dxDunARMwImha4AtCXVyxDYFRo9l
         hrmjU40GR+Ap4qoPXWXpd7Oqrgby4tWO7cTgq3vY=
Date:   Wed, 13 Jul 2022 11:21:51 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.ibm.com, peterx@redhat.com, jthoughton@google.com,
        jack@suse.cz, david@redhat.com, aarcange@redhat.com,
        namit@vmware.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-provide-properly-masked-address-for-huge-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20220713182152.6C06DC34114@smtp.kernel.org>
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
     Subject: userfaultfd: provide properly masked address for huge-pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-provide-properly-masked-address-for-huge-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-provide-properly-masked-address-for-huge-pages.patch

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
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: provide properly masked address for huge-pages
Date: Mon, 11 Jul 2022 09:59:06 -0700

Commit 824ddc601adc ("userfaultfd: provide unmasked address on
page-fault") was introduced to fix an old bug, in which the offset in the
address of a page-fault was masked.  Concerns were raised - although were
never backed by actual code - that some userspace code might break because
the bug has been around for quite a while.  To address these concerns a
new flag was introduced, and only when this flag is set by the user,
userfaultfd provides the exact address of the page-fault.

The commit however had a bug, and if the flag is unset, the offset was
always masked based on a base-page granularity.  Yet, for huge-pages, the
behavior prior to the commit was that the address is masked to the
huge-page granulrity.

While there are no reports on real breakage, fix this issue.  If the flag
is unset, use the address with the masking that was done before.

Link: https://lkml.kernel.org/r/20220711165906.2682-1-namit@vmware.com
Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reported-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-provide-properly-masked-address-for-huge-pages
+++ a/fs/userfaultfd.c
@@ -192,17 +192,19 @@ static inline void msg_init(struct uffd_
 }
 
 static inline struct uffd_msg userfault_msg(unsigned long address,
+					    unsigned long real_address,
 					    unsigned int flags,
 					    unsigned long reason,
 					    unsigned int features)
 {
 	struct uffd_msg msg;
+
 	msg_init(&msg);
 	msg.event = UFFD_EVENT_PAGEFAULT;
 
-	if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
-		address &= PAGE_MASK;
-	msg.arg.pagefault.address = address;
+	msg.arg.pagefault.address = (features & UFFD_FEATURE_EXACT_ADDRESS) ?
+				    real_address : address;
+
 	/*
 	 * These flags indicate why the userfault occurred:
 	 * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
@@ -488,8 +490,8 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
-			ctx->features);
+	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
+				reason, ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-provide-properly-masked-address-for-huge-pages.patch

