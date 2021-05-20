Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3038AE25
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhETM2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:28:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232818AbhETM1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621513548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwkYYr9VKakeJ7pnq4AzoFfWPLnb5O3KiOprpBwKwMo=;
        b=PxCsqZ3H8OA+SJoX4f4CSiwzYptIZh27CpgZD00n50PwBHXLwi1/QRS0HZKgIlJz+1pl4S
        qDDC619VvSP9YjncZEqmNZqBpSDA3MGI4CEAyYXDRBokUfOIiIyWCrhOLHnjyjsmoFMmfO
        SPALmYvSHME8N6HWMoXzRaJjNyNKROo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-sj5KzOTbMoi146jFiq3AbA-1; Thu, 20 May 2021 08:25:46 -0400
X-MC-Unique: sj5KzOTbMoi146jFiq3AbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 865091A8A61;
        Thu, 20 May 2021 12:25:45 +0000 (UTC)
Received: from max.com (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8AD160C04;
        Thu, 20 May 2021 12:25:43 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>, cluster-devel@redhat.com
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/6] gfs2: Fix mmap + page fault deadlocks (part 1)
Date:   Thu, 20 May 2021 14:25:31 +0200
Message-Id: <20210520122536.1596602-2-agruenba@redhat.com>
In-Reply-To: <20210520122536.1596602-1-agruenba@redhat.com>
References: <20210520122536.1596602-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the buffer passed to a read or write system call is memory mapped to the
same file, a page fault can occur in gfs2_fault.  In that case, the task will
already be holding the inode glock, and trying to take it again will result in
a BUG in add_to_queue().  Fix that by recognizing the self-recursion case and
either skipping the lock taking (when the glock is held in a compatible way),
or fail the operation.

Likewise, a request to un-share a copy-on-write page can *probably* happen in
similar situations, so treat the locking in gfs2_page_mkwrite in the same way.

A future patch will handle this case more gracefully, along with addressing
more complex deadlock scenarios.

Reported-by: Jan Kara <jack@suse.cz>
Fixes: 20f829999c38 ("gfs2: Rework read and page fault locking")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/file.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 6d77743f11a4..7d88abb4629b 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -423,6 +423,7 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder *outer_gh = gfs2_glock_is_locked_by_me(ip->i_gl);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_alloc_parms ap = { .aflags = 0, };
 	u64 offset = page_offset(page);
@@ -436,10 +437,18 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vmf)
 	sb_start_pagefault(inode->i_sb);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	err = gfs2_glock_nq(&gh);
-	if (err) {
-		ret = block_page_mkwrite_return(err);
-		goto out_uninit;
+	if (likely(!outer_gh)) {
+		err = gfs2_glock_nq(&gh);
+		if (err) {
+			ret = block_page_mkwrite_return(err);
+			goto out_uninit;
+		}
+	} else {
+		if (!gfs2_holder_is_compatible(outer_gh, LM_ST_EXCLUSIVE)) {
+			/* We could try to upgrade outer_gh here. */
+			ret = VM_FAULT_SIGBUS;
+			goto out_uninit;
+		}
 	}
 
 	/* Check page index against inode size */
@@ -540,7 +549,8 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vmf)
 out_quota_unlock:
 	gfs2_quota_unlock(ip);
 out_unlock:
-	gfs2_glock_dq(&gh);
+	if (likely(!outer_gh))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	if (ret == VM_FAULT_LOCKED) {
@@ -555,6 +565,7 @@ static vm_fault_t gfs2_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder *outer_gh = gfs2_glock_is_locked_by_me(ip->i_gl);
 	struct gfs2_holder gh;
 	vm_fault_t ret;
 	u16 state;
@@ -562,13 +573,22 @@ static vm_fault_t gfs2_fault(struct vm_fault *vmf)
 
 	state = (vmf->flags & FAULT_FLAG_WRITE) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
 	gfs2_holder_init(ip->i_gl, state, 0, &gh);
-	err = gfs2_glock_nq(&gh);
-	if (err) {
-		ret = block_page_mkwrite_return(err);
-		goto out_uninit;
+	if (likely(!outer_gh)) {
+		err = gfs2_glock_nq(&gh);
+		if (err) {
+			ret = block_page_mkwrite_return(err);
+			goto out_uninit;
+		}
+	} else {
+		if (!gfs2_holder_is_compatible(outer_gh, state)) {
+			/* We could try to upgrade outer_gh here. */
+			ret = VM_FAULT_SIGBUS;
+			goto out_uninit;
+		}
 	}
 	ret = filemap_fault(vmf);
-	gfs2_glock_dq(&gh);
+	if (likely(!outer_gh))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	return ret;
-- 
2.26.3

