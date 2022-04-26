Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4350F85B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbiDZJHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347537AbiDZJFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F144F12FECE;
        Tue, 26 Apr 2022 01:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1E36B81CFE;
        Tue, 26 Apr 2022 08:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4494C385A0;
        Tue, 26 Apr 2022 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962692;
        bh=5xTDvNXwoCQJk1iKzJHupHTTjUGUOgb2bv+ABVlDzXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4klwte6T2nI2vC5kuR+mRGDbi/Mgc1MoinXI8qmLCc/QCu8iJPtvrUUqvrURBBIa
         h66/442zMLJhlG+4BvST9K1zx69T9ROsZtpkohZ12SSujha7357hqE7ERJVYYFS2S6
         ADXTCOILiJ0feq//QeRDDp3bNG3rdHRlzAna5f64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 055/146] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Date:   Tue, 26 Apr 2022 10:20:50 +0200
Message-Id: <20220426081751.615934458@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 0e88904cb700a9654c9f0d9ca4967e761e7c9ee8 ]

When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
currently only marked as write-protected if the VMA has VM_WRITE flag
set.  This seems incorrect or at least would be unexpected by the users.

Consider the following sequence of operations that are being performed
on a certain page:

	mprotect(PROT_READ)
	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
	mprotect(PROT_READ|PROT_WRITE)

At this point the user would expect to still get UFFD notification when
the page is accessed for write, but the user would not get one, since
the PTE was not marked as UFFD_WP during UFFDIO_COPY.

Fix it by always marking PTEs as UFFD_WP regardless on the
write-permission in the VMA flags.

Link: https://lkml.kernel.org/r/20220217211602.2769-1-namit@vmware.com
Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 0780c2a57ff1..885e5adb0168 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -72,12 +72,15 @@ int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
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
 
-- 
2.35.1



