Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10C24DBA80
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 23:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346197AbiCPWHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 18:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243684AbiCPWHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 18:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728591D9
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE03AB81B9C
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735F4C340EC;
        Wed, 16 Mar 2022 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647468354;
        bh=LM+PeWJfSxbwSLSeTGQlI1OYnxRksYJXzPpCpetxttg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pc6q4CdhqXO9hgGxXZTWm5lN5emNU/3GuyXneuhGDxioCR1M0iFaq04zZEym0HpAy
         YexVTYgnRfT0DF2e0tMLzUmuetNNwpY5kx7VVVnl54UfjrAozaKCXtj8EXxG4VqH2I
         3bvB5hvWYhPaVSVN1fYuDgnWSt4c6Q9awIdnQpy8=
Date:   Wed, 16 Mar 2022 15:05:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-Id: <20220316150553.c7b6f9e0eac620c9ee5963a5@linux-foundation.org>
In-Reply-To: <3E9C755C-7335-4636-8280-D5CB9735A76A@gmail.com>
References: <20220217211602.2769-1-namit@vmware.com>
        <Yg79WMuYLS1sxASL@xz-m1.local>
        <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
        <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
        <3E9C755C-7335-4636-8280-D5CB9735A76A@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


As I understand it, this patch (below) is still good to merge upstream,
although Peter hasn't acked it (please).

And a whole bunch of followup patches are being thought about, but have
yet to eventuate.

Do we feel that this patch warrants the cc:stable?  I'm suspecting
"no", as it isn't clear that the use-case is really legitimate at this
time?

Thanks.


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

