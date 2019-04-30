Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0D5F7F7
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfD3Lmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729394AbfD3Lmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB0D217D9;
        Tue, 30 Apr 2019 11:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624559;
        bh=zkB8se4ixRqLV7j9UHr1XpeCeaXH7VbOs8OCBmIF66I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3+AcEz+QfeVejQWGMD/0/OUxrzSFhqGBnHwZykNyPhb4qeICEZjvnMZWEhm9oGrA
         8OzF0Chr4RpObbSvTqXpdY4T4Qk/iKoEnyTDVqSy7zX6W/z7Di95M94+wbdQc+QPwD
         Gqo9NrXQ/7tc2MSbijR2NoTY2cSG9E3R9yMiLBXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        syzbot+55de1eb4975dec156d8f@syzkaller.appspotmail.com
Subject: [PATCH 4.14 32/53] binder: fix handling of misaligned binder object
Date:   Tue, 30 Apr 2019 13:38:39 +0200
Message-Id: <20190430113556.841929903@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
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
 


