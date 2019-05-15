Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2F1F07C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfEOL0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfEOL0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1D420818;
        Wed, 15 May 2019 11:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919593;
        bh=iZAie2W+rzg4FGdoNL38HQHKFa6Z3pHS17qji7jKVeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3N3OEwiU5uV53IktewQHy0WmcJhWik6zDOYTyRt+m2Y87EQRU+dsgBwwigtH3Xg7
         lW6gGg+ptrImwa1lqc0AB6NNOI46iV/FVoGrO22dSIE9oCQcDcn9dii9kHnKPmebTz
         DPsvzybfA7SOQEfVQ9UN+OjH8Uaj6FJ+UI1FsXQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 020/137] s390/dasd: Fix capacity calculation for large volumes
Date:   Wed, 15 May 2019 12:55:01 +0200
Message-Id: <20190515090654.743686696@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
index 6e294b4d3635f..f89f9d02e7884 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2004,14 +2004,14 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
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



