Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB43CAA5B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241893AbhGOTND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243958AbhGOTK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27176601FE;
        Thu, 15 Jul 2021 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376040;
        bh=cbkPRo7+rmemS45wzv8CpoNtvxdeDeakDfFzCFdruQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX9zF+WhLzDTsGZGbwat+TDdjtbRmiQoAxMX5HQ1RTWQ04E910mKJf0QTV9Dal9+4
         ljozfpiSKNKdLxW4hHgI23OeusNoWu2ZBqkoqz0JbJxq4DVoIK2NJRCOMRigX6euYa
         odOSygQAE4GaO2R/SWvxnWENU6gmZ2asS2Wci9w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 100/266] dm writecache: commit just one block, not a full page
Date:   Thu, 15 Jul 2021 20:37:35 +0200
Message-Id: <20210715182631.681005995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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



