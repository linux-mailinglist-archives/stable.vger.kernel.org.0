Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9563B3831BE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhEQOk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240416AbhEQOhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DBCF61927;
        Mon, 17 May 2021 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261073;
        bh=IqqztnJkz79HZnxB+neCuw1jyH+Dt1nLRBU0ix6HP/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+QV1Li5eGYqK0tkzDN3yhFq+3NdWZq8hYtvgkkWZQdxI78jf/OIktt8a+kkkp4Ku
         6VpXSKKtz/dbHRCSl5hwkc5ezXh6UPb+Kz896JgOg+QrN+DbduR4809vLwesJq8Ef1
         ZBVWYpI55YNndhQTvXwJWK0KkSV9WRKaSIlRdO/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 302/363] f2fs: compress: fix to assign cc.cluster_idx correctly
Date:   Mon, 17 May 2021 16:02:48 +0200
Message-Id: <20210517140312.808728091@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 8bfbfb0ddd706b1ce2e89259ecc45f192c0ec2bf ]

In f2fs_destroy_compress_ctx(), after f2fs_destroy_compress_ctx(),
cc.cluster_idx will be cleared w/ NULL_CLUSTER, f2fs_cluster_blocks()
may check wrong cluster metadata, fix it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 17 +++++++++--------
 fs/f2fs/data.c     |  6 +++---
 fs/f2fs/f2fs.h     |  2 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index b7ab3bdf2259..66dd525a8554 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -151,13 +151,14 @@ int f2fs_init_compress_ctx(struct compress_ctx *cc)
 	return cc->rpages ? 0 : -ENOMEM;
 }
 
-void f2fs_destroy_compress_ctx(struct compress_ctx *cc)
+void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse)
 {
 	page_array_free(cc->inode, cc->rpages, cc->cluster_size);
 	cc->rpages = NULL;
 	cc->nr_rpages = 0;
 	cc->nr_cpages = 0;
-	cc->cluster_idx = NULL_CLUSTER;
+	if (!reuse)
+		cc->cluster_idx = NULL_CLUSTER;
 }
 
 void f2fs_compress_ctx_add_page(struct compress_ctx *cc, struct page *page)
@@ -1046,7 +1047,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		ret = f2fs_read_multi_pages(cc, &bio, cc->cluster_size,
 					&last_block_in_bio, false, true);
 		f2fs_put_rpages(cc);
-		f2fs_destroy_compress_ctx(cc);
+		f2fs_destroy_compress_ctx(cc, true);
 		if (ret)
 			goto out;
 		if (bio)
@@ -1073,7 +1074,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 release_and_retry:
 			f2fs_put_rpages(cc);
 			f2fs_unlock_rpages(cc, i + 1);
-			f2fs_destroy_compress_ctx(cc);
+			f2fs_destroy_compress_ctx(cc, true);
 			goto retry;
 		}
 	}
@@ -1106,7 +1107,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 unlock_pages:
 	f2fs_put_rpages(cc);
 	f2fs_unlock_rpages(cc, i);
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, true);
 out:
 	return ret;
 }
@@ -1142,7 +1143,7 @@ bool f2fs_compress_write_end(struct inode *inode, void *fsdata,
 		set_cluster_dirty(&cc);
 
 	f2fs_put_rpages_wbc(&cc, NULL, false, 1);
-	f2fs_destroy_compress_ctx(&cc);
+	f2fs_destroy_compress_ctx(&cc, false);
 
 	return first_index;
 }
@@ -1361,7 +1362,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	f2fs_put_rpages(cc);
 	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, false);
 	return 0;
 
 out_destroy_crypt:
@@ -1523,7 +1524,7 @@ int f2fs_write_multi_pages(struct compress_ctx *cc,
 	err = f2fs_write_raw_pages(cc, submitted, wbc, io_type);
 	f2fs_put_rpages_wbc(cc, wbc, false, 0);
 destroy_out:
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, false);
 	return err;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4e5257c763d0..8804a5d51380 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2276,7 +2276,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 							max_nr_pages,
 							&last_block_in_bio,
 							rac != NULL, false);
-				f2fs_destroy_compress_ctx(&cc);
+				f2fs_destroy_compress_ctx(&cc, false);
 				if (ret)
 					goto set_error_page;
 			}
@@ -2321,7 +2321,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 							max_nr_pages,
 							&last_block_in_bio,
 							rac != NULL, false);
-				f2fs_destroy_compress_ctx(&cc);
+				f2fs_destroy_compress_ctx(&cc, false);
 			}
 		}
 #endif
@@ -3022,7 +3022,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 		}
 	}
 	if (f2fs_compressed_file(inode))
-		f2fs_destroy_compress_ctx(&cc);
+		f2fs_destroy_compress_ctx(&cc, false);
 #endif
 	if (retry) {
 		index = 0;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index eaf6f62206de..f3fabb1edfe9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3950,7 +3950,7 @@ struct decompress_io_ctx *f2fs_alloc_dic(struct compress_ctx *cc);
 void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed);
 void f2fs_put_page_dic(struct page *page);
 int f2fs_init_compress_ctx(struct compress_ctx *cc);
-void f2fs_destroy_compress_ctx(struct compress_ctx *cc);
+void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse);
 void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi);
 void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi);
-- 
2.30.2



