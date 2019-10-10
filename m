Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E640D235D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbfJJIlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388383AbfJJIll (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888812054F;
        Thu, 10 Oct 2019 08:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696901;
        bh=kjBBx1owjHoHOHK+PfnP7vwaB5MJ/Cp+vuwoeSfQum4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYi+1K+i+QfW6NbtVQGi50s5uI5KdhlkmLeyXnvS+NWXyEapPFPmiezEWz7RNjBVB
         +Lrq0+uOVdrrLG7Lo9RwJB3vIgXcMRMn9aNFb1GtSeZp9jJSnV08u8HSYzx++ptKJ/
         hTu1CHJVfccf0cynC/qNqn5ii0BAhcmYcA6IIYs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@zoho.com.cn>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 095/148] 9p: avoid attaching writeback_fid on mmap with type PRIVATE
Date:   Thu, 10 Oct 2019 10:35:56 +0200
Message-Id: <20191010083617.043759883@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@zoho.com.cn>

[ Upstream commit c87a37ebd40b889178664c2c09cc187334146292 ]

Currently on mmap cache policy, we always attach writeback_fid
whether mmap type is SHARED or PRIVATE. However, in the use case
of kata-container which combines 9p(Guest OS) with overlayfs(Host OS),
this behavior will trigger overlayfs' copy-up when excute command
inside container.

Link: http://lkml.kernel.org/r/20190820100325.10313-1-cgxu519@zoho.com.cn
Signed-off-by: Chengguang Xu <cgxu519@zoho.com.cn>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 4cc966a31cb37..fe7f0bd2048e4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -513,6 +513,7 @@ v9fs_mmap_file_mmap(struct file *filp, struct vm_area_struct *vma)
 	v9inode = V9FS_I(inode);
 	mutex_lock(&v9inode->v_mutex);
 	if (!v9inode->writeback_fid &&
+	    (vma->vm_flags & VM_SHARED) &&
 	    (vma->vm_flags & VM_WRITE)) {
 		/*
 		 * clone a fid and add it to writeback_fid
@@ -614,6 +615,8 @@ static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
 			(vma->vm_end - vma->vm_start - 1),
 	};
 
+	if (!(vma->vm_flags & VM_SHARED))
+		return;
 
 	p9_debug(P9_DEBUG_VFS, "9p VMA close, %p, flushing", vma);
 
-- 
2.20.1



