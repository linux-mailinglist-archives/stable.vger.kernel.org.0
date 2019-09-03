Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0BA6F25
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbfICQ2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbfICQ2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF87238C7;
        Tue,  3 Sep 2019 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528128;
        bh=D53RVInm+WvjnzHlUjJv9yLcH4RX6DkgvOJfq7/ArCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOZSL76gW/ADx9vfCyRlB9cZsHKYAvm4Wd+j/U8ikyWIVZ03k+i/1PcJjmLiMVc9w
         Svxi4yUO4DZmzwi16A6FWk3qtUPxu+/RolhlUysvCPaTWpV2omhoxlQYP+mY2H5hwx
         x8RWMcTKBut5s9kOoc4oyGNLZesJuGDrjO7tRspo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <mchristi@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 124/167] scsi: target/core: Use the SECTOR_SHIFT constant
Date:   Tue,  3 Sep 2019 12:24:36 -0400
Message-Id: <20190903162519.7136-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

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

