Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6A61A573
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKDXMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDXMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:12:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820B450B1
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 16:12:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36fde8f2cdcso58050887b3.23
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 16:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xG8SF42tN7XJN1Q1/ybEZcxUZopQ7i5Q8n92aTP8rTA=;
        b=tdEbBLnkjqwBbh7mLxH/Hzv5saWzHJsiuGO1JdrLEH1aSoLYNPgSALLnmnrk1MPvh/
         JIPJCaqnu93XVSnYgZGjyFvZmbkuSiyNxPuJ/niHgumMs02X6CW2dXrDvTWrRTAyJKoH
         0bBCOnHT5uhKFMgZtbyGvCWTel+cD3XVCTnrPLp0vKZRIkw9JaQS/Ed/1EQdhhvGTjJ6
         dg4n+1TuGl0VFscIP/fVd028BYD8TpXcxEFpRfW8E8H/G7NR4QQSSecIv5aZKgXc4T4f
         VD6bDEyKb13O425K+X+aDNZ9hi0RbavOP2FDIWWjJcc78NYvj5OQTiromrial3O4O7y3
         LFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xG8SF42tN7XJN1Q1/ybEZcxUZopQ7i5Q8n92aTP8rTA=;
        b=p4cVMc+ElfgKFx9u7GvlMi7As+DKEfpqAgnALWAi9xPxeEiGY85kyOh+d9iv+tFgTb
         BWwkRG4qHeIoGZJxDkLqgULe3yDlMQ7aJL8G+mcgSf+ieMNAB/105JSLmTxmgMaLnvLh
         SyLDPSdvz1vAMVB69ksYvzkzsLjbR1FEuJX7eP72cAC6/RFheBBo6Gv+hCL4Kk+bg7b3
         0lDlqZJpzLM5pCSb3TCMgO4WmXfkAXO0kArQ4On7sUp3QvqlX3BqEkc9v7okuwwX7/gI
         C8wrGzKscqA7GtO7SOU67pIYB+BGM/8KPFlifVDLAEEAe1eTk7WAdvB5mKSv0nnHL3UA
         EofQ==
X-Gm-Message-State: ACrzQf0ewstZXWPfi3AAoedrUIlaOS8xb0urJiSoc30BAbJzxlnQMS+5
        MEFlJBG5FV7VKC2LdLW2CJhqamF6fjolRQ==
X-Google-Smtp-Source: AMsMyM5HF8y6DHVqifbG2yHGSsCpt3xo+QvJoGzCdtOLeSejk76K6mymM1jcnkGn3zQqkjKdm+yoPJav4qg4ng==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a5b:142:0:b0:6c4:8a9:e4d2 with SMTP id
 c2-20020a5b0142000000b006c408a9e4d2mr372993ybp.164.1667603568127; Fri, 04 Nov
 2022 16:12:48 -0700 (PDT)
Date:   Fri,  4 Nov 2022 23:12:35 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104231235.348958-1-cmllamas@google.com>
Subject: [PATCH] binder: validate alloc->mm in ->mmap() handler
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
dereference") binder caches a pointer to the current->mm during open().
This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
it also opens the door for a process to update its mm after the open(),
(e.g. via execve) making the cached alloc->mm pointer invalid.

Things get worse when the process continues to mmap() a vma. From this
point forward, binder will attempt to find this vma using an obsolete
alloc->mm reference. Such as in binder_update_page_range(), where the
wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
insert new pages into it.

To avoid this issue fail the ->mmap() callback if we detect a mismatch
between the vma->vm_mm and the original alloc->mm pointer. This prevents
alloc->vm_addr from getting set, so that any subsequent vma_lookup()
calls fail as expected.

Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 1c39cfce32fa..4ad42b0f75cd 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -739,6 +739,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	const char *failure_string;
 	struct binder_buffer *buffer;
 
+	if (unlikely(vma->vm_mm != alloc->mm)) {
+		ret = -EINVAL;
+		failure_string = "invalid vma->vm_mm";
+		goto err_invalid_mm;
+	}
+
 	mutex_lock(&binder_alloc_mmap_lock);
 	if (alloc->buffer_size) {
 		ret = -EBUSY;
@@ -785,6 +791,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
+err_invalid_mm:
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 			   "%s: %d %lx-%lx %s failed %d\n", __func__,
 			   alloc->pid, vma->vm_start, vma->vm_end,
-- 
2.38.1.431.g37b22c650d-goog

