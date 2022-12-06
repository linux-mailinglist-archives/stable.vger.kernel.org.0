Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E997644053
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiLFJvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiLFJuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EF613F2A;
        Tue,  6 Dec 2022 01:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3617615FC;
        Tue,  6 Dec 2022 09:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5281DC433C1;
        Tue,  6 Dec 2022 09:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320194;
        bh=rz5AzYbQWf+iErrx+8viLCPkrqGF9zeD0tYEm5uP7vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i98ADEJkBrR1yz0hsvgFbtYQBbCQC5fb5hmrrYmvztdJKtDMlj7JPs1ntRNw1W1r7
         2mma3PtJ5x8GL/hIWdLGDbWad6olXwtCCZdKzqJM9eeS/C8Ho54Xf2+oRQWyb0Xm1X
         aSovKByTKEl4V0fbccCQQXhHF3Oz+IicqH9XW9bapzu2K1tcf3SOTyJxm4uxuyqlg5
         qiEN0sasLUo0TNma6Y4ZXKJcfjk7GcF0dI4plCQHyTYD5pYDTIWlr7+Kmv6kpjuITQ
         bHIY1tKSFR+SKxFsAfEP+sJpdlwBDDPViIqmHxSq4Aj3uOum8vr90Hqgtzlv7Y5Mc7
         3cLf9RO/U/9XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, tfiga@chromium.org,
        m.szyprowski@samsung.com, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 13/13] v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails
Date:   Tue,  6 Dec 2022 04:49:16 -0500
Message-Id: <20221206094916.987259-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094916.987259-1-sashal@kernel.org>
References: <20221206094916.987259-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6647e76ab623b2b3fb2efe03a86e9c9046c52c33 ]

The V4L2_MEMORY_USERPTR interface is long deprecated and shouldn't be
used (and is discouraged for any modern v4l drivers).  And Seth Jenkins
points out that the fallback to VM_PFNMAP/VM_IO is fundamentally racy
and dangerous.

Note that it's not even a case that should trigger, since any normal
user pointer logic ends up just using the pin_user_pages_fast() call
that does the proper page reference counting.  That's not the problem
case, only if you try to use special device mappings do you have any
issues.

Normally I'd just remove this during the merge window, but since Seth
pointed out the problem cases, we really want to know as soon as
possible if there are actually any users of this odd special case of a
legacy interface.  Neither Hans nor Mauro seem to think that such
mis-uses of the old legacy interface should exist.  As Mauro says:

 "See, V4L2 has actually 4 streaming APIs:
        - Kernel-allocated mmap (usually referred simply as just mmap);
        - USERPTR mmap;
        - read();
        - dmabuf;

  The USERPTR is one of the oldest way to use it, coming from V4L
  version 1 times, and by far the least used one"

And Hans chimed in on the USERPTR interface:

 "To be honest, I wouldn't mind if it goes away completely, but that's a
  bit of a pipe dream right now"

but while removing this legacy interface entirely may be a pipe dream we
can at least try to remove the unlikely (and actively broken) case of
using special device mappings for USERPTR accesses.

This replaces it with a WARN_ONCE() that we can remove once we've
hopefully confirmed that no actual users exist.

NOTE! Longer term, this means that a 'struct frame_vector' only ever
contains proper page pointers, and all the games we have with converting
them to pages can go away (grep for 'frame_vector_to_pages()' and the
uses of 'vec->is_pfns').  But this is just the first step, to verify
that this code really is all dead, and do so as quickly as possible.

Reported-by: Seth Jenkins <sethjenkins@google.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/frame_vector.c | 68 ++++---------------
 1 file changed, 12 insertions(+), 56 deletions(-)

diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
index 542dde9d2609..144027035892 100644
--- a/drivers/media/common/videobuf2/frame_vector.c
+++ b/drivers/media/common/videobuf2/frame_vector.c
@@ -35,11 +35,7 @@
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		     struct frame_vector *vec)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	int ret_pin_user_pages_fast = 0;
-	int ret = 0;
-	int err;
+	int ret;
 
 	if (nr_frames == 0)
 		return 0;
@@ -52,57 +48,17 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	ret = pin_user_pages_fast(start, nr_frames,
 				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
 				  (struct page **)(vec->ptrs));
-	if (ret > 0) {
-		vec->got_ref = true;
-		vec->is_pfns = false;
-		goto out_unlocked;
-	}
-	ret_pin_user_pages_fast = ret;
-
-	mmap_read_lock(mm);
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	ret = 0;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		vma = vma_lookup(mm, start);
-		if (!vma)
-			break;
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret)
-					goto out;
-				// If follow_pfn() returns -EINVAL, then this
-				// is not an IO mapping or a raw PFN mapping.
-				// In that case, return the original error from
-				// pin_user_pages_fast(). Otherwise this
-				// function would return -EINVAL when
-				// pin_user_pages_fast() returned -ENOMEM,
-				// which makes debugging hard.
-				if (err == -EINVAL && ret_pin_user_pages_fast)
-					ret = ret_pin_user_pages_fast;
-				else
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/* Bail out if VMA doesn't completely cover the tail page. */
-		if (start < vma->vm_end)
-			break;
-	} while (ret < nr_frames);
-out:
-	mmap_read_unlock(mm);
-out_unlocked:
-	if (!ret)
-		ret = -EFAULT;
-	if (ret > 0)
-		vec->nr_frames = ret;
-	return ret;
+	vec->got_ref = true;
+	vec->is_pfns = false;
+	vec->nr_frames = ret;
+
+	if (likely(ret > 0))
+		return ret;
+
+	/* This used to (racily) return non-refcounted pfns. Let people know */
+	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
+	vec->nr_frames = 0;
+	return ret ? ret : -EFAULT;
 }
 EXPORT_SYMBOL(get_vaddr_frames);
 
-- 
2.35.1

