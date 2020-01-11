Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF013809F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgAKKcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbgAKKcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:15 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D4B20842;
        Sat, 11 Jan 2020 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738735;
        bh=/pNFQv2QD/DPWXhFBy08OC52aO2HtxsMmpL4OcdaiMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gmi+Am1aFRgm8rCkT9AANlP01vqQ1qrNyakrhz7ki/d3EJ3ETVgmhPjbmApusYcWM
         NkbcAdLk7pjfJ9iNBenk1hJHpDB7zqAAWkTzRj3Dayl88CGGf8+3M/LMga91LAEopQ
         iyFbKmtSd9IF3+PE59e8KmNRMHW8BSpFByhegWho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Liu <bob.liu@oracle.com>,
        Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/165] block: fix memleak when __blk_rq_map_user_iov() is failed
Date:   Sat, 11 Jan 2020 10:50:47 +0100
Message-Id: <20200111094935.419708947@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3b7995a98ad76da5597b488fa84aa5a56d43b608 ]

When I doing fuzzy test, get the memleak report:

BUG: memory leak
unreferenced object 0xffff88837af80000 (size 4096):
  comm "memleak", pid 3557, jiffies 4294817681 (age 112.499s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    20 00 00 00 10 01 00 00 00 00 00 00 01 00 00 00   ...............
  backtrace:
    [<000000001c894df8>] bio_alloc_bioset+0x393/0x590
    [<000000008b139a3c>] bio_copy_user_iov+0x300/0xcd0
    [<00000000a998bd8c>] blk_rq_map_user_iov+0x2f1/0x5f0
    [<000000005ceb7f05>] blk_rq_map_user+0xf2/0x160
    [<000000006454da92>] sg_common_write.isra.21+0x1094/0x1870
    [<00000000064bb208>] sg_write.part.25+0x5d9/0x950
    [<000000004fc670f6>] sg_write+0x5f/0x8c
    [<00000000b0d05c7b>] __vfs_write+0x7c/0x100
    [<000000008e177714>] vfs_write+0x1c3/0x500
    [<0000000087d23f34>] ksys_write+0xf9/0x200
    [<000000002c8dbc9d>] do_syscall_64+0x9f/0x4f0
    [<00000000678d8e9a>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

If __blk_rq_map_user_iov() is failed in blk_rq_map_user_iov(),
the bio(s) which is allocated before this failing will leak. The
refcount of the bio(s) is init to 1 and increased to 2 by calling
bio_get(), but __blk_rq_unmap_user() only decrease it to 1, so
the bio cannot be freed. Fix it by calling blk_rq_unmap_user().

Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 3a62e471d81b..b0790268ed9d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -151,7 +151,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	return 0;
 
 unmap_rq:
-	__blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(bio);
 fail:
 	rq->bio = NULL;
 	return ret;
-- 
2.20.1



