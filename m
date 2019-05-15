Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4D1F29C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfEOLKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbfEOLKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4FA20862;
        Wed, 15 May 2019 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918640;
        bh=4zGOH3kUeL7q/pBY1L51HmZM4skf81Nbg+oZY+DgeRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7pkXU2VBi97GLwic5yV5gXx60FFgr3PjouLxRhVSMKthUJR9OZSYhhd4dwmKS/WW
         v3cY326QaXXtnITgyFdtjUjYATLiRlNYVnbW5jNib5U+kNBOC9UQXlyH9rk2vz+9Qv
         WF41V5961PP300zSCs35dHoVfluN4p+IV/2vFxAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 166/266] s390/dasd: Fix capacity calculation for large volumes
Date:   Wed, 15 May 2019 12:54:33 +0200
Message-Id: <20190515090728.535604646@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2cc9637ce825f3a9f51f8f78af7474e9e85bfa5f ]

The DASD driver incorrectly limits the maximum number of blocks of ECKD
DASD volumes to 32 bit numbers. Volumes with a capacity greater than
2^32-1 blocks are incorrectly recognized as smaller volumes.

This results in the following volume capacity limits depending on the
formatted block size:

  BLKSIZE  MAX_GB   MAX_CYL
      512    2047   5843492
     1024    4095   8676701
     2048    8191  13634816
     4096   16383  23860929

The same problem occurs when a volume with more than 17895697 cylinders
is accessed in raw-track-access mode.

Fix this problem by adding an explicit type cast when calculating the
maximum number of blocks.

Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 80a43074c2f9a..c530610f61ac9 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2066,14 +2066,14 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
 	blk_per_trk = recs_per_track(&private->rdc_data, 0, block->bp_block);
 
 raw:
-	block->blocks = (private->real_cyl *
+	block->blocks = ((unsigned long) private->real_cyl *
 			  private->rdc_data.trk_per_cyl *
 			  blk_per_trk);
 
 	dev_info(&device->cdev->dev,
-		 "DASD with %d KB/block, %d KB total size, %d KB/track, "
+		 "DASD with %u KB/block, %lu KB total size, %u KB/track, "
 		 "%s\n", (block->bp_block >> 10),
-		 ((private->real_cyl *
+		 (((unsigned long) private->real_cyl *
 		   private->rdc_data.trk_per_cyl *
 		   blk_per_trk * (block->bp_block >> 9)) >> 1),
 		 ((blk_per_trk * block->bp_block) >> 10),
-- 
2.20.1



