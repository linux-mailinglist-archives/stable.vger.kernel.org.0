Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9434B4AD1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbiBNKen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348210AbiBNKeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851F1A2F0F;
        Mon, 14 Feb 2022 02:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F65C6077B;
        Mon, 14 Feb 2022 10:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BD2C340E9;
        Mon, 14 Feb 2022 10:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832846;
        bh=V75dH+7dwU6ylnk88scfhrqdjFa2FeD4q0zh7cMdTnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqtgDlxl0qC1pxPwT43kRemQnlNCOQGYpk9Przfxc59dMUlDeZOON+tRvmCGh+kd7
         XwgOyj5rQ2evEHEkGA/IkYgLjh4f9F0e0TpD5TJ1c6vfGgfOPiO3e7jfa9XdjYnu1j
         kCzvTeCpwH1f3iAu5zpY/z6VUybD1GH54eBvjeYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 112/203] NFS: Avoid duplicate uncached readdir calls on eof
Date:   Mon, 14 Feb 2022 10:25:56 +0100
Message-Id: <20220214092514.051680388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e1d2699b96793d19388e302fa095e0da2c145701 ]

If we've reached the end of the directory, then cache that information
in the context so that we don't need to do an uncached readdir in order
to rediscover that fact.

Fixes: 794092c57f89 ("NFS: Do uncached readdir when we're seeking a cookie in an empty page cache")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c           | 20 +++++++++++++++-----
 include/linux/nfs_fs.h |  1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 63d7da0b7e32c..b2460a0504411 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -79,6 +79,7 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 		ctx->dir_cookie = 0;
 		ctx->dup_cookie = 0;
 		ctx->page_index = 0;
+		ctx->eof = false;
 		spin_lock(&dir->i_lock);
 		if (list_empty(&nfsi->open_files) &&
 		    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
@@ -167,6 +168,7 @@ struct nfs_readdir_descriptor {
 	unsigned int	cache_entry_index;
 	signed char duped;
 	bool plus;
+	bool eob;
 	bool eof;
 };
 
@@ -988,7 +990,7 @@ static void nfs_do_filldir(struct nfs_readdir_descriptor *desc,
 		ent = &array->array[i];
 		if (!dir_emit(desc->ctx, ent->name, ent->name_len,
 		    nfs_compat_user_ino64(ent->ino), ent->d_type)) {
-			desc->eof = true;
+			desc->eob = true;
 			break;
 		}
 		memcpy(desc->verf, verf, sizeof(desc->verf));
@@ -1004,7 +1006,7 @@ static void nfs_do_filldir(struct nfs_readdir_descriptor *desc,
 			desc->duped = 1;
 	}
 	if (array->page_is_eof)
-		desc->eof = true;
+		desc->eof = !desc->eob;
 
 	kunmap(desc->page);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %llu\n",
@@ -1047,7 +1049,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 
 	status = nfs_readdir_xdr_to_array(desc, desc->verf, verf, arrays, sz);
 
-	for (i = 0; !desc->eof && i < sz && arrays[i]; i++) {
+	for (i = 0; !desc->eob && i < sz && arrays[i]; i++) {
 		desc->page = arrays[i];
 		nfs_do_filldir(desc, verf);
 	}
@@ -1106,9 +1108,15 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	desc->duped = dir_ctx->duped;
 	page_index = dir_ctx->page_index;
 	desc->attr_gencount = dir_ctx->attr_gencount;
+	desc->eof = dir_ctx->eof;
 	memcpy(desc->verf, dir_ctx->verf, sizeof(desc->verf));
 	spin_unlock(&file->f_lock);
 
+	if (desc->eof) {
+		res = 0;
+		goto out_free;
+	}
+
 	if (test_and_clear_bit(NFS_INO_FORCE_READDIR, &nfsi->flags) &&
 	    list_is_singular(&nfsi->open_files))
 		invalidate_mapping_pages(inode->i_mapping, page_index + 1, -1);
@@ -1142,7 +1150,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 
 		nfs_do_filldir(desc, nfsi->cookieverf);
 		nfs_readdir_page_unlock_and_put_cached(desc);
-	} while (!desc->eof);
+	} while (!desc->eob && !desc->eof);
 
 	spin_lock(&file->f_lock);
 	dir_ctx->dir_cookie = desc->dir_cookie;
@@ -1150,9 +1158,10 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	dir_ctx->duped = desc->duped;
 	dir_ctx->attr_gencount = desc->attr_gencount;
 	dir_ctx->page_index = desc->page_index;
+	dir_ctx->eof = desc->eof;
 	memcpy(dir_ctx->verf, desc->verf, sizeof(dir_ctx->verf));
 	spin_unlock(&file->f_lock);
-
+out_free:
 	kfree(desc);
 
 out:
@@ -1194,6 +1203,7 @@ static loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int whence)
 		if (offset == 0)
 			memset(dir_ctx->verf, 0, sizeof(dir_ctx->verf));
 		dir_ctx->duped = 0;
+		dir_ctx->eof = false;
 	}
 	spin_unlock(&filp->f_lock);
 	return offset;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f33559acbcc28..29a2ab5de1daa 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -105,6 +105,7 @@ struct nfs_open_dir_context {
 	__u64 dup_cookie;
 	pgoff_t page_index;
 	signed char duped;
+	bool eof;
 };
 
 /*
-- 
2.34.1



