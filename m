Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F712698F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfLSSi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbfLSSi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E22424672;
        Thu, 19 Dec 2019 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780736;
        bh=n0R84Wlbi1EN+zgAoGETcxrfBsDxb76mo6+qqDnhY10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKd4LV5I0K6jVQdekYS2yewHjVsx+Cww2oe5KNRyJFLeFvbyXHxvXrUh2r6J7WKMX
         zEFcBa3YWHf9c6qmctKjKAp15Y/GO43EK9m3rANTHe/3gS+dLgIwLg6AKoQ3HutGpv
         bJiPe5X2BWk/WlByI8IWws/6Ob6fJ1QybKpJifMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>,
        syzbot+56f9673bb4cdcbeb0e92@syzkaller.appspotmail.com,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.4 096/162] usb: mon: Fix a deadlock in usbmon between mmap and read
Date:   Thu, 19 Dec 2019 19:33:24 +0100
Message-Id: <20191219183213.631341595@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191204203941.3503452b@suzdal.zaitcev.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/mon/mon_bin.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1035,12 +1035,18 @@ static long mon_bin_ioctl(struct file *f
 
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
@@ -1212,13 +1218,21 @@ mon_bin_poll(struct file *file, struct p
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
@@ -1230,16 +1244,12 @@ static int mon_bin_vma_fault(struct vm_a
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


