Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593D3CA885
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbhGOTBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243012AbhGOTAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4910161158;
        Thu, 15 Jul 2021 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375435;
        bh=7kuPAle+KPL7uygDvyN/+ufX7FKfapEBVkAtmCuLYLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxuNr3T+oTqKtmQAvjB99+WWCkgp3E2Wqyh4nWY4iPp9EIpIWW4HjagSdIJLh46Z+
         v7uShLNgjEZPyKuJxLJSAsHtg3cnouWnRQnJ5X/vd1KqM80JdaU3Vr7TOhkRF+qIF7
         JuVtLMfQuDk26OftVA7PwH045IyqcZccfkx5QGbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 086/242] dm writecache: commit just one block, not a full page
Date:   Thu, 15 Jul 2021 20:37:28 +0200
Message-Id: <20210715182608.164155579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



