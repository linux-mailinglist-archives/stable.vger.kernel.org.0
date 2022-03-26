Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA14E7ECF
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 04:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiCZDpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 23:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiCZDo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 23:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAACC5A177;
        Fri, 25 Mar 2022 20:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4427619EE;
        Sat, 26 Mar 2022 03:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2589FC340E8;
        Sat, 26 Mar 2022 03:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648266201;
        bh=k7FVZ25aRR4eLvaNH52Da+0V18tBZ0458xRWxuR/ekE=;
        h=Date:To:From:Subject:From;
        b=lQSA/5NL6sb1IqTDodOrmxih2dVAieadDs6sXG9wNI02QUGtn/Bw7w8SSKYmiH6dG
         nsZCVan8CVLMxPr2GR9OPtZOqfwdJ91c1hvxYkwzdHtDWa3sRP9Rq6jvHCRmZGZtnJ
         tM9hjJG1GJ0ZiCNy7skYM/ETmCZW8AeudBflco84=
Date:   Fri, 25 Mar 2022 20:43:20 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        senozhatsky@chromium.org, ngupta@vflare.org, ivan@cloudflare.com,
        david@redhat.com, axboe@kernel.dk, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch added to -mm tree
Message-Id: <20220326034321.2589FC340E8@smtp.kernel.org>
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
     Subject: mm: fix unexpected zeroed page mapping with zram swap
has been added to the -mm tree.  Its filename is
     mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix unexpected zeroed page mapping with zram swap

Two processes under CLONE_VM cloning, user process can be corrupted by
seeing zeroed page unexpectedly.

    CPU A                        CPU B

do_swap_page                do_swap_page
SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
swap_readpage valid data
  swap_slot_free_notify
    delete zram entry
                            swap_readpage zeroed(invalid) data
                            pte_lock
                            map the *zero data* to userspace
                            pte_unlock
pte_lock
if (!pte_same)
  goto out_nomap;
pte_unlock
return and next refault will
read zeroed data

The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
increase the refcount of swap slot at copy_mm so it couldn't catch up
whether it's safe or not to discard data from backing device.  In the
case, only the lock it could rely on to synchronize swap slot freeing is
page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
function.  With this patch, CPU A will see correct data.

    CPU A                        CPU B

do_swap_page                do_swap_page
SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
                            swap_readpage original data
                            pte_lock
                            map the original data
                            swap_free
                              swap_range_free
                                bd_disk->fops->swap_slot_free_notify
swap_readpage read zeroed data
                            pte_unlock
pte_lock
if (!pte_same)
  goto out_nomap;
pte_unlock
return
on next refault will see mapped data by CPU B

The concern of the patch would increase memory consumption since it could
keep wasted memory with compressed form in zram as well as uncompressed
form in address space.  However, most of cases of zram uses no readahead
and do_swap_page is followed by swap_free so it will free the compressed
form from in zram quickly.

Link: https://lkml.kernel.org/r/YjTVVxIAsnKAXjTd@google.com
Fixes: 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous device")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   54 -------------------------------------------------
 1 file changed, 54 deletions(-)

--- a/mm/page_io.c~mm-fix-unexpected-zeroed-page-mapping-with-zram-swap
+++ a/mm/page_io.c
@@ -51,54 +51,6 @@ void end_swap_bio_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static void swap_slot_free_notify(struct page *page)
-{
-	struct swap_info_struct *sis;
-	struct gendisk *disk;
-	swp_entry_t entry;
-
-	/*
-	 * There is no guarantee that the page is in swap cache - the software
-	 * suspend code (at least) uses end_swap_bio_read() against a non-
-	 * swapcache page.  So we must check PG_swapcache before proceeding with
-	 * this optimization.
-	 */
-	if (unlikely(!PageSwapCache(page)))
-		return;
-
-	sis = page_swap_info(page);
-	if (data_race(!(sis->flags & SWP_BLKDEV)))
-		return;
-
-	/*
-	 * The swap subsystem performs lazy swap slot freeing,
-	 * expecting that the page will be swapped out again.
-	 * So we can avoid an unnecessary write if the page
-	 * isn't redirtied.
-	 * This is good for real swap storage because we can
-	 * reduce unnecessary I/O and enhance wear-leveling
-	 * if an SSD is used as the as swap device.
-	 * But if in-memory swap device (eg zram) is used,
-	 * this causes a duplicated copy between uncompressed
-	 * data in VM-owned memory and compressed data in
-	 * zram-owned memory.  So let's free zram-owned memory
-	 * and make the VM-owned decompressed page *dirty*,
-	 * so the page should be swapped out somewhere again if
-	 * we again wish to reclaim it.
-	 */
-	disk = sis->bdev->bd_disk;
-	entry.val = page_private(page);
-	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
-		unsigned long offset;
-
-		offset = swp_offset(entry);
-
-		SetPageDirty(page);
-		disk->fops->swap_slot_free_notify(sis->bdev,
-				offset);
-	}
-}
-
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
@@ -114,7 +66,6 @@ static void end_swap_bio_read(struct bio
 	}
 
 	SetPageUptodate(page);
-	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
@@ -394,11 +345,6 @@ int swap_readpage(struct page *page, boo
 	if (sis->flags & SWP_SYNCHRONOUS_IO) {
 		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
 		if (!ret) {
-			if (trylock_page(page)) {
-				swap_slot_free_notify(page);
-				unlock_page(page);
-			}
-
 			count_vm_event(PSWPIN);
 			goto out;
 		}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch

