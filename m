Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8964B4EC
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiLMMMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbiLMMMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:12:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52DA15FF8
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 04:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670933485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAI9mgdskd1ADV22NmxESjpEH55uCsxgWZtJxV8d/1E=;
        b=C+4n1njfXhhyWXj+ZXZNg66AzkI274UHuN7xhFCY2jHXb3o1jUBlEKAwijOu2nX2Bk1oYI
        xXEgxLG2ZQeEJTGiKnwle3uFvYsozDa7zIYULTP3G/BVv0O7/tHFgWzsChpdrqymXZAlXN
        s/t3VpYtzRtVPOnF45xLqLIjP4czrt8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-dvOezT1eOcaie-ZF4hHeYw-1; Tue, 13 Dec 2022 07:11:22 -0500
X-MC-Unique: dvOezT1eOcaie-ZF4hHeYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CBB23C0F425;
        Tue, 13 Dec 2022 12:11:21 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CC3640AE1F4;
        Tue, 13 Dec 2022 12:11:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4 2/2] ceph: add ceph specific member support for file_lock
Date:   Tue, 13 Dec 2022 20:11:03 +0800
Message-Id: <20221213121103.213631-3-xiubli@redhat.com>
In-Reply-To: <20221213121103.213631-1-xiubli@redhat.com>
References: <20221213121103.213631-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/locks.c    | 20 ++++++++++++++++++--
 include/linux/fs.h |  3 +++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index b191426bf880..cf78608a3f9a 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
+	dst->fl_u.ceph.fl_inode = igrab(inode);
 }
 
+/*
+ * Do not use the 'fl->fl_file' in release function, which
+ * is possibly already released by another thread.
+ */
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct inode *inode = file_inode(fl->fl_file);
-	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct inode *inode = fl->fl_u.ceph.fl_inode;
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
+	fl->fl_u.ceph.fl_inode = NULL;
+	iput(inode);
 }
 
 static const struct file_lock_operations ceph_fl_lock_ops = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7b52fdfb6da0..6106374f5257 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1119,6 +1119,9 @@ struct file_lock {
 			int state;		/* state of grant or error if -ve */
 			unsigned int	debug_id;
 		} afs;
+		struct {
+			struct inode *fl_inode;
+		} ceph;
 	} fl_u;
 } __randomize_layout;
 
-- 
2.31.1

