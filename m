Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E773617A
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfFEQil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:38:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39342 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:38:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id g9so9882170plm.6
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5b9HOi4EFzIT/wt3cjtFyBfBr7ncWuV380s7kCrdNyo=;
        b=veZTfXVedYuZWQ45Wyr6dDBDcZFIpP3bzSJuWwi3U9ezO7BRovd9RId5dB8Xx/Ng+a
         yCPN+LBX0OkBaNow0bQqm+8o1adx9UNGJ2vGgfGluPe/6Sa5ExYzlXxMU8iS0gksyxId
         bU0BOEPvXpRii1HYg1PNxdu/3d8bbOxYfaxZaiHlcpM+X1+l2jvnGzWCr1ZyXo4E1N0J
         oR2MmFG5Xfs76WQAZBdlgVwzndd7wuX/UrYj3rSz6G2Im29BfuaCJbAOBZDa/CWeDsd9
         ZT0a3d6jSSwB5bifaTJ8XiYpE9p36Nzn5XAj/UL5wWuaWQRuNeSZ4mGEyV5XLBDU01g4
         eH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5b9HOi4EFzIT/wt3cjtFyBfBr7ncWuV380s7kCrdNyo=;
        b=b7RKuExwVvPCm3jh9MvqncvrVyqVXENoQaGbnmMYfRTD61s6HChMM/wedxSTjtf/g7
         /3lB3vdOFSQQ86IHf0WZgJH08xf8ygobFeSnmCFxGLua7STJBYfWNIdcLym79A0BGFW7
         JzKhoezmhm73vfWBiGoqO391zF3mhFeETr/q1XWW7frfHgqGtm6aGduP31KyZXwaTL5m
         PzBXF24mMu3EinEaEGtoBDeujFAQie/e7l0MC8QWCq29EdywrvuR8a762h/JzDQwkvWB
         +SNxgozht9d8QvKS5Ah+prPfHX5WIl8VXnprHDICduM7FeHu4yxo1hTmR9QUAHjrjD22
         yXiA==
X-Gm-Message-State: APjAAAW9ZHUKI9+yhjK714bg9yEr1LcsKkO5C5wmFQFKQCqVRU0NSgkv
        2dB5Ejmu189mcQUGvELCGMO3rg==
X-Google-Smtp-Source: APXvYqxlf8D2zOHwTshA9yFQq+O+tBG2fze8Z46MzaYJ2FCXp9xG8K5umwAIKHPM7jEKsCW1g6I6kw==
X-Received: by 2002:a17:902:2ae6:: with SMTP id j93mr46165975plb.130.1559752720946;
        Wed, 05 Jun 2019 09:38:40 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id h19sm2761912pfn.79.2019.06.05.09.38.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:38:40 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 4.19 2/2] binder: fix race between munmap() and direct reclaim
Date:   Wed,  5 Jun 2019 09:38:25 -0700
Message-Id: <20190605163825.178537-2-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190605163825.178537-1-tkjos@google.com>
References: <20190605163825.178537-1-tkjos@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Todd Kjos <tkjos@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 030c98f35cca7..a654ccfd1a222 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -958,14 +958,13 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
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
@@ -978,10 +977,9 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 			       PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
-
-		up_write(&mm->mmap_sem);
-		mmput(mm);
 	}
+	up_write(&mm->mmap_sem);
+	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

