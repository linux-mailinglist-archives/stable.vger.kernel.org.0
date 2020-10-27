Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470FA29BE45
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794528AbgJ0PMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794521AbgJ0PMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:12:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC9F22202;
        Tue, 27 Oct 2020 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811534;
        bh=gBG8HRmTkIY7Xdd2tBhde16tVJEDMwdYi/078A6T8sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktW8Dr22aO8PO5hsPTdxvP7NTJSCRnYk9+FxidTBdiXR9DdT+hS8nB2Bm9ya5+osF
         lKsaZRQopFs3/7tWN6ytwhTSwWtLUsJ5/dYebauogXAtgxQNbZIhhc8sP5NKZBrJJO
         peIpS3crR1KzLLQeQWMYvyiIoZFyRCFipU7Mp6lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 528/633] block: ratelimit handle_bad_sector() message
Date:   Tue, 27 Oct 2020 14:54:31 +0100
Message-Id: <20201027135547.548187986@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 619a3dcd3f5e7..8d6435b731186 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -798,11 +798,10 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
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



