Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70138261A93
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIHSgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731345AbgIHQJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5966A2416F;
        Tue,  8 Sep 2020 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580157;
        bh=BrSj8b/9ETBL3mpN9bmORNmq9DNsTUW8IFX8COqRVdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6h8C39Z/BhBcKvnIiWJhKsnkSxKRjED0ygg1zoNsDjaZgh+98LPZedMWQ3raF0lx
         l9/2k2mbtbXfXVn5VB0XswIRc4aQihV5pav+V7lqx7pXpUqyuk6OxO1f7MG0Q7AOwd
         YS3x09Y/UJS0f/w4re8ZPoKnKTyj4n2CfnCOX77A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 53/88] xfs: dont update mtime on COW faults
Date:   Tue,  8 Sep 2020 17:25:54 +0200
Message-Id: <20200908152223.776357408@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit b17164e258e3888d376a7434415013175d637377 upstream.

When running in a dax mode, if the user maps a page with MAP_PRIVATE and
PROT_WRITE, the xfs filesystem would incorrectly update ctime and mtime
when the user hits a COW fault.

This breaks building of the Linux kernel.  How to reproduce:

 1. extract the Linux kernel tree on dax-mounted xfs filesystem
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
 fs/xfs/xfs_file.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1095,6 +1095,14 @@ __xfs_filemap_fault(
 	return ret;
 }
 
+static inline bool
+xfs_is_write_fault(
+	struct vm_fault		*vmf)
+{
+	return (vmf->flags & FAULT_FLAG_WRITE) &&
+	       (vmf->vma->vm_flags & VM_SHARED);
+}
+
 static vm_fault_t
 xfs_filemap_fault(
 	struct vm_fault		*vmf)
@@ -1102,7 +1110,7 @@ xfs_filemap_fault(
 	/* DAX can shortcut the normal fault path on write faults! */
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE,
 			IS_DAX(file_inode(vmf->vma->vm_file)) &&
-			(vmf->flags & FAULT_FLAG_WRITE));
+			xfs_is_write_fault(vmf));
 }
 
 static vm_fault_t
@@ -1115,7 +1123,7 @@ xfs_filemap_huge_fault(
 
 	/* DAX can shortcut the normal fault path on write faults! */
 	return __xfs_filemap_fault(vmf, pe_size,
-			(vmf->flags & FAULT_FLAG_WRITE));
+			xfs_is_write_fault(vmf));
 }
 
 static vm_fault_t


