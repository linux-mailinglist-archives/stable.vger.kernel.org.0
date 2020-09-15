Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249C926B529
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgIOXhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E4C722251;
        Tue, 15 Sep 2020 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179961;
        bh=6NSy2pIonR2e56WLHfYsbwetHNDqFjMwPKSrA+RUqdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnYOdJvpQYIqBAfhSf7kgmat01r/1S5Z/aZTjB5thWBNjFz/Mv9op52c5jSNe3/Uf
         sbeN7vXgSrFlzBv3XtY2yrm4M7gOJhlz8veC45oJQEqzRbe0Q0x/+01ltafUv0VO6w
         ilpBFBVhwQbjgzGet9AIuuj4D0RgD3l/hSir2GH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 052/177] block: Set same_page to false in __bio_try_merge_page if ret is false
Date:   Tue, 15 Sep 2020 16:12:03 +0200
Message-Id: <20200915140656.125910879@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit 2cd896a5e86fc326bda8614b96c0401dcc145868 ]

If we hit the UINT_MAX limit of bio->bi_iter.bi_size and so we are anyway
not merging this page in this bio, then it make sense to make same_page
also as false before returning.

Without this patch, we hit below WARNING in iomap.
This mostly happens with very large memory system and / or after tweaking
vm dirty threshold params to delay writeback of dirty data.

WARNING: CPU: 18 PID: 5130 at fs/iomap/buffered-io.c:74 iomap_page_release+0x120/0x150
 CPU: 18 PID: 5130 Comm: fio Kdump: loaded Tainted: G        W         5.8.0-rc3 #6
 Call Trace:
  __remove_mapping+0x154/0x320 (unreliable)
  iomap_releasepage+0x80/0x180
  try_to_release_page+0x94/0xe0
  invalidate_inode_page+0xc8/0x110
  invalidate_mapping_pages+0x1dc/0x540
  generic_fadvise+0x3c8/0x450
  xfs_file_fadvise+0x2c/0xe0 [xfs]
  vfs_fadvise+0x3c/0x60
  ksys_fadvise64_64+0x68/0xe0
  sys_fadvise64+0x28/0x40
  system_call_exception+0xf8/0x1c0
  system_call_common+0xf0/0x278

Fixes: cc90bc68422 ("block: fix "check bi_size overflow before merge"")
Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b1883adc8f154..eac129f21d2df 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -877,8 +877,10 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page_is_mergeable(bv, page, len, off, same_page)) {
-			if (bio->bi_iter.bi_size > UINT_MAX - len)
+			if (bio->bi_iter.bi_size > UINT_MAX - len) {
+				*same_page = false;
 				return false;
+			}
 			bv->bv_len += len;
 			bio->bi_iter.bi_size += len;
 			return true;
-- 
2.25.1



