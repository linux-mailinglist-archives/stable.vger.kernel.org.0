Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDC51472D
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358019AbiD2Krd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357957AbiD2Kqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C97BC8BFA;
        Fri, 29 Apr 2022 03:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D87A0B83451;
        Fri, 29 Apr 2022 10:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B5C385A4;
        Fri, 29 Apr 2022 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228972;
        bh=JBM7TEKp7jX5Ll6RGCQ6sUtSgSG6dnk4IbVRKCZ0Qv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql9jM7WD/JEaDF7bej61KXAgT7us5p8Xrms0i+AgUdTQo0Ob0hd1xwQqy9cM/335g
         zIGfnoIaon/OHb4t2IAe+XHUrQgb/R2ofe4NZgguoIuk31fw8rN1tmm4gsvRxTrWCc
         D8npdVSoPUQWWNNcMgJh6iX1TU+hY3lwCOViW0EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 17/33] iov_iter: Introduce fault_in_iov_iter_writeable
Date:   Fri, 29 Apr 2022 12:42:04 +0200
Message-Id: <20220429104052.840367250@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit cdd591fc86e38ad3899196066219fbbd845f3162 upstream

Introduce a new fault_in_iov_iter_writeable helper for safely faulting
in an iterator for writing.  Uses get_user_pages() to fault in the pages
without actually writing to them, which would be destructive.

We'll use fault_in_iov_iter_writeable in gfs2 once we've determined that
the iterator passed to .read_iter isn't in memory.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pagemap.h |    1 
 include/linux/uio.h     |    1 
 lib/iov_iter.c          |   39 +++++++++++++++++++++++++++++
 mm/gup.c                |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -736,6 +736,7 @@ extern void add_page_wait_queue(struct p
  * Fault in userspace address range.
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
 size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -134,6 +134,7 @@ size_t copy_page_from_iter_atomic(struct
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -468,6 +468,45 @@ size_t fault_in_iov_iter_readable(const
 }
 EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
+/*
+ * fault_in_iov_iter_writeable - fault in iov iterator for writing
+ * @i: iterator
+ * @size: maximum length
+ *
+ * Faults in the iterator using get_user_pages(), i.e., without triggering
+ * hardware page faults.  This is primarily useful when we already know that
+ * some or all of the pages in @i aren't in memory.
+ *
+ * Returns the number of bytes not faulted in, like copy_to_user() and
+ * copy_from_user().
+ *
+ * Always returns 0 for non-user-space iterators.
+ */
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t size)
+{
+	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
+		const struct iovec *p;
+		size_t skip;
+
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
+
+			if (unlikely(!len))
+				continue;
+			ret = fault_in_safe_writeable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
+		}
+		return count + size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_iov_iter_writeable);
+
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count)
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1716,6 +1716,69 @@ out:
 }
 EXPORT_SYMBOL(fault_in_writeable);
 
+/*
+ * fault_in_safe_writeable - fault in an address range for writing
+ * @uaddr: start of address range
+ * @size: length of address range
+ *
+ * Faults in an address range using get_user_pages, i.e., without triggering
+ * hardware page faults.  This is primarily useful when we already know that
+ * some or all of the pages in the address range aren't in memory.
+ *
+ * Other than fault_in_writeable(), this function is non-destructive.
+ *
+ * Note that we don't pin or otherwise hold the pages referenced that we fault
+ * in.  There's no guarantee that they'll stay in memory for any duration of
+ * time.
+ *
+ * Returns the number of bytes not faulted in, like copy_to_user() and
+ * copy_from_user().
+ */
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
+{
+	unsigned long start = (unsigned long)untagged_addr(uaddr);
+	unsigned long end, nstart, nend;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	int locked = 0;
+
+	nstart = start & PAGE_MASK;
+	end = PAGE_ALIGN(start + size);
+	if (end < nstart)
+		end = 0;
+	for (; nstart != end; nstart = nend) {
+		unsigned long nr_pages;
+		long ret;
+
+		if (!locked) {
+			locked = 1;
+			mmap_read_lock(mm);
+			vma = find_vma(mm, nstart);
+		} else if (nstart >= vma->vm_end)
+			vma = vma->vm_next;
+		if (!vma || vma->vm_start >= end)
+			break;
+		nend = end ? min(end, vma->vm_end) : vma->vm_end;
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		nr_pages = (nend - nstart) / PAGE_SIZE;
+		ret = __get_user_pages_locked(mm, nstart, nr_pages,
+					      NULL, NULL, &locked,
+					      FOLL_TOUCH | FOLL_WRITE);
+		if (ret <= 0)
+			break;
+		nend = nstart + ret * PAGE_SIZE;
+	}
+	if (locked)
+		mmap_read_unlock(mm);
+	if (nstart == end)
+		return 0;
+	return size - min_t(size_t, nstart - start, size);
+}
+EXPORT_SYMBOL(fault_in_safe_writeable);
+
 /**
  * fault_in_readable - fault in userspace address range for reading
  * @uaddr: start of user address range


