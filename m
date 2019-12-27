Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB4F12B947
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfL0SDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfL0SD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCCB222C4;
        Fri, 27 Dec 2019 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469805;
        bh=EP0SVqUmoXOJjI5gUdiDY42SwakQbyZ3BQJ4zWKpusA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tm7JIXfaHPzb5Nca+J12/8wLzLy9oOjJlgeYlEnTb9hzdIGQzRcOa6gbuTMZFOZ+F
         lfFKYs0Rq6obxe3C1C2XPiUlww6+pbAmKGyDLA+XRMyvNprTImQH5d7hnNLjZXpBxk
         O/iGob/l90IYLK2SokdXVZMFWQDDDEMUOz7L7Fwc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Bob Liu <bob.liu@oracle.com>, Hulk Robot <hulkci@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 52/57] block: fix memleak when __blk_rq_map_user_iov() is failed
Date:   Fri, 27 Dec 2019 13:02:17 -0500
Message-Id: <20191227180222.7076-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e31be14da8ea..f72a3af689b6 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -152,7 +152,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	return 0;
 
 unmap_rq:
-	__blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(bio);
 fail:
 	rq->bio = NULL;
 	return ret;
-- 
2.20.1

