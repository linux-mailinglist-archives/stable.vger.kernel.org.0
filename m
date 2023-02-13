Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B969447D
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBML35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjBML3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:29:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246EDBFD
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676287732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=91axYkgwIMCEz1WKAFTJX5qVVuOGqFHheqUFcZuc9sQ=;
        b=JguSrXLJ53agJtnRY7xPM1qB08lSEAssFIscLiH+g83RK3W4PDgt92X+OrB4egyGCpEMAV
        UIUEQsbeecE0TulCC3T5MXWbiS66J4xmrm4iY3I67ucuyWeXNJ60YeEgtU4E8y11XDfy9e
        ljuYnvX6JWIGEiteUmrZ/vQNZWV7tDU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-WOIPIWVZMvSFn63JcUHuBw-1; Mon, 13 Feb 2023 06:28:51 -0500
X-MC-Unique: WOIPIWVZMvSFn63JcUHuBw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D88E2101A55E;
        Mon, 13 Feb 2023 11:28:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 045D8492B15;
        Mon, 13 Feb 2023 11:28:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: update the time stamps and try to drop the suid/sgid
Date:   Mon, 13 Feb 2023 19:28:34 +0800
Message-Id: <20230213112834.15714-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

The fallocate will try to clear the suid/sgid if a unprevileged user
changed the file.

There is no Posix item requires that we should clear the suid/sgid
in fallocate code path but this is the default behaviour for most of
the filesystems and the VFS layer. And also the same for the write
code path, which have already support it.

And also we need to update the time stamps since the fallocate will
change the file contents.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/58054
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 903de296f0d3..dee3b445f415 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2502,6 +2502,9 @@ static long ceph_fallocate(struct file *file, int mode,
 	loff_t endoff = 0;
 	loff_t size;
 
+	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
+	     inode, ceph_vinop(inode), mode, offset, length);
+
 	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
@@ -2539,6 +2542,10 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (ret < 0)
 		goto unlock;
 
+	ret = file_modified(file);
+	if (ret)
+		goto put_caps;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	ceph_fscache_invalidate(inode, false);
 	ceph_zero_pagecache_range(inode, offset, length);
@@ -2554,6 +2561,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
+put_caps:
 	ceph_put_cap_refs(ci, got);
 unlock:
 	inode_unlock(inode);
-- 
2.31.1

