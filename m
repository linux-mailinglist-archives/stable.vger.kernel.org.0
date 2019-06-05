Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE0536174
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfFEQiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:38:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41652 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:38:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id s24so9741391plr.8
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xyxKqNpGTga1iCLjIrrA8FoWZ4Rw0RZzIUMaC1T+glE=;
        b=cATE6al2RzR9ep8sr7dy0Wb/kyXnSbSayJr9DHpw9i1cXwzReT0A/fbix7W89s8EL9
         Hc8TECFYikfRXIj1kHWT1gExkeXJx/LHow5HLA5fJOtWCMzgyKp000tdOptCVDeuvA4P
         TgiMXhcc5eAAbhWIrFqLANv/K6oW6m9xalosgx9/HXYY5vDRztwWqZziWvDQJsr0Ccxw
         uq0UIYzbOa+cZnalPq+JjbPCaPbQewExbWK6dN9Y1mU8McTTv3QifjOuIi1JlSCOSwji
         zhQNI2zbwKrUAbXBUnoclSqA4jpIx4BtI49P/E0T7BHW6m3FysG5EzUGtgxJmUeq63gm
         RxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xyxKqNpGTga1iCLjIrrA8FoWZ4Rw0RZzIUMaC1T+glE=;
        b=WuhvTm+TvR2f4zEzGh0u0iiWibpqResWUgj3+Q1xN2zQhTtU/2lktTL9rkwZUeAyiF
         WCBNfhhPSal2xE4nk0yRE3DeHyS0EdNLKco3Lqjx3GbN5DePGi3n8nrUBOCv0uGGL+uN
         NeevnhFLGvqoWaHWuT+j7+nOog0KHxZPdZf02skbfcp9xneDrAl5r3ikSJN3bZd7m9d2
         FNy2hqD6NVtvIMAReOfrAlDXRyQdzb8hBtTTNAY3aV8/n7BQxA7Bo28qLL8Y5F2vk9L1
         SX+aLz8BwzJ2t73nqXOMwgjchf4yKbW1WrJ4pP/qvz+dfgEJtDfFESclll4Rj44quIws
         KKSw==
X-Gm-Message-State: APjAAAUsAlzZAY7yq2hFto56rsLH9CjcxR6z9AgBHcAG16E7w+VSprwD
        aUV+QeJEsmBzFhUPYyjn+4q5Gg==
X-Google-Smtp-Source: APXvYqzTKcIlRRi6H8kwcLMAORRVjiMx5va2XfMHXtK2Q59lTlPHCpdc9jJs4qvfHuL2OOf/7lO8dQ==
X-Received: by 2002:a17:902:b204:: with SMTP id t4mr45024836plr.285.1559752682997;
        Wed, 05 Jun 2019 09:38:02 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id 25sm22785908pfp.76.2019.06.05.09.38.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:38:02 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 4.14 2/2] binder: fix race between munmap() and direct reclaim
Date:   Wed,  5 Jun 2019 09:37:46 -0700
Message-Id: <20190605163746.178413-2-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190605163746.178413-1-tkjos@google.com>
References: <20190605163746.178413-1-tkjos@google.com>
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
Cc: stable <stable@vger.kernel.org> # 4.14
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index b9281f2725a6a..e0b0399ff7ec8 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -945,14 +945,13 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
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
@@ -965,10 +964,9 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
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

