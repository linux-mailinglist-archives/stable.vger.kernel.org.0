Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3939141
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbfFGPnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbfFGPnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42DD82133D;
        Fri,  7 Jun 2019 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922186;
        bh=bUkpDoWOEbrLwB7zrUSqeSUqVZH9xXs2KqtxME+PaVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9VqTehgwpJ4P97JRv3z18r1Il1vJWCa5KuKXYbtp0UBfKRGN4v25oIsuGcYaPbc4
         QLdBqXFgtfGvQprOIJ0/kBdtwNM+2cXWkEo4ZLZNA3xP4YI6EHBrYgriMpOnRs63an
         sDKLInFylc27Dal0Lt/YVgcEoPGbPMc9yfjx9DMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 4.14 67/69] Revert "binder: fix handling of misaligned binder object"
Date:   Fri,  7 Jun 2019 17:39:48 +0200
Message-Id: <20190607153856.089839424@linuxfoundation.org>
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

This reverts commit 33c6b9ca70a8b066a613e2a3d0331ae8f82aa31a.

The commit message is for a different patch. Reverting and then adding
the same patch back with the correct commit message.

Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: stable <stable@vger.kernel.org> # 4.14
Signed-off-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -945,13 +945,14 @@ enum lru_status binder_alloc_free_page(s
 
 	index = page - alloc->pages;
 	page_addr = (uintptr_t)alloc->buffer + index * PAGE_SIZE;
-
-	mm = alloc->vma_vm_mm;
-	if (!mmget_not_zero(mm))
-		goto err_mmget;
-	if (!down_write_trylock(&mm->mmap_sem))
-		goto err_down_write_mmap_sem_failed;
 	vma = binder_alloc_get_vma(alloc);
+	if (vma) {
+		if (!mmget_not_zero(alloc->vma_vm_mm))
+			goto err_mmget;
+		mm = alloc->vma_vm_mm;
+		if (!down_write_trylock(&mm->mmap_sem))
+			goto err_down_write_mmap_sem_failed;
+	}
 
 	list_lru_isolate(lru, item);
 	spin_unlock(lock);
@@ -964,9 +965,10 @@ enum lru_status binder_alloc_free_page(s
 			       PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
+
+		up_write(&mm->mmap_sem);
+		mmput(mm);
 	}
-	up_write(&mm->mmap_sem);
-	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 


