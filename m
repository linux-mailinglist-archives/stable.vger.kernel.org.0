Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A39B62EBAD
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 03:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbiKRCH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 21:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbiKRCHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 21:07:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8D898C8
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 18:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668737217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E50ouKsSOSWKlmi2VnrMWYeqEQ0C3pYJnQUUUioyHwY=;
        b=Fqnik3bt0Eb/8ogup0cwR8HajBJTRPQYiXc+lsOTo5YZOjG0jHAabJrVLs3gafue6SI8lG
        0u/AHxV92rEVGSJV95eqBIb/C2L3GmPJ3eaQzQgHVbjbrrdpq5CtlEt1fCb/HLhSZoO198
        YymKXQEQud/95o+usAaWa7e4VxaYgUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-6ZsLk-XWP5GCXGHwuIlnHA-1; Thu, 17 Nov 2022 21:06:54 -0500
X-MC-Unique: 6ZsLk-XWP5GCXGHwuIlnHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A51F101A54E;
        Fri, 18 Nov 2022 02:06:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B18FC158CF;
        Fri, 18 Nov 2022 02:06:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/2 v3] ceph: switch to vfs_inode_has_locks() to fix file lock bug
Date:   Fri, 18 Nov 2022 10:06:41 +0800
Message-Id: <20221118020642.472484-2-xiubli@redhat.com>
In-Reply-To: <20221118020642.472484-1-xiubli@redhat.com>
References: <20221118020642.472484-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

For the POSIX locks they are using the same owner, which is the
thread id. And multiple POSIX locks could be merged into single one,
so when checking whether the 'file' has locks may fail.

For a file where some openers use locking and others don't is a
really odd usage pattern though. Locks are like stoplights -- they
only work if everyone pays attention to them.

Just switch ceph_get_caps() to check whether any locks are set on
the inode. If there are POSIX/OFD/FLOCK locks on the file at the
time, we should set CHECK_FILELOCK, regardless of what fd was used
to set the lock.

Cc: stable@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>
Fixes: ff5d913dfc71 ("ceph: return -EIO if read/write against filp that lost file locks")
URL: https://tracker.ceph.com/issues/57986
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/locks.c | 4 ----
 fs/ceph/super.h | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 065e9311b607..948136f81fc8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2964,7 +2964,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (vfs_inode_has_locks(inode))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 3e2843e86e27..b191426bf880 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -32,18 +32,14 @@ void __init ceph_flock_init(void)
 
 static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
-	struct ceph_file_info *fi = dst->fl_file->private_data;
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
-	atomic_inc(&fi->num_locks);
 }
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = file_inode(fl->fl_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	atomic_dec(&fi->num_locks);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7b75a84ba48d..87dc55c866e9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -803,7 +803,6 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	u32 filp_gen;
-	atomic_t num_locks;
 };
 
 struct ceph_dir_file_info {
-- 
2.31.1

