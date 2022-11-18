Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E762EBAF
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 03:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbiKRCIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 21:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiKRCH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 21:07:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72219898C5
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 18:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668737219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nmr3tXYC2BQhdEeIC85P8Dx88dykoP9+tJN2ppJbsMQ=;
        b=H0KE6uoHWTxU0hKLmXhWNEodRNHLbEXM43CJdXh3xwMsoL6uea6//p6oaoPuVTcqLYvUL6
        J0H9eE306/JvteXc8enkogiZZly2Z7caFtope0bXaniL7EryvBHrJXgCbAaBgQLxuYXqI9
        VdkRfcyQwUdUr7O9LPizvBjfcHXsgOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-NN580cw-NYiGpmNXvyLozA-1; Thu, 17 Nov 2022 21:06:58 -0500
X-MC-Unique: NN580cw-NYiGpmNXvyLozA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBB8B101A52A;
        Fri, 18 Nov 2022 02:06:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E23FC158CF;
        Fri, 18 Nov 2022 02:06:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/2 v3] ceph: add ceph_lock_info support for file_lock
Date:   Fri, 18 Nov 2022 10:06:42 +0800
Message-Id: <20221118020642.472484-3-xiubli@redhat.com>
In-Reply-To: <20221118020642.472484-1-xiubli@redhat.com>
References: <20221118020642.472484-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/locks.c                 | 20 ++++++++++++++++++--
 include/linux/ceph/ceph_fs_fl.h | 17 +++++++++++++++++
 include/linux/fs.h              |  2 ++
 3 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/ceph/ceph_fs_fl.h

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index b191426bf880..621f38f10a88 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
+	dst->fl_u.ceph_fl.fl_inode = igrab(inode);
 }
 
+/*
+ * Do not use the 'fl->fl_file' in release function, which
+ * is possibly already released by another thread.
+ */
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct inode *inode = file_inode(fl->fl_file);
-	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
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
+	fl->fl_u.ceph_fl.fl_inode = NULL;
+	iput(inode);
 }
 
 static const struct file_lock_operations ceph_fl_lock_ops = {
diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs_fl.h
new file mode 100644
index 000000000000..ad1cf96329f9
--- /dev/null
+++ b/include/linux/ceph/ceph_fs_fl.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ceph_fs_fl.h - Ceph lock info
+ *
+ * LGPL2
+ */
+
+#ifndef CEPH_FS_FL_H
+#define CEPH_FS_FL_H
+
+#include <linux/fs.h>
+
+struct ceph_lock_info {
+	struct inode *fl_inode;
+};
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d6cb42b7e91c..2b03d5e375d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
 
 /* that will die - we need it for nfs_lock_info */
 #include <linux/nfs_fs_i.h>
+#include <linux/ceph/ceph_fs_fl.h>
 
 /*
  * struct file_lock represents a generic "file lock". It's used to represent
@@ -1119,6 +1120,7 @@ struct file_lock {
 			int state;		/* state of grant or error if -ve */
 			unsigned int	debug_id;
 		} afs;
+		struct ceph_lock_info	ceph_fl;
 	} fl_u;
 } __randomize_layout;
 
-- 
2.31.1

