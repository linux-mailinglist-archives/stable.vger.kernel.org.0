Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45D138F97
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfFGPnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbfFGPnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:43:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E2221479;
        Fri,  7 Jun 2019 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922189;
        bh=ihWvF9ruba1hnYDVsjmjftpcIcaGfogWK5Jvvp4ATI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ysno1vbX22c9k4NCVY6wjIEXzBi9Jipoa4a+SFkLvv9tBSvNf7wIwlnqQ4neS0Ii0
         RUBelejSwCnOsMHVxjK2iV/EmaXYhZ2QEnN6xU45wsJec9KCCTxfamC21qbMuZf5dG
         +W35aiJbej54KtKavJXDrwhfH+I76BIiB7I1Buow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com, Joel
        Fernandes" <joel@joelfernandes.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Todd Kjos <tkjos@google.com>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 4.14 68/69] binder: fix race between munmap() and direct reclaim
Date:   Fri,  7 Jun 2019 17:39:49 +0200
Message-Id: <20190607153856.182759891@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit 5cec2d2e5839f9c0fec319c523a911e0a7fd299f upstream.

An munmap() on a binder device causes binder_vma_close() to be called
which clears the alloc->vma pointer.

If direct reclaim causes binder_alloc_free_page() to be called, there
is a race where alloc->vma is read into a local vma pointer and then
used later after the mm->mmap_sem is acquired. This can result in
calling zap_page_range() with an invalid vma which manifests as a
use-after-free in zap_page_range().

The fix is to check alloc->vma after acquiring the mmap_sem (which we
were acquiring anyway) and skip zap_page_range() if it has changed
to NULL.

Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Todd Kjos <tkjos@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable <stable@vger.kernel.org> # 4.14
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -945,14 +945,13 @@ enum lru_status binder_alloc_free_page(s
 
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
@@ -965,10 +964,9 @@ enum lru_status binder_alloc_free_page(s
 			       PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
-
-		up_write(&mm->mmap_sem);
-		mmput(mm);
 	}
+	up_write(&mm->mmap_sem);
+	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 


