Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F391676AD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgBUIE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbgBUIEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 093A824670;
        Fri, 21 Feb 2020 08:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272293;
        bh=No7J9OL8KUJxRovcUMMeH87OibVs7K4ofQVzEkaV8HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lX9crHXvrL+Qd2fCNBlVpI2pUT7mhfJwkTXcyepvrDnwg2nL08jzcIaNUDk5CSRrK
         +rQMk6b8SctovdFIQ/x70EhoRgACoKyGkgFRCIfPULVAhQXPopK/t+zbJehN0puKjw
         qsyt5l8f+3MIosm6yClMZK1ePY/KKHaT/Z8NLZeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/344] drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store
Date:   Fri, 21 Feb 2020 08:38:07 +0100
Message-Id: <20200221072356.961363320@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 3b82a051c10143639a378dcd12019f2353cc9054 ]

Currently when an error code -EIO or -ENOSPC in the for-loop of
writeback_store the error code is being overwritten by a ret = len
assignment at the end of the function and the error codes are being
lost.  Fix this by assigning ret = len at the start of the function and
remove the assignment from the end, hence allowing ret to be preserved
when error codes are assigned to it.

Addresses Coverity ("Unused value")

Link: http://lkml.kernel.org/r/20191128122958.178290-1-colin.king@canonical.com
Fixes: a939888ec38b ("zram: support idle/huge page writeback")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4285e75e52c34..1bf4a908a0bd9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -626,7 +626,7 @@ static ssize_t writeback_store(struct device *dev,
 	struct bio bio;
 	struct bio_vec bio_vec;
 	struct page *page;
-	ssize_t ret;
+	ssize_t ret = len;
 	int mode;
 	unsigned long blk_idx = 0;
 
@@ -762,7 +762,6 @@ next:
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-	ret = len;
 	__free_page(page);
 release_init_lock:
 	up_read(&zram->init_lock);
-- 
2.20.1



