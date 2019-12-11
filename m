Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E276411B7F0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbfLKPKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbfLKPKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECF320663;
        Wed, 11 Dec 2019 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077048;
        bh=c3vBMZp+lpXGhPTzAWD4guEpdgOH6VJJjvfEyhqNDmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8uGp8pYXRneQEdzUqEF6IC0amuQsMckTEaC9kzcrR1w2beO3mSzB21IWbebSUwn/
         EC4ZRu3l5pGA2RHtD4fHKsao5xR8Xl0oPVLG/JJ1UFd8RZBfquhfXXTT5Rq6ViBUYa
         lyCcSpRRpJ4N/H8U2vz1w6wSTxMvdnjdpGirdh/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 90/92] binder: Fix race between mmap() and binder_alloc_print_pages()
Date:   Wed, 11 Dec 2019 16:06:21 +0100
Message-Id: <20191211150302.985282552@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 8eb52a1ee37aafd9b796713aa0b3ab9cbc455be3 upstream.

binder_alloc_print_pages() iterates over
alloc->pages[0..alloc->buffer_size-1] under alloc->mutex.
binder_alloc_mmap_handler() writes alloc->pages and alloc->buffer_size
without holding that lock, and even writes them before the last bailout
point.

Unfortunately we can't take the alloc->mutex in the ->mmap() handler
because mmap_sem can be taken while alloc->mutex is held.
So instead, we have to locklessly check whether the binder_alloc has been
fully initialized with binder_alloc_get_vma(), like in
binder_alloc_new_buf_locked().

Fixes: 8ef4665aa129 ("android: binder: Add page usage in binder stats")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191018205631.248274-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder_alloc.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -841,14 +841,20 @@ void binder_alloc_print_pages(struct seq
 	int free = 0;
 
 	mutex_lock(&alloc->mutex);
-	for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
-		page = &alloc->pages[i];
-		if (!page->page_ptr)
-			free++;
-		else if (list_empty(&page->lru))
-			active++;
-		else
-			lru++;
+	/*
+	 * Make sure the binder_alloc is fully initialized, otherwise we might
+	 * read inconsistent state.
+	 */
+	if (binder_alloc_get_vma(alloc) != NULL) {
+		for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
+			page = &alloc->pages[i];
+			if (!page->page_ptr)
+				free++;
+			else if (list_empty(&page->lru))
+				active++;
+			else
+				lru++;
+		}
 	}
 	mutex_unlock(&alloc->mutex);
 	seq_printf(m, "  pages: %d:%d:%d\n", active, lru, free);


