Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F471B3E7B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgDVK12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbgDVK11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5704720784;
        Wed, 22 Apr 2020 10:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551246;
        bh=YLXBwgw3/Lm1c+qH8DOQy+FDCzjJEKmau8CPH+MDC5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRas+j1xWW9Z0ESdMm2hnems7LBQ9WGzyFg09Hjr9oZArzVJtiet0Kv1U4VE6xMvB
         O6IBXbojVjFP0pPs2rkkMi4DicKsdAXPPw6T3mY7/DRI2Sqwf03CTxu8amEqrkWg6O
         0826RJ1JQtnlHBxgtVRnBirTleWfbbYytvrezClo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 118/166] f2fs: fix NULL pointer dereference in f2fs_verity_work()
Date:   Wed, 22 Apr 2020 11:57:25 +0200
Message-Id: <20200422095101.310801277@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



