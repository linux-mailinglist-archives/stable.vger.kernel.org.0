Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF996E76DB
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjDSJzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjDSJza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:55:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BCE7A88;
        Wed, 19 Apr 2023 02:55:14 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b46186c03so3554405b3a.3;
        Wed, 19 Apr 2023 02:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898113; x=1684490113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x47WSpZ5QyLrPYSDtzBHHRN3ETEu6+i3wSh6UyzLrPE=;
        b=mfTEHVZmGkMQA+8+XTgimdh+0P+mIpdWhanOgDNXQAsdEYBwmeVWj1SJ1g7wdZoL6R
         zsTY+c03k6rja/p6d1P9WZynOkkha7nTitrCje+P2VmyjyVWsppgZxtQRvHU7GyOjSer
         3WWSNDK3SrhV8lNWdzB4lUbQwfk1SuxP7E7ut52T6nAqvCDdxsqRASlRQF45fZYcsgIY
         kwVFDlQSmeKL9rm3OLdCGxBsCqIDfFcUKkHG+rlhi5Gb09b0UGYb7DAl5vKC2HuSYeB9
         HlemxZ1Ge6a76m0dtAAwtcxUYbz6FYeRuqUWj92YQY+OBUNI1LzCaKO/g2Q8QNI1p7Ob
         JYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898113; x=1684490113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x47WSpZ5QyLrPYSDtzBHHRN3ETEu6+i3wSh6UyzLrPE=;
        b=I1DHvT57YABPQe6VecsGSowHyzQjDmeG7wB3qfm35lVrdrDrUAdhMhEMw/ukoFfFkc
         7PlJ2QWqe38KCDYxu+6rjGUTznmnXoHoiLlfNYdlJIO6SRm4JJVECreIc1i7/PVFSyyH
         An6/D/YV/PtA4k9n84nNLf1bVKkUBTWudBgKIAdLBtDprHgR+0RwtEna2QTdJDLULhzV
         54SHDUdDEf7nzn2BNppKczTYMwcW+4zthmsI9aaEZmPdZp6Gc1JF1ANI1rEFGlG5lMbx
         /wesIR2L07kp1WiSaMgTegJ3tI1Byuu0GqyfJpCQULpDkIxFXSQ+IOydNrYdC2IEOwoY
         yXPQ==
X-Gm-Message-State: AAQBX9dw0bkDb/NpSif016flrgip6Ll6rmyKPHk6iupREMsWVV7SEV3h
        Ul/EVstStEFljN9ykXSXUx/e1zmFZGWV8w==
X-Google-Smtp-Source: AKy350Y9+DvKqFvHt1OhKv3d3k2bUzTgzK+Gz6RZvoF88Q0L5LxNVTT0YHbv+9DQPfDBq6ddfecKIQ==
X-Received: by 2002:a17:902:c44a:b0:1a6:d15f:3ce1 with SMTP id m10-20020a170902c44a00b001a6d15f3ce1mr4169092plm.34.1681898113601;
        Wed, 19 Apr 2023 02:55:13 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b0019f9fd10f62sm11108357plw.70.2023.04.19.02.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:55:13 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 3/3] fuse: fix deadlock between atomic O_TRUNC and page invalidation
Date:   Wed, 19 Apr 2023 17:54:24 +0800
Message-Id: <20230419095424.51328-4-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419095424.51328-1-yb203166@antfin.com>
References: <20230419095424.51328-1-yb203166@antfin.com>
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

[backport for 5.15.y]

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
 fs/fuse/dir.c  |  7 ++++++-
 fs/fuse/file.c | 29 +++++++++++++++++------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 075266140fac..1abbdd78389a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -476,6 +476,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
+	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
 	BUG_ON((mode & S_IFMT) != S_IFREG);
@@ -500,7 +501,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	inarg.mode = mode;
 	inarg.umask = current_umask();
 
-	if (fm->fc->handle_killpriv_v2 && (flags & O_TRUNC) &&
+	if (fm->fc->handle_killpriv_v2 && trunc &&
 	    !(flags & O_EXCL) && !capable(CAP_FSETID)) {
 		inarg.open_flags |= FUSE_OPEN_KILL_SUIDGID;
 	}
@@ -549,6 +550,10 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
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
index ab994ecdaf38..2c4cac6104c9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -210,12 +210,9 @@ void fuse_finish_open(struct inode *inode, struct file *file)
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
 
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
@@ -240,30 +237,38 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	if (err)
 		return err;
 
-	if (is_wb_truncate || dax_truncate) {
+	if (is_wb_truncate || dax_truncate)
 		inode_lock(inode);
-		fuse_set_nowrite(inode);
-	}
 
 	if (dax_truncate) {
 		filemap_invalidate_lock(inode->i_mapping);
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
 		filemap_invalidate_unlock(inode->i_mapping);
-
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

