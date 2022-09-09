Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92F5B3EDC
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIIScp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiIIScn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6612D1AA
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38753B8214B
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 18:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82198C433C1;
        Fri,  9 Sep 2022 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662748354;
        bh=fislLb6zegp/xNoH5io4M8xRxwvYvOpB1jrDXnFXNic=;
        h=Subject:To:Cc:From:Date:From;
        b=ECkFqNQ2usq65S+igDC2j85TvAKtIvM7qN1bqo26jbRUjEmk/UYRnPX0LkRhjuDaa
         A52vlgtsIvWyrv1e4qPFpbc1nxOWqLQ92fb/4aYW4nYmhJbb4hGvkCjVpoLI0Imx9k
         ZgAFXNcu6OsTIuNs+DPspio009UT2Sl1VQkbPG6I=
Subject: FAILED: patch "[PATCH] vfio/type1: Unpin zero pages" failed to apply to 4.14-stable tree
To:     alex.williamson@redhat.com, david@redhat.com, lpivarc@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Sep 2022 20:32:25 +0200
Message-ID: <166274834521870@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

873aefb376bb ("vfio/type1: Unpin zero pages")
4b6c33b32296 ("vfio/type1: Prepare for batched pinning with struct vfio_batch")
be16c1fd99f4 ("vfio/type1: Change success value of vaddr_get_pfn()")
aae7a75a821a ("vfio/type1: Add proper error unwind for vfio_iommu_replay()")
64019a2e467a ("mm/gup: remove task_struct pointer for all gup code")
bce617edecad ("mm: do page fault accounting in handle_mm_fault")
ed03d924587e ("mm/gup: use a standard migration target allocation callback")
bbe88753bd42 ("mm/hugetlb: make hugetlb migration callback CMA aware")
41b4dc14ee80 ("mm/gup: restrict CMA region by using allocation scope API")
19fc7bed252c ("mm/migrate: introduce a standard migration target allocation function")
d92bbc2719bd ("mm/hugetlb: unify migration callbacks")
b4b382238ed2 ("mm/migrate: move migration helper from .h to .c")
c7073bab5772 ("mm/page_isolation: prefer the node of the source page")
3e4e28c5a8f0 ("mmap locking API: convert mmap_sem API comments")
d8ed45c5dcd4 ("mmap locking API: use coccinelle to convert mmap_sem rwsem call sites")
ca5999fde0a1 ("mm: introduce include/linux/pgtable.h")
420c2091b65a ("mm/gup: introduce pin_user_pages_locked()")
5a36f0f3f518 ("Merge tag 'vfio-v5.8-rc1' of git://github.com/awilliam/linux-vfio")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4 Mon Sep 17 00:00:00 2001
From: Alex Williamson <alex.williamson@redhat.com>
Date: Mon, 29 Aug 2022 21:05:40 -0600
Subject: [PATCH] vfio/type1: Unpin zero pages

There's currently a reference count leak on the zero page.  We increment
the reference via pin_user_pages_remote(), but the page is later handled
as an invalid/reserved page, therefore it's not accounted against the
user and not unpinned by our put_pfn().

Introducing special zero page handling in put_pfn() would resolve the
leak, but without accounting of the zero page, a single user could
still create enough mappings to generate a reference count overflow.

The zero page is always resident, so for our purposes there's no reason
to keep it pinned.  Therefore, add a loop to walk pages returned from
pin_user_pages_remote() and unpin any zero pages.

Cc: stable@vger.kernel.org
Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/166182871735.3518559.8884121293045337358.stgit@omen
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index db516c90a977..8706482665d1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -558,6 +558,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL, NULL);
 	if (ret > 0) {
+		int i;
+
+		/*
+		 * The zero page is always resident, we don't need to pin it
+		 * and it falls into our invalid/reserved test so we don't
+		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
+		 */
+		for (i = 0 ; i < ret; i++) {
+			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
+				unpin_user_page(pages[i]);
+		}
+
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}

