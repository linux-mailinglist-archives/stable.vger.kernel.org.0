Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F3B6432DB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiLETbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiLETas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:30:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A4F2B634
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EAD96131F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4A3C433C1;
        Mon,  5 Dec 2022 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268391;
        bh=4JnpkyKNGE7/PaXvHRIhmipq9yeFEnLI46R50CznMBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USV4Aw9welHqkqN8cNLN0WJVzU/ZgZxgf7TyLrYctttxPYEIByGqIgU2udc9/NRs/
         PDaLW4ilm/pGmMdP9dQcOp+9g59aw28xiRv5EZ2wTmDoanLbNTSk62yJedN26JaXaT
         yRf6hS0bB10IckUOTGlb8ZfIsb+vV7E25iNNl62M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Seth Jenkins <sethjenkins@google.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.0 084/124] v4l2: dont fall back to follow_pfn() if pin_user_pages_fast() fails
Date:   Mon,  5 Dec 2022 20:09:50 +0100
Message-Id: <20221205190810.804311274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 6647e76ab623b2b3fb2efe03a86e9c9046c52c33 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/frame_vector.c |   68 ++++----------------------
 1 file changed, 12 insertions(+), 56 deletions(-)

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
@@ -52,57 +48,17 @@ int get_vaddr_frames(unsigned long start
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
 


