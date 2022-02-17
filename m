Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639D34BAD98
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 00:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiBQX4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 18:56:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiBQX4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 18:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B682B4F454;
        Thu, 17 Feb 2022 15:56:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7DAF618A8;
        Thu, 17 Feb 2022 23:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0B8C340E8;
        Thu, 17 Feb 2022 23:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645140715;
        bh=lf47BGb+JKl6dFFGQO4VleD1gnZ/FyzSy9ozkMQFRNw=;
        h=Date:To:From:Subject:From;
        b=dzhHtiwvbJFec5KIkCkkMX8SHSbOQj2k6ALRF7lGDT3Uyfqfn+8iIijLTpaeedeXG
         YGiBOwvcSDNuq0vPu2GgsTbhzE6vWfEgqz1gOkRHouL/IMwEG7SKupVU1DDQJYVAVe
         IvYG9rK7LfthcY1SGeEKSVzsLd/xfDBwS8CHEOjU=
Date:   Thu, 17 Feb 2022 15:31:54 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch added to -mm tree
Message-Id: <20220217233154.EF0B8C340E8@smtp.kernel.org>
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
     Subject: userfaultfd: mark uffd_wp regardless of VM_WRITE flag
has been added to the -mm tree.  Its filename is
     userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: mark uffd_wp regardless of VM_WRITE flag

When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
currently only marked as write-protected if the VMA has VM_WRITE flag set.
This seems incorrect or at least would be unexpected by the users.

Consider the following sequence of operations that are being performed on
a certain page:

	mprotect(PROT_READ)
	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
	mprotect(PROT_READ|PROT_WRITE)

At this point the user would expect to still get UFFD notification when
the page is accessed for write, but the user would not get one, since the
PTE was not marked as UFFD_WP during UFFDIO_COPY.

Fix it by always marking PTEs as UFFD_WP regardless on the
write-permission in the VMA flags.

Link: https://lkml.kernel.org/r/20220217211602.2769-1-namit@vmware.com
Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag
+++ a/mm/userfaultfd.c
@@ -72,12 +72,15 @@ int mfill_atomic_install_pte(struct mm_s
 	_dst_pte = pte_mkdirty(_dst_pte);
 	if (page_in_cache && !vm_shared)
 		writable = false;
-	if (writable) {
-		if (wp_copy)
-			_dst_pte = pte_mkuffd_wp(_dst_pte);
-		else
-			_dst_pte = pte_mkwrite(_dst_pte);
-	}
+
+	/*
+	 * Always mark a PTE as write-protected when needed, regardless of
+	 * VM_WRITE, which the user might change.
+	 */
+	if (wp_copy)
+		_dst_pte = pte_mkuffd_wp(_dst_pte);
+	else if (writable)
+		_dst_pte = pte_mkwrite(_dst_pte);
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

