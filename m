Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE04FD20E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347804AbiDLHKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352218AbiDLHE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:04:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5512647065;
        Mon, 11 Apr 2022 23:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F7660A21;
        Tue, 12 Apr 2022 06:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5DCC385A6;
        Tue, 12 Apr 2022 06:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746069;
        bh=C/VjHc1tNIFbp9diJeoeNUsLTRlXHPT7qiUXK/T2jfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxQmqq5XuNlkpTMiLbjzDlgK1HKKiuaZs7m/5mal8IJfRKbBa1CmtSBb3u6k3TIw3
         t8U34vNH2N/Nsz4Ln6V0DUsI7t0m/FO2l0inQOvo52o32402p2TSDPJzVad0UJ7yHA
         EEpo/uRmFIdSW0t7Xy5L4Tu7cq1mH0R9HbuCTUwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/277] NFSv4: fix open failure with O_ACCMODE flag
Date:   Tue, 12 Apr 2022 08:29:13 +0200
Message-Id: <20220412062946.377721031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit b243874f6f9568b2daf1a00e9222cacdc15e159c ]

open() with O_ACCMODE|O_DIRECT flags secondly will fail.

Reproducer:
  1. mount -t nfs -o vers=4.2 $server_ip:/ /mnt/
  2. fd = open("/mnt/file", O_ACCMODE|O_DIRECT|O_CREAT)
  3. close(fd)
  4. fd = open("/mnt/file", O_ACCMODE|O_DIRECT)

Server nfsd4_decode_share_access() will fail with error nfserr_bad_xdr when
client use incorrect share access mode of 0.

Fix this by using NFS4_SHARE_ACCESS_BOTH share access mode in client,
just like firstly opening.

Fixes: ce4ef7c0a8a05 ("NFS: Split out NFS v4 file operations")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c      | 10 ----------
 fs/nfs/internal.h | 10 ++++++++++
 fs/nfs/nfs4file.c |  6 ++++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 9adc6f57a008..78219396788b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1835,16 +1835,6 @@ const struct dentry_operations nfs4_dentry_operations = {
 };
 EXPORT_SYMBOL_GPL(nfs4_dentry_operations);
 
-static fmode_t flags_to_mode(int flags)
-{
-	fmode_t res = (__force fmode_t)flags & FMODE_EXEC;
-	if ((flags & O_ACCMODE) != O_WRONLY)
-		res |= FMODE_READ;
-	if ((flags & O_ACCMODE) != O_RDONLY)
-		res |= FMODE_WRITE;
-	return res;
-}
-
 static struct nfs_open_context *create_nfs_open_context(struct dentry *dentry, int open_flags, struct file *filp)
 {
 	return alloc_nfs_open_context(dentry, flags_to_mode(open_flags), filp);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 7239118d98a3..c8845242d422 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -42,6 +42,16 @@ static inline bool nfs_lookup_is_soft_revalidate(const struct dentry *dentry)
 	return true;
 }
 
+static inline fmode_t flags_to_mode(int flags)
+{
+	fmode_t res = (__force fmode_t)flags & FMODE_EXEC;
+	if ((flags & O_ACCMODE) != O_WRONLY)
+		res |= FMODE_READ;
+	if ((flags & O_ACCMODE) != O_RDONLY)
+		res |= FMODE_WRITE;
+	return res;
+}
+
 /*
  * Note: RFC 1813 doesn't limit the number of auth flavors that
  * a server can return, so make something up.
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 8f35b5e13e93..4120e1cb3fee 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -32,6 +32,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	struct dentry *parent = NULL;
 	struct inode *dir;
 	unsigned openflags = filp->f_flags;
+	fmode_t f_mode;
 	struct iattr attr;
 	int err;
 
@@ -50,8 +51,9 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	if (err)
 		return err;
 
+	f_mode = filp->f_mode;
 	if ((openflags & O_ACCMODE) == 3)
-		openflags--;
+		f_mode |= flags_to_mode(openflags);
 
 	/* We can't create new files here */
 	openflags &= ~(O_CREAT|O_EXCL);
@@ -59,7 +61,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	parent = dget_parent(dentry);
 	dir = d_inode(parent);
 
-	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode, filp);
+	ctx = alloc_nfs_open_context(file_dentry(filp), f_mode, filp);
 	err = PTR_ERR(ctx);
 	if (IS_ERR(ctx))
 		goto out;
-- 
2.35.1



