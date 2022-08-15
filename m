Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7120D59458A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347971AbiHOWU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350812AbiHOWSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267A241D0B;
        Mon, 15 Aug 2022 12:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAB88B80EA9;
        Mon, 15 Aug 2022 19:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFE7C433D6;
        Mon, 15 Aug 2022 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592539;
        bh=LI9xyrlxXoxri9GLybfnF+zXTFS4hqMK+A3lwjDVl7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoKaxBbYYi5TgjXdNAAnkh+58Vn4o9pe7q9y46M7S3KLL74dRE79nAzbUUR9n+4RW
         DY9q7GgHpgsvuQvA8JSWOmmn6Yvszx90miv4TqfDVKExEf6wrA+1EPiVcFOIh/bgFh
         lRLOFqUpZJtiYJXMja3WtQdhjx+0n3A5FNdh6534=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+58b51ac2b04e388ab7b0@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Martijn Coenen <maco@android.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Todd Kjos <tkjos@android.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0805/1095] android: binder: stop saving a pointer to the VMA
Date:   Mon, 15 Aug 2022 20:03:24 +0200
Message-Id: <20220815180502.571614542@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam R. Howlett <Liam.Howlett@oracle.com>

[ Upstream commit a43cfc87caaf46710c8027a8c23b8a55f1078f19 ]

Do not record a pointer to a VMA outside of the mmap_lock for later use.
This is unsafe and there are a number of failure paths *after* the
recorded VMA pointer may be freed during setup.  There is no callback to
the driver to clear the saved pointer from generic mm code.  Furthermore,
the VMA pointer may become stale if any number of VMA operations end up
freeing the VMA so saving it was fragile to being with.

Instead, change the binder_alloc struct to record the start address of the
VMA and use vma_lookup() to get the vma when needed.  Add lockdep
mmap_lock checks on updates to the vma pointer to ensure the lock is held
and depend on that lock for synchronization of readers and writers - which
was already the case anyways, so the smp_wmb()/smp_rmb() was not
necessary.

[akpm@linux-foundation.org: fix drivers/android/binder_alloc_selftest.c]
Link: https://lkml.kernel.org/r/20220621140212.vpkio64idahetbyf@revolver
Fixes: da1b9564e85b ("android: binder: fix the race mmap and alloc_new_buf_locked")
Reported-by: syzbot+58b51ac2b04e388ab7b0@syzkaller.appspotmail.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder_alloc.c          | 30 ++++++++++++-------------
 drivers/android/binder_alloc.h          |  2 +-
 drivers/android/binder_alloc_selftest.c |  2 +-
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 2ac1008a5f39..a93a7d2a8caf 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -213,7 +213,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 
 	if (mm) {
 		mmap_read_lock(mm);
-		vma = alloc->vma;
+		vma = vma_lookup(mm, alloc->vma_addr);
 	}
 
 	if (!vma && need_mm) {
@@ -313,16 +313,15 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 		struct vm_area_struct *vma)
 {
-	if (vma)
+	unsigned long vm_start = 0;
+
+	if (vma) {
+		vm_start = vma->vm_start;
 		alloc->vma_vm_mm = vma->vm_mm;
-	/*
-	 * If we see alloc->vma is not NULL, buffer data structures set up
-	 * completely. Look at smp_rmb side binder_alloc_get_vma.
-	 * We also want to guarantee new alloc->vma_vm_mm is always visible
-	 * if alloc->vma is set.
-	 */
-	smp_wmb();
-	alloc->vma = vma;
+	}
+
+	mmap_assert_write_locked(alloc->vma_vm_mm);
+	alloc->vma_addr = vm_start;
 }
 
 static inline struct vm_area_struct *binder_alloc_get_vma(
@@ -330,11 +329,9 @@ static inline struct vm_area_struct *binder_alloc_get_vma(
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (alloc->vma) {
-		/* Look at description in binder_alloc_set_vma */
-		smp_rmb();
-		vma = alloc->vma;
-	}
+	if (alloc->vma_addr)
+		vma = vma_lookup(alloc->vma_vm_mm, alloc->vma_addr);
+
 	return vma;
 }
 
@@ -817,7 +814,8 @@ void binder_alloc_deferred_release(struct binder_alloc *alloc)
 
 	buffers = 0;
 	mutex_lock(&alloc->mutex);
-	BUG_ON(alloc->vma);
+	BUG_ON(alloc->vma_addr &&
+	       vma_lookup(alloc->vma_vm_mm, alloc->vma_addr));
 
 	while ((n = rb_first(&alloc->allocated_buffers))) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
diff --git a/drivers/android/binder_alloc.h b/drivers/android/binder_alloc.h
index 7dea57a84c79..1e4fd37af5e0 100644
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -100,7 +100,7 @@ struct binder_lru_page {
  */
 struct binder_alloc {
 	struct mutex mutex;
-	struct vm_area_struct *vma;
+	unsigned long vma_addr;
 	struct mm_struct *vma_vm_mm;
 	void __user *buffer;
 	struct list_head buffers;
diff --git a/drivers/android/binder_alloc_selftest.c b/drivers/android/binder_alloc_selftest.c
index c2b323bc3b3a..43a881073a42 100644
--- a/drivers/android/binder_alloc_selftest.c
+++ b/drivers/android/binder_alloc_selftest.c
@@ -287,7 +287,7 @@ void binder_selftest_alloc(struct binder_alloc *alloc)
 	if (!binder_selftest_run)
 		return;
 	mutex_lock(&binder_selftest_lock);
-	if (!binder_selftest_run || !alloc->vma)
+	if (!binder_selftest_run || !alloc->vma_addr)
 		goto done;
 	pr_info("STARTED\n");
 	binder_selftest_alloc_offset(alloc, end_offset, 0);
-- 
2.35.1



