Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A237CEE4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbhELRHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244739AbhELQvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC6661C85;
        Wed, 12 May 2021 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836258;
        bh=pbxj6mVkDRr5GwQnnzNiBrvsiYzhgsNJMOp0UGum6LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amgyqtQzX+4opwmkX3pnYrIT0Uo/4G+2P1tR6xwS+Z5Ag+znRUSvYmUd9Mh4BH+1E
         L+SkQGTfQBBKPOM0t+wU+/jnzDntgcM03WO9JBhSYVtzrtvtAEfLEUnrFlIEf4feeE
         abEHScsiO/TPEZQSVhPZ2FZ0k2dB+8UZ9h0/LIbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.12 673/677] bpf: Prevent writable memory-mapping of read-only ringbuf pages
Date:   Wed, 12 May 2021 16:51:59 +0200
Message-Id: <20210512144859.717775673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

commit 04ea3086c4d73da7009de1e84962a904139af219 upstream.

Only the very first page of BPF ringbuf that contains consumer position
counter is supposed to be mapped as writeable by user-space. Producer
position is read-only and can be modified only by the kernel code. BPF ringbuf
data pages are read-only as well and are not meant to be modified by
user-code to maintain integrity of per-record headers.

This patch allows to map only consumer position page as writeable and
everything else is restricted to be read-only. remap_vmalloc_range()
internally adds VM_DONTEXPAND, so all the established memory mappings can't be
extended, which prevents any future violations through mremap()'ing.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: Ryota Shiga (Flatt Security)
Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/ringbuf.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -221,25 +221,20 @@ static int ringbuf_map_get_next_key(stru
 	return -ENOTSUPP;
 }
 
-static size_t bpf_ringbuf_mmap_page_cnt(const struct bpf_ringbuf *rb)
-{
-	size_t data_pages = (rb->mask + 1) >> PAGE_SHIFT;
-
-	/* consumer page + producer page + 2 x data pages */
-	return RINGBUF_POS_PAGES + 2 * data_pages;
-}
-
 static int ringbuf_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 {
 	struct bpf_ringbuf_map *rb_map;
-	size_t mmap_sz;
 
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
-	mmap_sz = bpf_ringbuf_mmap_page_cnt(rb_map->rb) << PAGE_SHIFT;
-
-	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) > mmap_sz)
-		return -EINVAL;
 
+	if (vma->vm_flags & VM_WRITE) {
+		/* allow writable mapping for the consumer_pos only */
+		if (vma->vm_pgoff != 0 || vma->vm_end - vma->vm_start != PAGE_SIZE)
+			return -EPERM;
+	} else {
+		vma->vm_flags &= ~VM_MAYWRITE;
+	}
+	/* remap_vmalloc_range() checks size and offset constraints */
 	return remap_vmalloc_range(vma, rb_map->rb,
 				   vma->vm_pgoff + RINGBUF_PGOFF);
 }


