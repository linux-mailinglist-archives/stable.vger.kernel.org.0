Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBE46E76BA
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjDSJtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjDSJto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA0159F5;
        Wed, 19 Apr 2023 02:49:42 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b35789313so2366092b3a.3;
        Wed, 19 Apr 2023 02:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897782; x=1684489782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fj4539GRLzHrVjHF0YP2KCnSKVF667Aka0F9BXIi3mU=;
        b=mL5ajrDyLao9Sgy63bEgSxvC1lQmzDsN8fYMRv7VitUlnxg4j86vPvFfRIl1+QVcRz
         buqT6zrtX8WLhw10Espdx+hLvdsFynmDkaRXv9JHHdiXo1E4IHPoMkUYZyTerzvRvbWg
         8uTw1Jo+O16Ehsx+AGdY/ZC2xCpv3niN1ClnSXoapty6Vxb2fUn8xA2yNlFtHsbwdbBP
         5nYxKT1MjfgsXUWss8FpkXGbh623W3EEiUxSMOdbtNOgPMVBi90vFnaSqcKB8DuywFng
         TgX6/cHmeouUEMF/bonwFT5i17CdHqmsG2bJha46yG91vkOWiKSPgnEZXOQQCZUneBo1
         fz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897782; x=1684489782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fj4539GRLzHrVjHF0YP2KCnSKVF667Aka0F9BXIi3mU=;
        b=KnioiMEPXyfbIn1z852Q7CPvdZg/gs+Y9vJ4y9+XFS2Y8xcJ04yRhNguDypdxdgCBJ
         uqNAgJLq3cHvNpUY9k62WmT5VLqWk74YHzIp9Uv6uarnxDszmyWdhdsQQWl/O3OwClqC
         aIZlxs6Qhn39WwPe9jqPVJ35bF7XzboPj7Jm2UJY0ZyEZLQmX43w4NRslSJ/XFzAgBCp
         fHjR7+Es4eLIRgWa3hOkFhPVi8bLNPnvme6T7lhAW0Y+vdgBoLLQUyK1DYATaN6nkoR3
         cK/nsTEQGhPSLAe0i7QRcy3KTffOCEAUnsDgBf4qLppUrqlChnLo6v39MgNAijXjYi4S
         ORuw==
X-Gm-Message-State: AAQBX9fW+HkDIazRTecGsCv1XvYJdD+eAFbC+DrSg9ENSP9360Pc+ZM1
        QBnedW0IHpomWKUsonHSdX5lDg23NN++Bw==
X-Google-Smtp-Source: AKy350ZRgnS8oPbp6dIUBK5mLH29ZGd5a2DBwGn/oJqS2yv/RxgRIVLkL6CHDe1uokzmtlMkFeAojw==
X-Received: by 2002:a05:6a00:1355:b0:63d:3aed:44fc with SMTP id k21-20020a056a00135500b0063d3aed44fcmr3224706pfu.26.1681897781731;
        Wed, 19 Apr 2023 02:49:41 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:41 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 6/6] fuse: fix deadlock between atomic O_TRUNC and page invalidation
Date:   Wed, 19 Apr 2023 17:48:44 +0800
Message-Id: <20230419094844.51110-7-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419094844.51110-1-yb203166@antfin.com>
References: <20230419094844.51110-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 2fdbb8dd01556e1501132b5ad3826e8f71e24a8b upstream.

[backport for 5.10.y]

fuse_finish_open() will be called with FUSE_NOWRITE set in case of atomic
O_TRUNC open(), so commit 76224355db75 ("fuse: truncate pagecache on
atomic_o_trunc") replaced invalidate_inode_pages2() by truncate_pagecache()
in such a case to avoid the A-A deadlock. However, we found another A-B-B-A
deadlock related to the case above, which will cause the xfstests
generic/464 testcase hung in our virtio-fs test environment.

For example, consider two processes concurrently open one same file, one
with O_TRUNC and another without O_TRUNC. The deadlock case is described
below, if open(O_TRUNC) is already set_nowrite(acquired A), and is trying
to lock a page (acquiring B), open() could have held the page lock
(acquired B), and waiting on the page writeback (acquiring A). This would
lead to deadlocks.

open(O_TRUNC)
----------------------------------------------------------------
fuse_open_common
  inode_lock            [C acquire]
  fuse_set_nowrite      [A acquire]

  fuse_finish_open
    truncate_pagecache
      lock_page         [B acquire]
      truncate_inode_page
      unlock_page       [B release]

  fuse_release_nowrite  [A release]
  inode_unlock          [C release]
----------------------------------------------------------------

open()
----------------------------------------------------------------
fuse_open_common
  fuse_finish_open
    invalidate_inode_pages2
      lock_page         [B acquire]
        fuse_launder_page
          fuse_wait_on_page_writeback [A acquire & release]
      unlock_page       [B release]
----------------------------------------------------------------

Besides this case, all calls of invalidate_inode_pages2() and
invalidate_inode_pages2_range() in fuse code also can deadlock with
open(O_TRUNC).

Fix by moving the truncate_pagecache() call outside the nowrite protected
region.  The nowrite protection is only for delayed writeback
(writeback_cache) case, where inode lock does not protect against
truncation racing with writes on the server.  Write syscalls racing with
page cache truncation still get the inode lock protection.

This patch also changes the order of filemap_invalidate_lock()
vs. fuse_set_nowrite() in fuse_open_common().  This new order matches the
order found in fuse_file_fallocate() and fuse_do_setattr().

Reported-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Tested-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Fixes: e4648309b85a ("fuse: truncate pending writes on O_TRUNC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/dir.c  |  5 +++++
 fs/fuse/file.c | 29 +++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index bdb04bea0da9..e3b9b7d188e6 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -537,6 +537,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
+	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
 	BUG_ON((mode & S_IFMT) != S_IFREG);
@@ -604,6 +605,10 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	} else {
 		file->private_data = ff;
 		fuse_finish_open(inode, file);
+		if (fm->fc->atomic_o_trunc && trunc)
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
 	}
 	return err;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 94fe2c690676..13d97547eaf6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,14 +206,10 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, 0);
 		spin_unlock(&fi->lock);
-		truncate_pagecache(inode, 0);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache)
 			file_update_time(file);
-	} else if (!(ff->open_flags & FOPEN_KEEP_CACHE)) {
-		invalidate_inode_pages2(inode->i_mapping);
 	}
-
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
 }
@@ -236,30 +232,39 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	if (err)
 		return err;
 
-	if (is_wb_truncate || dax_truncate) {
+	if (is_wb_truncate || dax_truncate)
 		inode_lock(inode);
-		fuse_set_nowrite(inode);
-	}
 
 	if (dax_truncate) {
 		down_write(&get_fuse_inode(inode)->i_mmap_sem);
 		err = fuse_dax_break_layouts(inode, 0, 0);
 		if (err)
-			goto out;
+			goto out_inode_unlock;
 	}
 
+	if (is_wb_truncate || dax_truncate)
+		fuse_set_nowrite(inode);
+
 	err = fuse_do_open(fm, get_node_id(inode), file, isdir);
 	if (!err)
 		fuse_finish_open(inode, file);
 
-out:
+	if (is_wb_truncate || dax_truncate)
+		fuse_release_nowrite(inode);
+	if (!err) {
+		struct fuse_file *ff = file->private_data;
+
+		if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
+	}
 	if (dax_truncate)
 		up_write(&get_fuse_inode(inode)->i_mmap_sem);
 
-	if (is_wb_truncate | dax_truncate) {
-		fuse_release_nowrite(inode);
+out_inode_unlock:
+	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
-	}
 
 	return err;
 }
-- 
2.40.0

