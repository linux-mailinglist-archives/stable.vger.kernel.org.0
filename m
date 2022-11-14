Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD30B627583
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 06:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiKNFVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 00:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiKNFVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 00:21:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CED15FF8
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 21:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668403175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YQW+h8At8TotEHH/obztMQqcPYR5REQYupiiZjkQKY=;
        b=Z/fCL42nkxKi71DCX3kEMbtOnS0oyCICOHiXELLmR1X4EV9fmGHcnyFZCvUjI4MN3mF7c9
        e8cW4PakXtdYMub24VpyzsFgennr1bwenV1Zl2PgpIQAbiAmcjKNQr1YepDEAzZ4vQKvGe
        QcL+aTzTBGPGJL6KC94D97+UvDD6TYM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-4jOgDensOIiEfawCgNpNig-1; Mon, 14 Nov 2022 00:19:32 -0500
X-MC-Unique: 4jOgDensOIiEfawCgNpNig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC693C0E454;
        Mon, 14 Nov 2022 05:19:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2914A2028DC1;
        Mon, 14 Nov 2022 05:19:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com,
        viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/2 v2] ceph: use a xarray to record all the opened files for each inode
Date:   Mon, 14 Nov 2022 13:19:01 +0800
Message-Id: <20221114051901.15371-3-xiubli@redhat.com>
In-Reply-To: <20221114051901.15371-1-xiubli@redhat.com>
References: <20221114051901.15371-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

When releasing the file locks the fl->fl_file memory could be
already released by another thread in filp_close(), so we couldn't
depend on fl->fl_file to get the inode. Just use a xarray to record
the opened files for each inode.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/57986
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  |  9 +++++++++
 fs/ceph/inode.c |  4 ++++
 fs/ceph/locks.c | 17 ++++++++++++++++-
 fs/ceph/super.h |  4 ++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 85afcbbb5648..cb4a9c52df27 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -231,6 +231,13 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 			fi->flags |= CEPH_F_SYNC;
 
 		file->private_data = fi;
+
+		ret = xa_insert(&ci->i_opened_files, (unsigned long)file,
+				CEPH_FILP_AVAILABLE, GFP_KERNEL);
+		if (ret) {
+			kmem_cache_free(ceph_file_cachep, fi);
+			return ret;
+		}
 	}
 
 	ceph_get_fmode(ci, fmode, 1);
@@ -932,6 +939,8 @@ int ceph_release(struct inode *inode, struct file *file)
 		dout("release inode %p regular file %p\n", inode, file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
 
+		xa_erase(&ci->i_opened_files, (unsigned long)file);
+
 		ceph_fscache_unuse_cookie(inode, file->f_mode & FMODE_WRITE);
 		ceph_put_fmode(ci, fi->fmode, 1);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 77b0cd9af370..554450838e44 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -619,6 +619,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_unsafe_iops);
 	spin_lock_init(&ci->i_unsafe_lock);
 
+	xa_init(&ci->i_opened_files);
+
 	ci->i_snap_realm = NULL;
 	INIT_LIST_HEAD(&ci->i_snap_realm_item);
 	INIT_LIST_HEAD(&ci->i_snap_flush_item);
@@ -637,6 +639,8 @@ void ceph_free_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	xa_destroy(&ci->i_opened_files);
+
 	kfree(ci->i_symlink);
 #ifdef CONFIG_FS_ENCRYPTION
 	kfree(ci->fscrypt_auth);
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index d8385dd0076e..a176a30badd0 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -42,9 +42,10 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
 	struct ceph_inode_info *ci;
+	struct ceph_file_info *fi;
+	void *val;
 
 	/*
 	 * If inode is NULL it should be a request file_lock,
@@ -54,6 +55,20 @@ static void ceph_fl_release_lock(struct file_lock *fl)
 		return;
 
 	ci = ceph_inode(inode);
+
+	/*
+	 * For Posix-style locks, it may race between filp_close()s,
+	 * and it's possible that the 'file' memory pointed by
+	 * 'fl->fl_file' has been released. If so just skip it.
+	 */
+	rcu_read_lock();
+	val = xa_load(&ci->i_opened_files, (unsigned long)fl->fl_file);
+	if (val == CEPH_FILP_AVAILABLE) {
+		fi = fl->fl_file->private_data;
+		atomic_dec(&fi->num_locks);
+	}
+	rcu_read_unlock();
+
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7b75a84ba48d..b3e89192cbec 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -329,6 +329,8 @@ struct ceph_inode_xattrs_info {
 	u64 version, index_version;
 };
 
+#define CEPH_FILP_AVAILABLE         xa_mk_value(1)
+
 /*
  * Ceph inode.
  */
@@ -434,6 +436,8 @@ struct ceph_inode_info {
 	struct list_head i_unsafe_iops;   /* uncommitted mds inode ops */
 	spinlock_t i_unsafe_lock;
 
+	struct xarray		i_opened_files;
+
 	union {
 		struct ceph_snap_realm *i_snap_realm; /* snap realm (if caps) */
 		struct ceph_snapid_map *i_snapid_map; /* snapid -> dev_t */
-- 
2.31.1

