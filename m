Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296EF1300AF
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 04:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgADDhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 22:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgADDg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A48724654;
        Sat,  4 Jan 2020 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578108987;
        bh=2slIPSeN0K9COdPi9pHFU+IzZRcSjCu1x7KhCyX6gMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pBSI/1slPvSQpoMUlCS/zSmbrMysXbaylwHluKi6asggKFNoDJJGaZCI2tOmSTtb
         u2zehEsUmIO9ghB9JWiUjxlVXidqo1aUnwhTYyq3pQzrSYAu8nBpdFeH1GejhdnnZn
         QIxwczKX9nklA6IZsFwqVYG+uKviwsEPiei08Eec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/10] scsi: target/iblock: Fix protection error with blocks greater than 512B
Date:   Fri,  3 Jan 2020 22:36:14 -0500
Message-Id: <20200104033620.10977-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033620.10977-1-sashal@kernel.org>
References: <20200104033620.10977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

[ Upstream commit e4dc9a4c31fe10d1751c542702afc85be8a5c56a ]

The sector size of the block layer is 512 bytes, but integrity interval
size might be different (in case of 4K block size of the media). At the
initiator side the virtual start sector is the one that was originally
submitted by the block layer (512 bytes) for the Reftag usage. The
initiator converts the Reftag to integrity interval units and sends it to
the target. So the target virtual start sector should be calculated at
integrity interval units. prepare_fn() and complete_fn() don't remap
correctly the Reftag when using incorrect units of the virtual start
sector, which leads to the following protection error at the device:

"blk_update_request: protection error, dev sdb, sector 2048 op 0x0:(READ)
flags 0x10000 phys_seg 1 prio class 0"

To fix that, set the seed in integrity interval units.

Link: https://lore.kernel.org/r/1576078562-15240-1-git-send-email-israelr@mellanox.com
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 6949ea8bc387..51ffd5c002de 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -646,7 +646,9 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 	}
 
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	/* virtual start sector must be in integrity interval units */
+	bip_set_seed(bip, bio->bi_iter.bi_sector >>
+				  (bi->interval_exp - SECTOR_SHIFT));
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
-- 
2.20.1

