Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35041C15E9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgEANgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbgEANf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC9D524957;
        Fri,  1 May 2020 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340158;
        bh=qD6bBSu2ZmstztKjHgRkJXOnn8LSOtvA6gBtfCm4XtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6YjrdvZU5eNeA4svb5tHdjdHJSo002OAc7U8xGZZxhDJyt14eBwdawitEB9flbvo
         5CNOVnDCxYiuSNL90bb6kGmYTi5a8t+P7mzDkXb6oEwnG4zvbQWGvKedNUVueC29uh
         uGharmzYThNesuHHI6JSdw8heNml7w40ZyvSckWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>,
        Todd Kjos <tkjos@android.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 04/46] binder: take read mode of mmap_sem in binder_alloc_free_page()
Date:   Fri,  1 May 2020 15:22:29 +0200
Message-Id: <20200501131500.358343650@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

commit 60d4885710836595192c42d3e04b27551d30ec91 upstream.

Restore the behavior of locking mmap_sem for reading in
binder_alloc_free_page(), as was first done in commit 3013bf62b67a
("binder: reduce mmap_sem write-side lock"). That change was
inadvertently reverted by commit 5cec2d2e5839 ("binder: fix race between
munmap() and direct reclaim").

In addition, change the name of the label for the error path to
accurately reflect that we're taking the lock for reading.

Backporting note: This fix is only needed when *both* of the commits
mentioned above are applied. That's an unlikely situation since they
both landed during the development of v5.1 but only one of them is
targeted for stable.

Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Acked-by: Todd Kjos <tkjos@android.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -970,8 +970,8 @@ enum lru_status binder_alloc_free_page(s
 	mm = alloc->vma_vm_mm;
 	if (!mmget_not_zero(mm))
 		goto err_mmget;
-	if (!down_write_trylock(&mm->mmap_sem))
-		goto err_down_write_mmap_sem_failed;
+	if (!down_read_trylock(&mm->mmap_sem))
+		goto err_down_read_mmap_sem_failed;
 	vma = binder_alloc_get_vma(alloc);
 
 	list_lru_isolate(lru, item);
@@ -986,7 +986,7 @@ enum lru_status binder_alloc_free_page(s
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
-	up_write(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
@@ -1001,7 +1001,7 @@ enum lru_status binder_alloc_free_page(s
 	mutex_unlock(&alloc->mutex);
 	return LRU_REMOVED_RETRY;
 
-err_down_write_mmap_sem_failed:
+err_down_read_mmap_sem_failed:
 	mmput_async(mm);
 err_mmget:
 err_page_already_freed:


