Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEDA1B68E5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgDWXSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:18:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48902 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728259AbgDWXGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:36 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004f5-5o; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvN-00E6lp-2W; Fri, 24 Apr 2020 00:06:29 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Pete Zaitcev" <zaitcev@redhat.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        syzbot+56f9673bb4cdcbeb0e92@syzkaller.appspotmail.com
Date:   Fri, 24 Apr 2020 00:05:12 +0100
Message-ID: <lsq.1587683028.661639032@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 085/245] usb: mon: Fix a deadlock in usbmon between
 mmap and read
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pete Zaitcev <zaitcev@redhat.com>

commit 19e6317d24c25ee737c65d1ffb7483bdda4bb54a upstream.

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
Link: https://lore.kernel.org/r/20191204203941.3503452b@suzdal.zaitcev.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/mon/mon_bin.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1034,12 +1034,18 @@ static long mon_bin_ioctl(struct file *f
 
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
@@ -1211,13 +1217,21 @@ mon_bin_poll(struct file *file, struct p
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
@@ -1229,16 +1243,12 @@ static int mon_bin_vma_fault(struct vm_a
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

