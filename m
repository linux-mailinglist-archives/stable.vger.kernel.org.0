Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E36F797
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfD3Lpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730432AbfD3Lpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDB321744;
        Tue, 30 Apr 2019 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624742;
        bh=7uCSJO1BBT+F8A40pDYcZ/El2I5jL9KAAxdyytmTg3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4tlkYsS8L1L/x5skiOXssmTLiwAyI7x/c2JeGBEqPWJwYFU5h4RIxRh5Hg33Mj6A
         xrpvJZ0Jv8gtn+am7/Kzg7cDEDgvhmA4KPZl67N+kZz1aNVIP9P0Z8uPqZf62QADG2
         B0FFtDnSKhZds72evVZy4MT8geACpGdYyeRrG+8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        syzbot+55de1eb4975dec156d8f@syzkaller.appspotmail.com
Subject: [PATCH 4.19 056/100] binder: fix handling of misaligned binder object
Date:   Tue, 30 Apr 2019 13:38:25 +0200
Message-Id: <20190430113611.575125000@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit 26528be6720bb40bc8844e97ee73a37e530e9c5e upstream.

Fixes crash found by syzbot:
kernel BUG at drivers/android/binder_alloc.c:LINE! (2)

Reported-and-tested-by: syzbot+55de1eb4975dec156d8f@syzkaller.appspotmail.com
Signed-off-by: Todd Kjos <tkjos@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable <stable@vger.kernel.org> # 5.0, 4.19, 4.14
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder_alloc.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -958,14 +958,13 @@ enum lru_status binder_alloc_free_page(s
 
 	index = page - alloc->pages;
 	page_addr = (uintptr_t)alloc->buffer + index * PAGE_SIZE;
+
+	mm = alloc->vma_vm_mm;
+	if (!mmget_not_zero(mm))
+		goto err_mmget;
+	if (!down_write_trylock(&mm->mmap_sem))
+		goto err_down_write_mmap_sem_failed;
 	vma = binder_alloc_get_vma(alloc);
-	if (vma) {
-		if (!mmget_not_zero(alloc->vma_vm_mm))
-			goto err_mmget;
-		mm = alloc->vma_vm_mm;
-		if (!down_write_trylock(&mm->mmap_sem))
-			goto err_down_write_mmap_sem_failed;
-	}
 
 	list_lru_isolate(lru, item);
 	spin_unlock(lock);
@@ -978,10 +977,9 @@ enum lru_status binder_alloc_free_page(s
 			       PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
-
-		up_write(&mm->mmap_sem);
-		mmput(mm);
 	}
+	up_write(&mm->mmap_sem);
+	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 


