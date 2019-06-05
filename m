Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA63617D
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfFEQjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:39:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34841 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:39:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so9883766plo.2
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YOr6z0ZXqJV67ys9T86wrtvPUjR3z2zzHbO2+bSp4sM=;
        b=ZqhJiARNuxfoi1HIiv9yKhtT3tt0MQ3BT85Vv/D6ssMVchn7kO2vPfPwGuGXV0hulU
         ufEa32ytOarfcDPwP9U2QefOPBuTnFV2xkupQBZNd8jB5VvF3LpvpFp2SAmkhiqUGxbt
         ItTfNisYQILlTCAnNuk59+1KfZ/wnTimtZDGBcNQQLFfdIv82MxLhGX0bq6mPbz8vY9E
         JfjWwGMmy4YfdBvZoMLMiv6Ya2ylvew/Oasx87JdI6+6HG5UXfbv9SkKGvxxpMUq7urf
         hEcOIZjHqWVFlwpUYhL8HGPMeOFgLW7eG60rBFtjdJqk8X2KrwXEKnrznTorJ8jrAcOO
         wkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YOr6z0ZXqJV67ys9T86wrtvPUjR3z2zzHbO2+bSp4sM=;
        b=nZnI+3pfaCUW4ZiQ6eEY5RhQ32VxBiW3L/elCzdsV1wqNXSllIgni+nYLjbWFH/Dr1
         QwGRrceQzB1Iy+ELsbDtnoJ3FKcF9oRoSWEU9f5dtmRKCFUWh8wq/ZxjOqbPaN8ZBNjj
         muSaHMDEadLr5SzHiW+kMzKOEQYYgYXUyEtS9Ljd1MDEMlEvJydAi4ladY0AyGohc1zV
         vXW6zZ1r1inzGAwIYmZxKdx0EjYHZs4SyKDxSCN7yWW/sFWxVFVjMKv7KaDJ0cX82BlN
         BX9OkEwCQ2E8GBhXC5eW9HStwbghi1NJYPDDLK/ojv0iIGYKpiZhAy+D/Dt/e0kLsyhq
         mEPg==
X-Gm-Message-State: APjAAAUw/HmesvHUnc/EWFmU8SKiHQ+OItVUs2swLBBXwLIP2QktNFdV
        mRRda6poDuhAFJzEba5a2UA0rw==
X-Google-Smtp-Source: APXvYqyuEo1uJdLQiETlFJDwYKKA6SU7Jdk5vIih0Kme81EpHlvl1ko2xXyDuVOvzFF5olPsDgKKrA==
X-Received: by 2002:a17:902:e301:: with SMTP id cg1mr25907468plb.184.1559752781815;
        Wed, 05 Jun 2019 09:39:41 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id l63sm22493057pfl.181.2019.06.05.09.39.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:39:41 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.0 2/2] binder: fix race between munmap() and direct reclaim
Date:   Wed,  5 Jun 2019 09:39:30 -0700
Message-Id: <20190605163930.178758-2-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190605163930.178758-1-tkjos@google.com>
References: <20190605163930.178758-1-tkjos@google.com>
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
Cc: stable <stable@vger.kernel.org> # 5.0
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 022cd80e80cc3..a6e556bf62dff 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -959,14 +959,13 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
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
@@ -979,10 +978,9 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
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

