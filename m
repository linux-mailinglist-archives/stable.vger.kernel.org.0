Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F883BCFE1
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhGFLbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234843AbhGFL3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C08D861D67;
        Tue,  6 Jul 2021 11:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570428;
        bh=7kuPAle+KPL7uygDvyN/+ufX7FKfapEBVkAtmCuLYLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lyo0MrxY0RTb7ZtygqOmeoohaztIXFgFCW6DVG+AQHQJID+R4us3K4xMKOezDxEVZ
         1QqIzqJPOf+qEFgcHDsS/7coa7ByvZntfGYjnUPp9axlhNhk53FKDq4SvSzlGL+orq
         Op6zQX2vrFeaAORNMvfo0v2UKT+4iMxmyf710d3Qs/gq9L8War/ovKOIf+myP+EspB
         BWeb9WKMDqoPW+qgdHkOVGSU+ZOrYo98tqIbq3Px55DPmn4yDEyPGwQOCiU3RIcSXQ
         FeGJd761wsO9Y1FAYdIdUODbgASrF/TgKo8qEtia+vFdeUfaAn/8O+ILPlhgcvABlU
         jeCpBHA5hidHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 091/160] dm writecache: commit just one block, not a full page
Date:   Tue,  6 Jul 2021 07:17:17 -0400
Message-Id: <20210706111827.2060499-91-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 7bb4d83e90cc..51b26db56ba9 100644
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

