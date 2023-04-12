Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8168E6DEA55
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDLEUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDLEUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FED6468D;
        Tue, 11 Apr 2023 21:20:33 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w11so10116534plp.13;
        Tue, 11 Apr 2023 21:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273233; x=1683865233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fj4539GRLzHrVjHF0YP2KCnSKVF667Aka0F9BXIi3mU=;
        b=L9bn1Uy9ZXyU4c2skop7NnOpJ783KAWnLv+DSKPy+O9P73HjGoQhpPvx21a8nwFD+w
         szf6+k4wRFaNokO5DN5vrW6T0QTDG+8owlauiKfUbD8WGxlyClz95UNp4C1AKMkuQfXV
         4ptnwpWjQgQJHqydTqfu6M0FDoPrH0cMzh7SFFmvT3JwijVVofm0yZ5jsOuuYImRwzYJ
         ddtZPbEqdsMmC7LGdAFybURgN8aUY3V9zR8NvqX/nacHyW5cErL2SL6MpY/56zLWAE56
         VdTPSkBzRW8EQ446uoe98hu50hRmqst3TjP5lUgtjOX6SDbtql9vlkIV5RSnK7QEeXYD
         HlPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273233; x=1683865233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fj4539GRLzHrVjHF0YP2KCnSKVF667Aka0F9BXIi3mU=;
        b=tLHKcU90Gz5FGjchDi0lNu4L+0G2Us6yaoDFpLMvAjRFRPrsWWL55FChPVnu6RU5t/
         8vMvy/+gqVyPHcA0a28rIW12hWgf17x7GDSm85+DX6a38rTeeNq6LI7gOyvyD5bts4oO
         BeImACFs2tGdNdmIv64AQCZEOiswcBqt//iZf6O5PkC13RZsqYKVsqkoGFsDtZdi66KE
         UXmGHMDYmQxZ8qU5IQo7jkUWevxW5uuHwHnC6TZfMxrHQ9mKjv3v9ux0IkYv5KLLxb9L
         MAuHl5yusyfkyufNTU7899IBCTvqnUaNyXx/1BhbpCJYi0Qbt6KKWiYW7g3JpCSCuR2I
         KaAQ==
X-Gm-Message-State: AAQBX9fUGvk02TlDVkDiikVIQ/HEvyHFqrUECeGElXOVGVO8aOvSVGsf
        WZ1BiQK4SUJYfw/eVSgPTx8nKNP115gQMA==
X-Google-Smtp-Source: AKy350ZCblxshNg2TUjU+Q2T9I52ivh7UQcGFvEW1+kLUl5HMRubiptxO9qqwmpPqG5LiEXf1HRCUQ==
X-Received: by 2002:a17:903:41c5:b0:19c:b7da:fbdf with SMTP id u5-20020a17090341c500b0019cb7dafbdfmr1209855ple.26.1681273233120;
        Tue, 11 Apr 2023 21:20:33 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:32 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 6/6] fuse: fix deadlock between atomic O_TRUNC and page invalidation
Date:   Wed, 12 Apr 2023 12:19:35 +0800
Message-Id: <20230412041935.1556-7-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412041935.1556-1-yb203166@antfin.com>
References: <20230412041935.1556-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

