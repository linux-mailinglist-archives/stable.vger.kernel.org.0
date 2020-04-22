Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6911B3FAE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgDVKju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgDVKVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B312076B;
        Wed, 22 Apr 2020 10:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550876;
        bh=SN/5j2Okkn1eVrwRTaxVF3OLAi+cty+PbHxBtT3BDG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWNejAhca18lcqwuOGeh4ZCU26fk49NsQE8Gtz+2v3BbFzyM+HzYKEJXmk5kmH8dj
         McQEWU9gDl2FxjDG17hQUXKtfZbTEXBNYIwS5aCwQZYnuMVsR7YUr3Ci2Oms0/OHRZ
         nWPPVGnNj7/zOklXjYW+ujpF3ZnpwFqN1/xGSRWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.6 011/166] bpf: Prevent re-mmap()ing BPF map as writable for initially r/o mapping
Date:   Wed, 22 Apr 2020 11:55:38 +0200
Message-Id: <20200422095049.430771557@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 1f6cb19be2e231fe092f40decb71f066eba090d7 upstream.

VM_MAYWRITE flag during initial memory mapping determines if already mmap()'ed
pages can be later remapped as writable ones through mprotect() call. To
prevent user application to rewrite contents of memory-mapped as read-only and
subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initially
read-only mapping.

Alternatively, we could treat any memory-mapping on unfrozen map as writable
and bump writecnt instead. But there is little legitimate reason to map
BPF map as read-only and then re-mmap() it as writable through mprotect(),
instead of just mmap()'ing it as read/write from the very beginning.

Also, at the suggestion of Jann Horn, drop unnecessary refcounting in mmap
operations. We can just rely on VMA holding reference to BPF map's file
properly.

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/bpf/20200410202613.3679837-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/syscall.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -592,9 +592,7 @@ static void bpf_map_mmap_open(struct vm_
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 
-	bpf_map_inc_with_uref(map);
-
-	if (vma->vm_flags & VM_WRITE) {
+	if (vma->vm_flags & VM_MAYWRITE) {
 		mutex_lock(&map->freeze_mutex);
 		map->writecnt++;
 		mutex_unlock(&map->freeze_mutex);
@@ -606,13 +604,11 @@ static void bpf_map_mmap_close(struct vm
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 
-	if (vma->vm_flags & VM_WRITE) {
+	if (vma->vm_flags & VM_MAYWRITE) {
 		mutex_lock(&map->freeze_mutex);
 		map->writecnt--;
 		mutex_unlock(&map->freeze_mutex);
 	}
-
-	bpf_map_put_with_uref(map);
 }
 
 static const struct vm_operations_struct bpf_map_default_vmops = {
@@ -641,14 +637,16 @@ static int bpf_map_mmap(struct file *fil
 	/* set default open/close callbacks */
 	vma->vm_ops = &bpf_map_default_vmops;
 	vma->vm_private_data = map;
+	vma->vm_flags &= ~VM_MAYEXEC;
+	if (!(vma->vm_flags & VM_WRITE))
+		/* disallow re-mapping with PROT_WRITE */
+		vma->vm_flags &= ~VM_MAYWRITE;
 
 	err = map->ops->map_mmap(map, vma);
 	if (err)
 		goto out;
 
-	bpf_map_inc_with_uref(map);
-
-	if (vma->vm_flags & VM_WRITE)
+	if (vma->vm_flags & VM_MAYWRITE)
 		map->writecnt++;
 out:
 	mutex_unlock(&map->freeze_mutex);


