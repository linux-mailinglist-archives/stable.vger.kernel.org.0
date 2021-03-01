Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480213289AE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbhCASDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237824AbhCAR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2566665074;
        Mon,  1 Mar 2021 17:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619497;
        bh=i8GrjKi5S2CmDKUeGWQRsVZoGcpllGlvwHk/OpVVssM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxLiucbfGfIt41nCXhnIOZxRmXBeaQx8lMBTf11Q2+Kdeo1D6rh5u0TYJWPGNzK11
         Q8zrVbhWT2QSQlDc+lRJ/ix5SmrU/WMhnk7o1gMrThvB/WIts/npt96IYo+m5YB0Do
         Yi7rID/k24xQnDec1s4w0VNDhwvg0UZtDJ9i7XPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/663] scsi: sd: sd_zbc: Dont pass GFP_NOIO to kvcalloc
Date:   Mon,  1 Mar 2021 17:12:03 +0100
Message-Id: <20210301161205.360740951@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 9acced3f58ad24407c1f9ebf53a8892c1e24cdb5 ]

Dan reported we're passing in GFP_NOIO to kvmalloc() which will then
fallback to doing kmalloc() instead of an optional vmalloc() if the size
exceeds kmalloc()s limits. This will break with drives that have zone
numbers exceeding PAGE_SIZE/sizeof(u32).

Instead of passing in GFP_NOIO, enter an implicit GFP_NOIO allocation
scope.

Link: https://lore.kernel.org/r/YCuvSfKw4qEQBr/t@mwanda
Link: https://lore.kernel.org/r/5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com
Fixes: 5795eb443060: ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index cf07b7f935790..87a7274e4632b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -688,6 +688,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	unsigned int nr_zones = sdkp->rev_nr_zones;
 	u32 max_append;
 	int ret = 0;
+	unsigned int flags;
 
 	/*
 	 * For all zoned disks, initialize zone append emulation data if not
@@ -720,16 +721,19 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	    disk->queue->nr_zones == nr_zones)
 		goto unlock;
 
+	flags = memalloc_noio_save();
 	sdkp->zone_blocks = zone_blocks;
 	sdkp->nr_zones = nr_zones;
-	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);
+	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
 	if (!sdkp->rev_wp_offset) {
 		ret = -ENOMEM;
+		memalloc_noio_restore(flags);
 		goto unlock;
 	}
 
 	ret = blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);
 
+	memalloc_noio_restore(flags);
 	kvfree(sdkp->rev_wp_offset);
 	sdkp->rev_wp_offset = NULL;
 
-- 
2.27.0



