Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F1811B5CA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbfLKP4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731802AbfLKPPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD24020663;
        Wed, 11 Dec 2019 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077331;
        bh=5C/viSkFRj3DF/5+noj7PCPu039K0DAERLDB0HULPn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLeHIJZ86P5Cfb7NQCAF5VYhq+kQBbA2wbzION3d/Nd5wkYIxunL61EZfWae8PmrK
         J6TdzpzmVQcvnOEpXxbUPrkE2LsiG/Bj1PzueyaLR9yEeUieNsJL8ZPIs/E+RAljpr
         E5Awasvqb2zSnoGD+4LcxYpMgUFFvg0A7n1IkpCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.3 104/105] binder: Prevent repeated use of ->mmap() via NULL mapping
Date:   Wed, 11 Dec 2019 16:06:33 +0100
Message-Id: <20191211150306.087939736@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit a7a74d7ff55a0c657bc46238b050460b9eacea95 upstream.

binder_alloc_mmap_handler() attempts to detect the use of ->mmap() on a
binder_proc whose binder_alloc has already been initialized by checking
whether alloc->buffer is non-zero.

Before commit 880211667b20 ("binder: remove kernel vm_area for buffer
space"), alloc->buffer was a kernel mapping address, which is always
non-zero, but since that commit, it is a userspace mapping address.

A sufficiently privileged user can map /dev/binder at NULL, tricking
binder_alloc_mmap_handler() into assuming that the binder_proc has not been
mapped yet. This leads to memory unsafety.
Luckily, no context on Android has such privileges, and on a typical Linux
desktop system, you need to be root to do that.

Fix it by using the mapping size instead of the mapping address to
distinguish the mapped case. A valid VMA can't have size zero.

Fixes: 880211667b20 ("binder: remove kernel vm_area for buffer space")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191018205631.248274-2-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -681,17 +681,17 @@ int binder_alloc_mmap_handler(struct bin
 	struct binder_buffer *buffer;
 
 	mutex_lock(&binder_alloc_mmap_lock);
-	if (alloc->buffer) {
+	if (alloc->buffer_size) {
 		ret = -EBUSY;
 		failure_string = "already mapped";
 		goto err_already_mapped;
 	}
+	alloc->buffer_size = min_t(unsigned long, vma->vm_end - vma->vm_start,
+				   SZ_4M);
+	mutex_unlock(&binder_alloc_mmap_lock);
 
 	alloc->buffer = (void __user *)vma->vm_start;
-	mutex_unlock(&binder_alloc_mmap_lock);
 
-	alloc->buffer_size = min_t(unsigned long, vma->vm_end - vma->vm_start,
-				   SZ_4M);
 	alloc->pages = kcalloc(alloc->buffer_size / PAGE_SIZE,
 			       sizeof(alloc->pages[0]),
 			       GFP_KERNEL);
@@ -722,8 +722,9 @@ err_alloc_buf_struct_failed:
 	kfree(alloc->pages);
 	alloc->pages = NULL;
 err_alloc_pages_failed:
-	mutex_lock(&binder_alloc_mmap_lock);
 	alloc->buffer = NULL;
+	mutex_lock(&binder_alloc_mmap_lock);
+	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,


