Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383B7E6854
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbfJ0VVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732003AbfJ0VVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CF4205C9;
        Sun, 27 Oct 2019 21:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211309;
        bh=ZsDH3NgIiIv8WoNggeN0CAZhb5agtvBUOhbYhrM+c1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQQw8YS+gWtCevP7F/nMAxmweZB3VENKiJIcuwPvV5XGwHyajPvVKA26PQqHcMHNC
         dr7tRrrNzIHEalXHaisOTysASE+aiuYJlxcwObVLJn+0r7F+fqX+kj8pZwka1L8YwO
         RSkM0OdYW6yTnk9XeRyuqTu/9FmSUZ0pCrUJaXQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.3 106/197] binder: Dont modify VMA bounds in ->mmap handler
Date:   Sun, 27 Oct 2019 22:00:24 +0100
Message-Id: <20191027203357.480111405@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 45d02f79b539073b76077836871de6b674e36eb4 upstream.

binder_mmap() tries to prevent the creation of overly big binder mappings
by silently truncating the size of the VMA to 4MiB. However, this violates
the API contract of mmap(). If userspace attempts to create a large binder
VMA, and later attempts to unmap that VMA, it will call munmap() on a range
beyond the end of the VMA, which may have been allocated to another VMA in
the meantime. This can lead to userspace memory corruption.

The following sequence of calls leads to a segfault without this commit:

int main(void) {
  int binder_fd = open("/dev/binder", O_RDWR);
  if (binder_fd == -1) err(1, "open binder");
  void *binder_mapping = mmap(NULL, 0x800000UL, PROT_READ, MAP_SHARED,
                              binder_fd, 0);
  if (binder_mapping == MAP_FAILED) err(1, "mmap binder");
  void *data_mapping = mmap(NULL, 0x400000UL, PROT_READ|PROT_WRITE,
                            MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  if (data_mapping == MAP_FAILED) err(1, "mmap data");
  munmap(binder_mapping, 0x800000UL);
  *(char*)data_mapping = 1;
  return 0;
}

Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191016150119.154756-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c       |    7 -------
 drivers/android/binder_alloc.c |    6 ++++--
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -95,10 +95,6 @@ DEFINE_SHOW_ATTRIBUTE(proc);
 #define SZ_1K                               0x400
 #endif
 
-#ifndef SZ_4M
-#define SZ_4M                               0x400000
-#endif
-
 #define FORBIDDEN_MMAP_FLAGS                (VM_WRITE)
 
 enum {
@@ -5195,9 +5191,6 @@ static int binder_mmap(struct file *filp
 	if (proc->tsk != current->group_leader)
 		return -EINVAL;
 
-	if ((vma->vm_end - vma->vm_start) > SZ_4M)
-		vma->vm_end = vma->vm_start + SZ_4M;
-
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%s: %d %lx-%lx (%ld K) vma %lx pagep %lx\n",
 		     __func__, proc->pid, vma->vm_start, vma->vm_end,
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -22,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
+#include <linux/sizes.h>
 #include "binder_alloc.h"
 #include "binder_trace.h"
 
@@ -689,7 +690,9 @@ int binder_alloc_mmap_handler(struct bin
 	alloc->buffer = (void __user *)vma->vm_start;
 	mutex_unlock(&binder_alloc_mmap_lock);
 
-	alloc->pages = kcalloc((vma->vm_end - vma->vm_start) / PAGE_SIZE,
+	alloc->buffer_size = min_t(unsigned long, vma->vm_end - vma->vm_start,
+				   SZ_4M);
+	alloc->pages = kcalloc(alloc->buffer_size / PAGE_SIZE,
 			       sizeof(alloc->pages[0]),
 			       GFP_KERNEL);
 	if (alloc->pages == NULL) {
@@ -697,7 +700,6 @@ int binder_alloc_mmap_handler(struct bin
 		failure_string = "alloc page array";
 		goto err_alloc_pages_failed;
 	}
-	alloc->buffer_size = vma->vm_end - vma->vm_start;
 
 	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
 	if (!buffer) {


