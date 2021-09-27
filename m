Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1EC419C2D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhI0R0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237926AbhI0RYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B25E61462;
        Mon, 27 Sep 2021 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762922;
        bh=vJuvZIt93zXADDyTz1uAhwAyy8Yfo99PW8XZ+4KAF9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A852rqKdkopAiDs0LwOmJrc77RWC+QpUmycLbVV339zRcIHhLcjfZnQwvzc6nB10t
         AwSofw2EdOSPxiVkqFd8tSeH0WDrm6WsTWjR+wQo0jK68OdLFpVWvYceTOXbLidXmI
         sqrbtUuR11Wt/QVRXETX1TEVjBiGfymP79BrUIDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 102/162] scsi: sd_zbc: Support disks with more than 2**32 logical blocks
Date:   Mon, 27 Sep 2021 19:02:28 +0200
Message-Id: <20210927170236.974701564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1d479e6c9cb2b40abfb455863a4e9335db882e33 ]

This patch addresses the following Coverity report about the zno *
sdkp->zone_blocks expression:

CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
overflow_before_widen: Potentially overflowing expression zno *
sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated
using 32-bit arithmetic, and then used in a context that expects an
expression of type sector_t (64 bits, unsigned).

Link: https://lore.kernel.org/r/20210917212314.2362324-1-bvanassche@acm.org
Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ea8b3f6ee5cd..06ee1f045e97 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
 	unsigned long flags;
-	unsigned int zno;
+	sector_t zno;
 	int ret;
 
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
-- 
2.33.0



