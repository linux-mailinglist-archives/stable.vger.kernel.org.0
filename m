Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A964C2D9
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 04:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiLNDhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 22:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbiLNDhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 22:37:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53972791E
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 19:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670988940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDTRgN4BLYRjIi6g7D7REKB901ral4G3k6EuzHldn1Q=;
        b=fHzIxLeV5+jBgi1oC25TXHi0gLmzLSTdi93W7EItv1sP4zRxdtqFvHlTMoe1xerkFGtWBd
        6Jxu4BP0qVzppLEvdGAYRrI2DSqpf72E/8a9Us616oLrm+//9E7WLngkSJX1XkssYgYc44
        sqchF9gGtWGZTtPjeHhLVzZ9KzbVN6g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Et1anJN0P7irZgzriR91Ww-1; Tue, 13 Dec 2022 22:35:36 -0500
X-MC-Unique: Et1anJN0P7irZgzriR91Ww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42484380673B;
        Wed, 14 Dec 2022 03:35:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D7382166B26;
        Wed, 14 Dec 2022 03:35:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5 2/2] ceph: add ceph specific member support for file_lock
Date:   Wed, 14 Dec 2022 11:35:12 +0800
Message-Id: <20221214033512.659913-3-xiubli@redhat.com>
In-Reply-To: <20221214033512.659913-1-xiubli@redhat.com>
References: <20221214033512.659913-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When ceph releasing the file_lock it will try to get the inode pointer
from the fl->fl_file, which the memory could already be released by
another thread in filp_close(). Because in VFS layer the fl->fl_file
doesn't increase the file's reference counter.

Will switch to use ceph dedicate lock info to track the inode.

And in ceph_fl_release_lock() we should skip all the operations if
the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
inserting it to the inode lock list, which is when copying the lock.

Cc: stable@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>
URL: https://tracker.ceph.com/issues/57986
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/locks.c    | 20 ++++++++++++++++++--
 include/linux/fs.h |  3 +++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index b191426bf880..d31955f710f2 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
+	dst->fl_u.ceph.inode = igrab(inode);
 }
 
+/*
+ * Do not use the 'fl->fl_file' in release function, which
+ * is possibly already released by another thread.
+ */
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct inode *inode = file_inode(fl->fl_file);
-	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct inode *inode = fl->fl_u.ceph.inode;
+	struct ceph_inode_info *ci;
+
+	/*
+	 * If inode is NULL it should be a request file_lock,
+	 * nothing we can do.
+	 */
+	if (!inode)
+		return;
+
+	ci = ceph_inode(inode);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
 		ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
 		spin_unlock(&ci->i_ceph_lock);
 	}
+	fl->fl_u.ceph.inode = NULL;
+	iput(inode);
 }
 
 static const struct file_lock_operations ceph_fl_lock_ops = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7b52fdfb6da0..c92c62f1e964 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1119,6 +1119,9 @@ struct file_lock {
 			int state;		/* state of grant or error if -ve */
 			unsigned int	debug_id;
 		} afs;
+		struct {
+			struct inode *inode;
+		} ceph;
 	} fl_u;
 } __randomize_layout;
 
-- 
2.31.1

