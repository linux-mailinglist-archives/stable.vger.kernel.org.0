Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7666291DA5
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgJRTqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbgJRTWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7D8222E7;
        Sun, 18 Oct 2020 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048955;
        bh=CABQCfiIlkUUv1ROXKZhVMXVjel4c7ecedP+9uIvzSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVwrnsLPIZ+H23ihLQOoSvsE+WlycDO+gLIXLtHqv5J5MtEkIuWiHaiCDiTBP1d9v
         J0lZM5EWff8AgrL52BKcCIrnx4GNn3+ywN+XKB1K81eiAQzAJJNU5nvcNJ20LshWxA
         Rs/FVExzKSurt+PJKQn6F34P9x+eGehtLWqpQ3bI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/80] block: ratelimit handle_bad_sector() message
Date:   Sun, 18 Oct 2020 15:21:13 -0400
Message-Id: <20201018192231.4054535-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d ]

syzbot is reporting unkillable task [1], for the caller is failing to
handle a corrupted filesystem image which attempts to access beyond
the end of the device. While we need to fix the caller, flooding the
console with handle_bad_sector() message is unlikely useful.

[1] https://syzkaller.appspot.com/bug?id=f1f49fb971d7a3e01bd8ab8cff2ff4572ccf3092

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 81aafb601df06..d2213220099d3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -743,11 +743,10 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
 {
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
-			bio_devname(bio, b), bio->bi_opf,
-			(unsigned long long)bio_end_sector(bio),
-			(long long)maxsector);
+	pr_info_ratelimited("attempt to access beyond end of device\n"
+			    "%s: rw=%d, want=%llu, limit=%llu\n",
+			    bio_devname(bio, b), bio->bi_opf,
+			    bio_end_sector(bio), maxsector);
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-- 
2.25.1

