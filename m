Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971AE1AA1DA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897198AbgDOLhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897181AbgDOLgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C49220936;
        Wed, 15 Apr 2020 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950603;
        bh=YLXBwgw3/Lm1c+qH8DOQy+FDCzjJEKmau8CPH+MDC5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiCK4FXusW5AcJ/AAPFy4hB78r5rogA3Geb5jUh1lpVRD+HhdAg0H+K5332jqv0WU
         psxtlSLb/+IkFoFIiVh9j2VSQ6b8NH5dDKv/5XQURqHIvKqQLSoZjupkBnpebM0MBw
         CjHU3lpxXdbNLLrhXedhrt5ywwg9kaW9ar07SdxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.6 098/129] f2fs: fix NULL pointer dereference in f2fs_verity_work()
Date:   Wed, 15 Apr 2020 07:34:13 -0400
Message-Id: <20200415113445.11881-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 79bbefb19f1359fb2cbd144d5a054649e7e583be ]

If both compression and fsverity feature is on, generic/572 will
report below NULL pointer dereference bug.

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 RIP: 0010:f2fs_verity_work+0x60/0x90 [f2fs]
 #PF: supervisor read access in kernel mode
 Workqueue: fsverity_read_queue f2fs_verity_work [f2fs]
 RIP: 0010:f2fs_verity_work+0x60/0x90 [f2fs]
 Call Trace:
  process_one_work+0x16c/0x3f0
  worker_thread+0x4c/0x440
  ? rescuer_thread+0x350/0x350
  kthread+0xf8/0x130
  ? kthread_unpark+0x70/0x70
  ret_from_fork+0x35/0x40

There are two issue in f2fs_verity_work():
- it needs to traverse and verify all pages in bio.
- if pages in bio belong to non-compressed cluster, accessing
decompress IO context stored in page private will cause NULL
pointer dereference.

Fix them.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c |  2 ++
 fs/f2fs/data.c     | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 1a86e483b0907..eb84c13c1182c 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -476,6 +476,8 @@ void f2fs_decompress_pages(struct bio *bio, struct page *page, bool verity)
 out_vunmap_rbuf:
 	vunmap(dic->rbuf);
 out_free_dic:
+	if (verity)
+		refcount_add(dic->nr_cpages - 1, &dic->ref);
 	if (!verity)
 		f2fs_decompress_end_io(dic->rpages, dic->cluster_size,
 								ret, false);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b27b721079116..34990866cfe96 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -191,12 +191,37 @@ static void f2fs_verify_pages(struct page **rpages, unsigned int cluster_size)
 
 static void f2fs_verify_bio(struct bio *bio)
 {
-	struct page *page = bio_first_page_all(bio);
-	struct decompress_io_ctx *dic =
-			(struct decompress_io_ctx *)page_private(page);
+	struct bio_vec *bv;
+	struct bvec_iter_all iter_all;
+
+	bio_for_each_segment_all(bv, bio, iter_all) {
+		struct page *page = bv->bv_page;
+		struct decompress_io_ctx *dic;
+
+		dic = (struct decompress_io_ctx *)page_private(page);
+
+		if (dic) {
+			if (refcount_dec_not_one(&dic->ref))
+				continue;
+			f2fs_verify_pages(dic->rpages,
+						dic->cluster_size);
+			f2fs_free_dic(dic);
+			continue;
+		}
+
+		if (bio->bi_status || PageError(page))
+			goto clear_uptodate;
 
-	f2fs_verify_pages(dic->rpages, dic->cluster_size);
-	f2fs_free_dic(dic);
+		if (fsverity_verify_page(page)) {
+			SetPageUptodate(page);
+			goto unlock;
+		}
+clear_uptodate:
+		ClearPageUptodate(page);
+		ClearPageError(page);
+unlock:
+		unlock_page(page);
+	}
 }
 #endif
 
-- 
2.20.1

