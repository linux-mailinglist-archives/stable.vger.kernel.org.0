Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D453261BD7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbgIHTJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731236AbgIHQFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD75623CD2;
        Tue,  8 Sep 2020 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579971;
        bh=MEmvLFwTluSLMx2cM/SWoItoFmupNuwGFBxSHz1bvcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFpg0S48KOFyCmvo598XHjanPOE/vnsF7ItVcNW0gLX9doliqsfNkGDIebKSbCzs9
         /prhWfmDhjNLnurlIxe0r9qVriGohoeE/H5/YtgCd7ojyf19O7Nx/DXzfZPoUFAq79
         cyf+aNvX4o6/DXQ+G6L4mWjH/a2Jm0XW6yNYE7GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 078/129] ext2: dont update mtime on COW faults
Date:   Tue,  8 Sep 2020 17:25:19 +0200
Message-Id: <20200908152233.596628167@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1ef6ea0efe8e68d0299dad44c39dc6ad9e5d1f39 upstream.

When running in a dax mode, if the user maps a page with MAP_PRIVATE and
PROT_WRITE, the ext2 filesystem would incorrectly update ctime and mtime
when the user hits a COW fault.

This breaks building of the Linux kernel.  How to reproduce:

 1. extract the Linux kernel tree on dax-mounted ext2 filesystem
 2. run make clean
 3. run make -j12
 4. run make -j12

at step 4, make would incorrectly rebuild the whole kernel (although it
was already built in step 3).

The reason for the breakage is that almost all object files depend on
objtool.  When we run objtool, it takes COW page fault on its .data
section, and these faults will incorrectly update the timestamp of the
objtool binary.  The updated timestamp causes make to rebuild the whole
tree.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -93,8 +93,10 @@ static vm_fault_t ext2_dax_fault(struct
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	vm_fault_t ret;
+	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
+		(vmf->vma->vm_flags & VM_SHARED);
 
-	if (vmf->flags & FAULT_FLAG_WRITE) {
+	if (write) {
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vmf->vma->vm_file);
 	}
@@ -103,7 +105,7 @@ static vm_fault_t ext2_dax_fault(struct
 	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, NULL, &ext2_iomap_ops);
 
 	up_read(&ei->dax_sem);
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if (write)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
 }


