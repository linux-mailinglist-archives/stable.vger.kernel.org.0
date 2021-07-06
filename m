Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69473BCCF9
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhGFLUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhGFLTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A6C661C5E;
        Tue,  6 Jul 2021 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570191;
        bh=cbkPRo7+rmemS45wzv8CpoNtvxdeDeakDfFzCFdruQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X93ub9wvWJzGxEC+uhYL8osz7IvtiptYnD74WTJoOvGXzHL/lojx43kwmPG448P4R
         8E4oMtXKOz1m1OZe1XTp+8whotA9HQcoWbWTOAxiqa5/al99qZFD0DRkN6BjezbKDu
         Km2t12bm1lPoxEIIQYyNjXqJolnwfyriGjlP5D8XtBVxquzGGc26aPcM/10Gn6c0p7
         btjnowAjQH+o6E30bL6gGmOxnhDvrw0VfSQ+rZvbeJNH7Hnn32dYRSOKEiLCrBm4rZ
         QaPQUNKex4fKSthHeszZ6VB/s/0Cw+EuCTr9aYNh2bvEDfeUJYFqtC69VsZ5X/zaHG
         gnvl/R1liR1Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 106/189] dm writecache: commit just one block, not a full page
Date:   Tue,  6 Jul 2021 07:12:46 -0400
Message-Id: <20210706111409.2058071-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 991bd8d7bc78966b4dc427b53a144f276bffcd52 ]

Some architectures have pages larger than 4k and committing a full
page causes needless overhead.

Fix this by writing a single block when committing the superblock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index a44007297e63..0e3a6c4bd5e3 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -532,11 +532,7 @@ static void ssd_commit_superblock(struct dm_writecache *wc)
 
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
-	region.count = PAGE_SIZE >> SECTOR_SHIFT;
-
-	if (unlikely(region.sector + region.count > wc->metadata_sectors))
-		region.count = wc->metadata_sectors - region.sector;
-
+	region.count = wc->block_size >> SECTOR_SHIFT;
 	region.sector += wc->start_sector;
 
 	req.bi_op = REQ_OP_WRITE;
-- 
2.30.2

