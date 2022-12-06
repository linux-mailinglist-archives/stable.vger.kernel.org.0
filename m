Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F963643B98
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiLFDA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 22:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbiLFDAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 22:00:21 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549E425287
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:00:18 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id q71so12192413pgq.8
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 19:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmfOuiJUmKizUaJwSZrGzGG944f1sKnzf3AucOctnww=;
        b=bbkxpKLIbL6w4rOjoNuge1ld6X+QfZ78+wA2zsHn+GNNSpVEyOQV211KsqAjFWUzxK
         vn8fFKRB6X8PpeVd4Du6N0HdVSV5yeVK0/9IdbXjWW2SPI7CveYfQAT0mhoLhnh755jz
         AI5HIDpQZfdS0a5EBP79evJ88SR3GvCDc3t64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmfOuiJUmKizUaJwSZrGzGG944f1sKnzf3AucOctnww=;
        b=OHLqbfEeIef3WyMfE6lmT7sdmX8W6Lhi+Lc0YCmmcR1l3ZWaAV17L1s2yRTEOcUB09
         Amy8P2lOt4t++qhoBKxfYalQWvII2nAjgxObZNSi6xYfX3d9Q53IKQojPiu5iKkikhUB
         izPd5jG9mpfPnTiOEiiXQgnzHtLNzsOS2J6BqDifn0HubZnNLsr2OQLgUaltM6RmN+0a
         Roi+qN/ysZSypT3BGDD66B4fuHU5R/dKAMZolc+PP4VexGnraD8dWnPZQMfSHZ8VxqDQ
         Pyfe+6ttPA9dGZLjd1J06eDDXNPa8elKn9qnYd7Wvke58Lmd1S0kBB4f1OaBJj3O9XOB
         e56g==
X-Gm-Message-State: ANoB5pklpPVW/yuxWp7CoUthOd2Qk3zldkhRXxIM0Cpg7JptJsrjB6LW
        mDd9OPZP1ATW0eaDFAi+2LnQww==
X-Google-Smtp-Source: AA0mqf7b65rmfPdUpwh5yAPL69AfhS8aUO27Jqo792Am1iZ6r9DRegVBV7UvqVHhOiV6u8NTy43tOQ==
X-Received: by 2002:a62:54c2:0:b0:56b:fb4f:3d7c with SMTP id i185-20020a6254c2000000b0056bfb4f3d7cmr89652229pfb.54.1670295617795;
        Mon, 05 Dec 2022 19:00:17 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:1133:9a88:d416:4bf])
        by smtp.gmail.com with ESMTPSA id nn6-20020a17090b38c600b00219f8eb271fsm362196pjb.5.2022.12.05.19.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 19:00:17 -0800 (PST)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>,
        security <security@kernel.org>,
        Project Zero Comms <project-zero-comms@google.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, senozhatsky@chromium.org,
        m.szyprowski@samsung.com, Tomasz Figa <tfiga@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails
Date:   Tue,  6 Dec 2022 12:00:07 +0900
Message-Id: <20221206030011.3197775-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
In-Reply-To: <Y42lTeWRPiJ4aRu2@kroah.com>
References: <Y42lTeWRPiJ4aRu2@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[commit 6647e76ab623b2b3fb2efe03a86e9c9046c52c33 upstream]

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
CC: stable@vger.kernel.org # 4.9
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/frame_vector.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index d73eed0443f6..aa5526e62c5e 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -36,7 +36,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int ret = 0;
-	int err;
 	int locked;
 
 	if (nr_frames == 0)
@@ -71,32 +70,14 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		vec->is_pfns = false;
 		ret = get_user_pages_locked(start, nr_frames,
 			gup_flags, (struct page **)(vec->ptrs), &locked);
-		goto out;
+		if (likely(ret > 0))
+			goto out;
 	}
 
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret == 0)
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/*
-		 * We stop if we have enough pages or if VMA doesn't completely
-		 * cover the tail page.
-		 */
-		if (ret >= nr_frames || start < vma->vm_end)
-			break;
-		vma = find_vma_intersection(mm, start, start + 1);
-	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+	/* This used to (racily) return non-refcounted pfns. Let people know */
+	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
+	vec->nr_frames = 0;
+
 out:
 	if (locked)
 		up_read(&mm->mmap_sem);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

