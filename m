Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBC5A4408
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiH2Hmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiH2Hmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:42:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C43A4F181
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE74BB80D13
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D763C433C1;
        Mon, 29 Aug 2022 07:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758960;
        bh=lhHGmYTmVYGWuJCYm31iqUQZk2b0LEG03GR1330vCT8=;
        h=Subject:To:Cc:From:Date:From;
        b=j5fbt/KPnT/CEMjdUea/AC+rWwkBLd2jGUTvhVLlAjtT/UzFw5n0eYumtuFxupH+c
         9CESR5KwteZ++n9k00Wnsu4CwzsoR1kDGxCKsIlZ2Ga0IspMF9kowjFhcLoGaBiDpo
         fW/sGQ/TdrtHQ868gPd1f8J88XbAadb67CRHNp5U=
Subject: FAILED: patch "[PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()" failed to apply to 5.4-stable tree
To:     jgross@suse.com, jbeulich@suse.com, oleksandr_tyshchenko@epam.com,
        stable@vger.kernel.org, subkhankulov@ispras.ru
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:42:37 +0200
Message-ID: <166175895712190@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c5deb27895e017a0267de0a20d140ad5fcc55a54 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Thu, 25 Aug 2022 16:19:18 +0200
Subject: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

The error exit of privcmd_ioctl_dm_op() is calling unlock_pages()
potentially with pages being NULL, leading to a NULL dereference.

Additionally lock_pages() doesn't check for pin_user_pages_fast()
having been completely successful, resulting in potentially not
locking all pages into memory. This could result in sporadic failures
when using the related memory in user mode.

Fix all of that by calling unlock_pages() always with the real number
of pinned pages, which will be zero in case pages being NULL, and by
checking the number of pages pinned by pin_user_pages_fast() matching
the expected number of pages.

Cc: <stable@vger.kernel.org>
Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Link: https://lore.kernel.org/r/20220825141918.3581-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 3369734108af..e88e8f6f0a33 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -581,27 +581,30 @@ static int lock_pages(
 	struct privcmd_dm_op_buf kbufs[], unsigned int num,
 	struct page *pages[], unsigned int nr_pages, unsigned int *pinned)
 {
-	unsigned int i;
+	unsigned int i, off = 0;
 
-	for (i = 0; i < num; i++) {
+	for (i = 0; i < num; ) {
 		unsigned int requested;
 		int page_count;
 
 		requested = DIV_ROUND_UP(
 			offset_in_page(kbufs[i].uptr) + kbufs[i].size,
-			PAGE_SIZE);
+			PAGE_SIZE) - off;
 		if (requested > nr_pages)
 			return -ENOSPC;
 
 		page_count = pin_user_pages_fast(
-			(unsigned long) kbufs[i].uptr,
+			(unsigned long)kbufs[i].uptr + off * PAGE_SIZE,
 			requested, FOLL_WRITE, pages);
-		if (page_count < 0)
-			return page_count;
+		if (page_count <= 0)
+			return page_count ? : -EFAULT;
 
 		*pinned += page_count;
 		nr_pages -= page_count;
 		pages += page_count;
+
+		off = (requested == page_count) ? 0 : off + page_count;
+		i += !off;
 	}
 
 	return 0;
@@ -677,10 +680,8 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	}
 
 	rc = lock_pages(kbufs, kdata.num, pages, nr_pages, &pinned);
-	if (rc < 0) {
-		nr_pages = pinned;
+	if (rc < 0)
 		goto out;
-	}
 
 	for (i = 0; i < kdata.num; i++) {
 		set_xen_guest_handle(xbufs[i].h, kbufs[i].uptr);
@@ -692,7 +693,7 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	xen_preemptible_hcall_end();
 
 out:
-	unlock_pages(pages, nr_pages);
+	unlock_pages(pages, pinned);
 	kfree(xbufs);
 	kfree(pages);
 	kfree(kbufs);

