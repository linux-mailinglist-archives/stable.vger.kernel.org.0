Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289442EA759
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbhAEJ2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbhAEJ2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4441225AC;
        Tue,  5 Jan 2021 09:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838884;
        bh=vkc6pN/DQ/bhfM6izeTJVgwQ3DxZVYt5WdA+r1Eyhco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkwEukSTDXIzxZQ9URYQ8U/0kFzkSMAa1myr/ffgr80yh+XdmpQUS8fzZWEkuNzD0
         fGqn5wF9j+AXdbeXDwvxvVQB7JZ2yJr8jG+q8EStNgAkt+yys5TiUu7TUkygif8jA3
         iXLgby6ffC4Mb7kc/f3rsZuk6FmYFzMUzykRHRPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: [PATCH 4.19 12/29] xen/gntdev.c: Mark pages as dirty
Date:   Tue,  5 Jan 2021 10:28:58 +0100
Message-Id: <20210105090820.118582071@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

commit 779055842da5b2e508f3ccf9a8153cb1f704f566 upstream.

There seems to be a bug in the original code when gntdev_get_page()
is called with writeable=true then the page needs to be marked dirty
before being put.

To address this, a bool writeable is added in gnt_dev_copy_batch, set
it in gntdev_grant_copy_seg() (and drop `writeable` argument to
gntdev_get_page()) and then, based on batch->writeable, use
set_page_dirty_lock().

Fixes: a4cdb556cae0 (xen/gntdev: add ioctl for grant copy)
Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1599375114-32360-1-git-send-email-jrdr.linux@gmail.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
[jinoh: backport accounting for missing
  commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")]
Signed-off-by: Jinoh Kang <jinoh.kang.kr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -842,17 +842,18 @@ struct gntdev_copy_batch {
 	s16 __user *status[GNTDEV_COPY_BATCH];
 	unsigned int nr_ops;
 	unsigned int nr_pages;
+	bool writeable;
 };
 
 static int gntdev_get_page(struct gntdev_copy_batch *batch, void __user *virt,
-			   bool writeable, unsigned long *gfn)
+				unsigned long *gfn)
 {
 	unsigned long addr = (unsigned long)virt;
 	struct page *page;
 	unsigned long xen_pfn;
 	int ret;
 
-	ret = get_user_pages_fast(addr, 1, writeable, &page);
+	ret = get_user_pages_fast(addr, 1, batch->writeable, &page);
 	if (ret < 0)
 		return ret;
 
@@ -868,9 +869,13 @@ static void gntdev_put_pages(struct gntd
 {
 	unsigned int i;
 
-	for (i = 0; i < batch->nr_pages; i++)
+	for (i = 0; i < batch->nr_pages; i++) {
+		if (batch->writeable && !PageDirty(batch->pages[i]))
+			set_page_dirty_lock(batch->pages[i]);
 		put_page(batch->pages[i]);
+	}
 	batch->nr_pages = 0;
+	batch->writeable = false;
 }
 
 static int gntdev_copy(struct gntdev_copy_batch *batch)
@@ -959,8 +964,9 @@ static int gntdev_grant_copy_seg(struct
 			virt = seg->source.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = false;
 
-			ret = gntdev_get_page(batch, virt, false, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 
@@ -978,8 +984,9 @@ static int gntdev_grant_copy_seg(struct
 			virt = seg->dest.virt + copied;
 			off = (unsigned long)virt & ~XEN_PAGE_MASK;
 			len = min(len, (size_t)XEN_PAGE_SIZE - off);
+			batch->writeable = true;
 
-			ret = gntdev_get_page(batch, virt, true, &gfn);
+			ret = gntdev_get_page(batch, virt, &gfn);
 			if (ret < 0)
 				return ret;
 


