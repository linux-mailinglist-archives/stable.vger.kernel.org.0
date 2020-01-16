Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C4513FDA5
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390225AbgAPX1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390267AbgAPX1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A066B2072E;
        Thu, 16 Jan 2020 23:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217255;
        bh=2slIPSeN0K9COdPi9pHFU+IzZRcSjCu1x7KhCyX6gMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l418/EnECoOQeNJBryjRavVU3r8TUpZWpS7NX1F9LjZ/Zru4611wzNJGYoScEepWW
         33ZPLt8TNFFwS5Uw4z608/+OPj0FwhKuAGPPHPMGUf2qSmfnOiX1F4YG1eNF3ARB5Q
         C8l1piM8eRwhoMjstcWwQTbdF3yVIF3mEZZfku+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/203] scsi: target/iblock: Fix protection error with blocks greater than 512B
Date:   Fri, 17 Jan 2020 00:18:20 +0100
Message-Id: <20200116231800.360412824@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



