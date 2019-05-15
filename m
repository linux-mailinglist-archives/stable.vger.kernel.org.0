Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400091F3D1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfEOLAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfEOLAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E638020881;
        Wed, 15 May 2019 11:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918032;
        bh=Rgk/QmC5wuH4m2huAqS/Q36BitkKH5LjgBwJaV2cB7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdAl6cN7ddlnGbcvraY2uFYGde9E53Iysc5YEPFuYNVNEjybliefSr0qvWubJHSDc
         MRvSYCoaMIitpk7SvxVVg3fwF136b9AUzxeVAo7sMiv5ayJggQayICWPhSkPZOqUzr
         aeQXxOSqbEeFnKbAdNuQhmd7+k5FljAQ2d7a4ScM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 3.18 67/86] s390/dasd: Fix capacity calculation for large volumes
Date:   Wed, 15 May 2019 12:55:44 +0200
Message-Id: <20190515090654.762720869@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
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
index 4bbcdf991c262..4856e5bbb42fa 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2031,14 +2031,14 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
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



