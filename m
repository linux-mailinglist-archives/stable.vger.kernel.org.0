Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36F7118619
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfLJLVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D9D2073B;
        Tue, 10 Dec 2019 11:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575976897;
        bh=twWZcSLlpO8LVo9KmGYYr2/v53aWym8f3yPRDKG1rN4=;
        h=Subject:To:From:Date:From;
        b=HWbgRSh/AduMXnNFlZ2U1lmmoJo5yQVR6ce0umdsM+HpTKabCo6leDnZueZ1BRap6
         4wPEw2yXr//sNvGrkZ3/HoUZb/0dAlcD/1+dptherGIv2wPGxW7HKVyjVgBiHr+KOA
         uS0BA4kMebqwgQM8jblMQpCRIq9Xmij126PTOXsU=
Subject: patch "usb: mon: Fix a deadlock in usbmon between mmap and read" added to usb-linus
To:     zaitcev@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 12:21:22 +0100
Message-ID: <157597688244235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: mon: Fix a deadlock in usbmon between mmap and read

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 19e6317d24c25ee737c65d1ffb7483bdda4bb54a Mon Sep 17 00:00:00 2001
From: Pete Zaitcev <zaitcev@redhat.com>
Date: Wed, 4 Dec 2019 20:39:41 -0600
Subject: usb: mon: Fix a deadlock in usbmon between mmap and read

The problem arises because our read() function grabs a lock of the
circular buffer, finds something of interest, then invokes copy_to_user()
straight from the buffer, which in turn takes mm->mmap_sem. In the same
time, the callback mon_bin_vma_fault() is invoked under mm->mmap_sem.
It attempts to take the fetch lock and deadlocks.

This patch does away with protecting of our page list with any
semaphores, and instead relies on the kernel not close the device
while mmap is active in a process.

In addition, we prohibit re-sizing of a buffer while mmap is active.
This way, when (now unlocked) fault is processed, it works with the
page that is intended to be mapped-in, and not some other random page.
Note that this may have an ABI impact, but hopefully no legitimate
program is this wrong.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Reported-by: syzbot+56f9673bb4cdcbeb0e92@syzkaller.appspotmail.com
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 46eb14a6e158 ("USB: fix usbmon BUG trigger")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191204203941.3503452b@suzdal.zaitcev.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mon/mon_bin.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index ac2b4fcc265f..f48a23adbc35 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1039,12 +1039,18 @@ static long mon_bin_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 
 		mutex_lock(&rp->fetch_lock);
 		spin_lock_irqsave(&rp->b_lock, flags);
-		mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
-		kfree(rp->b_vec);
-		rp->b_vec  = vec;
-		rp->b_size = size;
-		rp->b_read = rp->b_in = rp->b_out = rp->b_cnt = 0;
-		rp->cnt_lost = 0;
+		if (rp->mmap_active) {
+			mon_free_buff(vec, size/CHUNK_SIZE);
+			kfree(vec);
+			ret = -EBUSY;
+		} else {
+			mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
+			kfree(rp->b_vec);
+			rp->b_vec  = vec;
+			rp->b_size = size;
+			rp->b_read = rp->b_in = rp->b_out = rp->b_cnt = 0;
+			rp->cnt_lost = 0;
+		}
 		spin_unlock_irqrestore(&rp->b_lock, flags);
 		mutex_unlock(&rp->fetch_lock);
 		}
@@ -1216,13 +1222,21 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
 static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
+	unsigned long flags;
+
 	struct mon_reader_bin *rp = vma->vm_private_data;
+	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
 /*
@@ -1234,16 +1248,12 @@ static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
 
-	mutex_lock(&rp->fetch_lock);
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rp->b_size) {
-		mutex_unlock(&rp->fetch_lock);
+	if (offset >= rp->b_size)
 		return VM_FAULT_SIGBUS;
-	}
 	chunk_idx = offset / CHUNK_SIZE;
 	pageptr = rp->b_vec[chunk_idx].pg;
 	get_page(pageptr);
-	mutex_unlock(&rp->fetch_lock);
 	vmf->page = pageptr;
 	return 0;
 }
-- 
2.24.0


