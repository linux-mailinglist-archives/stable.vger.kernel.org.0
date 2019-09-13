Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31923B2045
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389236AbfIMNTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbfIMNTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:11 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DE49214AF;
        Fri, 13 Sep 2019 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380750;
        bh=joqP4UPsxJsKY/fSN5L/+qTrTQya/sOM+fIw1lI6Sb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=See6shaCzQ8a7tL/b+GzOUpqwZG8dmjpkSicBpntBXnWTxuBJ8Pu7Bi4YSJ8f6tWw
         8MjWDJ79FkHxDmAaJfdnE/PT4vA8KlnM8eVhjz8db6tT5jpeP8Rtai+mi6NcuxdxCf
         /1WyhHibxSgu4EYNnYrcoIPx1k0pPDeU20HlbTx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <mchristi@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/190] scsi: target/core: Use the SECTOR_SHIFT constant
Date:   Fri, 13 Sep 2019 14:06:40 +0100
Message-Id: <20190913130611.554063064@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80b045b385cfef10939c913fbfeb19ce5491c1f2 ]

Instead of duplicating the SECTOR_SHIFT definition from <linux/blkdev.h>,
use it. This patch does not change any functionality.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 4 ++--
 drivers/target/target_core_iblock.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a5cb7bf..1bc9b14236d8b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -514,7 +514,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		}
 
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> SECTOR_SHIFT;
 		sectors -= 1;
 	}
 
@@ -757,7 +757,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		}
 
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> SECTOR_SHIFT;
 		sg_num--;
 	}
 
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 9cc3843404d44..cefc641145b3b 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -9,7 +9,6 @@
 #define IBLOCK_VERSION		"4.0"
 
 #define IBLOCK_MAX_CDBS		16
-#define IBLOCK_LBA_SHIFT	9
 
 struct iblock_req {
 	refcount_t pending;
-- 
2.20.1



