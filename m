Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C48549772
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381296AbiFMOIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381030AbiFMOD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E08FD69;
        Mon, 13 Jun 2022 04:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0563B612A8;
        Mon, 13 Jun 2022 11:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AB3C34114;
        Mon, 13 Jun 2022 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120311;
        bh=BId6GrVmV6WPWkagZd52rMJRrt2fGu7QWzudzEjdX44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXly2ePWDgxD2Kp/lp3oshxFj0WvpeYHMS1Vr1txBmIGakPxHp95eeAYUHhZyvWE3
         VZGn4Yd26+1GzFDt1NI71KKOjd/3efKOnWQFVkgSaBjmz3MBszQK007fC/9nPzIqRk
         oxSP5ZmUqrPrFYrftrUUMjM3MQsSeM2lAXVCUudA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5b96d55e5b54924c77ad@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.18 307/339] filemap: Cache the value of vm_flags
Date:   Mon, 13 Jun 2022 12:12:12 +0200
Message-Id: <20220613094936.069042805@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit dcfa24ba68991ab69a48254a18377b45180ae664 upstream.

After we have unlocked the mmap_lock for I/O, the file is pinned, but
the VMA is not.  Checking this flag after that can be a use-after-free.
It's not a terribly interesting use-after-free as it can only read one
bit, and it's used to decide whether to read 2MB or 4MB.  But it
upsets the automated tools and it's generally bad practice anyway,
so let's fix it.

Reported-by: syzbot+5b96d55e5b54924c77ad@syzkaller.appspotmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2991,11 +2991,12 @@ static struct file *do_sync_mmap_readahe
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
+	unsigned long vm_flags = vmf->vma->vm_flags;
 	unsigned int mmap_miss;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if (vmf->vma->vm_flags & VM_HUGEPAGE) {
+	if (vm_flags & VM_HUGEPAGE) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
 		ra->size = HPAGE_PMD_NR;
@@ -3003,7 +3004,7 @@ static struct file *do_sync_mmap_readahe
 		 * Fetch two PMD folios, so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
-		if (!(vmf->vma->vm_flags & VM_RAND_READ))
+		if (!(vm_flags & VM_RAND_READ))
 			ra->size *= 2;
 		ra->async_size = HPAGE_PMD_NR;
 		page_cache_ra_order(&ractl, ra, HPAGE_PMD_ORDER);
@@ -3012,12 +3013,12 @@ static struct file *do_sync_mmap_readahe
 #endif
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ)
+	if (vm_flags & VM_RAND_READ)
 		return fpin;
 	if (!ra->ra_pages)
 		return fpin;
 
-	if (vmf->vma->vm_flags & VM_SEQ_READ) {
+	if (vm_flags & VM_SEQ_READ) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_sync_ra(&ractl, ra->ra_pages);
 		return fpin;


