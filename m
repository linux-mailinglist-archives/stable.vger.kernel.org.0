Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377AC37A81C
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhEKNuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231735AbhEKNu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 09:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620740962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xlYUYivVwZu0HgRsx1CoZu2G2/J6YkrE3+YrJXbAxyc=;
        b=AOdQ+spCiP6XL2Vja+lfMNS7LlP8O/8e6XAOWpP9EfqaJtjgv4Rq5djy4EzG7LpzXdOyfY
        PYKvGTjANiv1femkQVEjDB0KbgVP+HSulCv8KX0/cja1DKafeCJB+F3d5D1FWZ4v9phHNj
        xEJFzPJOQ7I2jbjPBBlqURQvMmn28XQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-UUg13M_NN5mekbMl_cdiCQ-1; Tue, 11 May 2021 09:49:20 -0400
X-MC-Unique: UUg13M_NN5mekbMl_cdiCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C081097FF4;
        Tue, 11 May 2021 13:49:11 +0000 (UTC)
Received: from max.com (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 485EE5C1A3;
        Tue, 11 May 2021 13:49:10 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] gfs2: Fix mmap + page fault deadlock
Date:   Tue, 11 May 2021 15:49:08 +0200
Message-Id: <20210511134908.1225322-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 20f829999c38 has moved the inode glock taking from gfs2_readpage and
gfs2_readahead into gfs2_file_read_iter and gfs2_fault.  In gfs2_fault, we
didn't take into account that page faults can occur while holding the inode
glock, for example,

  gfs2_file_read_iter
    [grabs inode glock]
    generic_file_read_iter
      filemap_read
        copy_page_to_iter
          gfs2_fault
            [tries to grab inode glock again]

  gfs2_file_write_iter
    iomap_file_buffered_write
      iomap_apply
        iomap_ops->iomap_begin
          [grabs inode glock]
        iomap_write_actor
          iov_iter_fault_in_readable
            gfs2_fault
              [tries to grab inode glock again]

Fix that by checking if we're holding the inode glock already.

Reported-by: Jan Kara <jack@suse.cz>
Fixes: 20f829999c38 ("gfs2: Rework read and page fault locking")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/file.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 3ebc9af39a04..658fed79d65a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -538,18 +538,22 @@ static vm_fault_t gfs2_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gfs2_inode *ip = GFS2_I(inode);
+	bool recursive = gfs2_glock_is_locked_by_me(ip->i_gl);
 	struct gfs2_holder gh;
 	vm_fault_t ret;
 	int err;
 
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	err = gfs2_glock_nq(&gh);
-	if (err) {
-		ret = block_page_mkwrite_return(err);
-		goto out_uninit;
+	if (likely(!recursive)) {
+		err = gfs2_glock_nq(&gh);
+		if (err) {
+			ret = block_page_mkwrite_return(err);
+			goto out_uninit;
+		}
 	}
 	ret = filemap_fault(vmf);
-	gfs2_glock_dq(&gh);
+	if (likely(!recursive))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	return ret;
-- 
2.26.3

