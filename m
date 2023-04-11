Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF1F6DD018
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDKDVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjDKDVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:21:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A888C132
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-246a1c48021so243284a91.3
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681183308; x=1683775308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjwAplnO2gDWMaJRFh741ZiK1Z+bMIHM3Iutj+xefWU=;
        b=ZGS7d+sQt0NLKYhnM5AqBAR8ZTTLwSPQOKv8n5YBwndH7pP1ZWNRZ2UXFvaVacQeMh
         QTj/Gmmq54RWJB7kwmBBN5XsLxViU30y9KQ4lNOm2SugOWQL8Sq5RKcx1geFvuHEI38+
         QhrhL9N7R3l0gRU5ROdbsmGoUphr/uMbXEXz8CF9lXj7hSHH3ox6RvdwMHpVuPTlvdFh
         +Rj/e+Qdg6Fdmw+ZgJj0nceBZ9NbLCU5xWnt2OukWDSsm3fdnnhdabh/BVWwyTCbO2BW
         IDBPFm4jxrCnFCGNDJ4sCjxSf9nf0paATRCVanIDPZkw/jM9ZNTRzjTloCnHwSkW+kou
         RLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183308; x=1683775308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjwAplnO2gDWMaJRFh741ZiK1Z+bMIHM3Iutj+xefWU=;
        b=MpyfVJyvA+tWNFZz5SlKsEenxQpv4z5N/pWmz37M2f3JnyUsqrYC0aJE4lWLWxnko1
         HmXhxX4cOvUSVquascwxXfrr+3Ph3EWvSRj6U+3xSIn6gS4MmI0iFuV4uOd/t+xDPkA/
         W/Z2goS5RevAiSYAktFAThEyX0Uaft7zOhCcDNIPsBCHPfq9UHIaD0hDKzf2wedqgppf
         y5ycz49+5X1CsHpyvxax/1nkxqXzVwXvxadLe9OrGktNE/2l87s54rlIJ8prQVvaH7fR
         32sZ2Up81uwoqDzUTVIZx7E0eYHOg0NneGruMhDOACLNM3g5ver4p/zDicW8YVYFARf9
         U2Tg==
X-Gm-Message-State: AAQBX9dTZOeZhewxN0pKmrpQa7+dt3JC8u40dl2LO9EdHxTmEeva/UCx
        J91JPrUSoinFTqmf9D9R0zzPE1SKEVLGzw==
X-Google-Smtp-Source: AKy350aaBgdHS48P/SAGNAy2PoJAgSHJaBLFJiohn0sOWWOzMZAlsDzkyGCDJziOCSzwiBG8zGKffw==
X-Received: by 2002:aa7:843a:0:b0:63a:edfa:e216 with SMTP id q26-20020aa7843a000000b0063aedfae216mr1396323pfn.14.1681183308673;
        Mon, 10 Apr 2023 20:21:48 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm7743195pgj.48.2023.04.10.20.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:21:48 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH 6/6] fuse: fix deadlock between atomic O_TRUNC and page invalidation
Date:   Tue, 11 Apr 2023 11:21:11 +0800
Message-Id: <20230411032111.1213-6-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230411032111.1213-1-yb203166@antfin.com>
References: <20230411032111.1213-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

