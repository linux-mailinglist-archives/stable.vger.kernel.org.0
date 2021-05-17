Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C903836E6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244674AbhEQPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343697AbhEQPem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF3C261CE0;
        Mon, 17 May 2021 14:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262372;
        bh=e9XDBkB/mMJviNP21ILe/38ARmDZ9T2Xyu23n5MlEdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZiZAZcuTLbfApMuMcUBf9lSYbjdgonlNmHGneZtH3Nne1LF9ReM3PlFGqRvTbcGW
         isTuN1uTpU0UhazRdmfwS185kVdOEFxU2geBtXpxngHTNhhcK1zEFegwE5vAbR+1N9
         Op3Cdlst7KRv2JMIRxUvV4VNtrz2L4+ivNgkNqh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 277/329] f2fs: compress: fix to assign cc.cluster_idx correctly
Date:   Mon, 17 May 2021 16:03:08 +0200
Message-Id: <20210517140311.475534057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 8093d06116b4..3a503e5a8c11 100644
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
@@ -1006,7 +1007,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		ret = f2fs_read_multi_pages(cc, &bio, cc->cluster_size,
 					&last_block_in_bio, false, true);
 		f2fs_put_rpages(cc);
-		f2fs_destroy_compress_ctx(cc);
+		f2fs_destroy_compress_ctx(cc, true);
 		if (ret)
 			goto out;
 		if (bio)
@@ -1033,7 +1034,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 release_and_retry:
 			f2fs_put_rpages(cc);
 			f2fs_unlock_rpages(cc, i + 1);
-			f2fs_destroy_compress_ctx(cc);
+			f2fs_destroy_compress_ctx(cc, true);
 			goto retry;
 		}
 	}
@@ -1066,7 +1067,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 unlock_pages:
 	f2fs_put_rpages(cc);
 	f2fs_unlock_rpages(cc, i);
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, true);
 out:
 	return ret;
 }
@@ -1102,7 +1103,7 @@ bool f2fs_compress_write_end(struct inode *inode, void *fsdata,
 		set_cluster_dirty(&cc);
 
 	f2fs_put_rpages_wbc(&cc, NULL, false, 1);
-	f2fs_destroy_compress_ctx(&cc);
+	f2fs_destroy_compress_ctx(&cc, false);
 
 	return first_index;
 }
@@ -1321,7 +1322,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	f2fs_put_rpages(cc);
 	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, false);
 	return 0;
 
 out_destroy_crypt:
@@ -1483,7 +1484,7 @@ int f2fs_write_multi_pages(struct compress_ctx *cc,
 	err = f2fs_write_raw_pages(cc, submitted, wbc, io_type);
 	f2fs_put_rpages_wbc(cc, wbc, false, 0);
 destroy_out:
-	f2fs_destroy_compress_ctx(cc);
+	f2fs_destroy_compress_ctx(cc, false);
 	return err;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4d3ebf094f6d..3802ad227a1e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2405,7 +2405,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 							max_nr_pages,
 							&last_block_in_bio,
 							rac != NULL, false);
-				f2fs_destroy_compress_ctx(&cc);
+				f2fs_destroy_compress_ctx(&cc, false);
 				if (ret)
 					goto set_error_page;
 			}
@@ -2450,7 +2450,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 							max_nr_pages,
 							&last_block_in_bio,
 							rac != NULL, false);
-				f2fs_destroy_compress_ctx(&cc);
+				f2fs_destroy_compress_ctx(&cc, false);
 			}
 		}
 #endif
@@ -3154,7 +3154,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 		}
 	}
 	if (f2fs_compressed_file(inode))
-		f2fs_destroy_compress_ctx(&cc);
+		f2fs_destroy_compress_ctx(&cc, false);
 #endif
 	if (retry) {
 		index = 0;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c9d54652a518..43e76529d674 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3894,7 +3894,7 @@ void f2fs_free_dic(struct decompress_io_ctx *dic);
 void f2fs_decompress_end_io(struct page **rpages,
 			unsigned int cluster_size, bool err, bool verity);
 int f2fs_init_compress_ctx(struct compress_ctx *cc);
-void f2fs_destroy_compress_ctx(struct compress_ctx *cc);
+void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse);
 void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi);
 void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi);
-- 
2.30.2



