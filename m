Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D22E1F6BAF
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFKP4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:56:55 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:40346 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgFKP4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:56:55 -0400
Received: from moto.blr.asicdesigners.com (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05BFrs76005517;
        Thu, 11 Jun 2020 08:55:30 -0700
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Cc:     stable@vger.kernel.org, nirranjan@chelsio.com, bharat@chelsio.com,
        dakshaja@chelsio.com, Logan Gunthorpe <logang@deltatee.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-stable nvmet 3/6] nvmet: Introduce nvmet_dsm_len() helper
Date:   Thu, 11 Jun 2020 21:23:36 +0530
Message-Id: <20200611155339.9429-4-dakshaja@chelsio.com>
X-Mailer: git-send-email 2.18.0.232.gb7bd9486b.dirty
In-Reply-To: <20200611155339.9429-1-dakshaja@chelsio.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to the nvmet_rw_len helper.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[split patch, update changelog]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/target/io-cmd-file.c | 3 +--
 drivers/nvme/target/nvmet.h       | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 05453f5d1448..7481556da6e6 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -379,8 +379,7 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_cmd_dsm:
 		req->execute = nvmet_file_execute_dsm;
-		req->data_len = (le32_to_cpu(cmd->dsm.nr) + 1) *
-			sizeof(struct nvme_dsm_range);
+		req->data_len = nvmet_dsm_len(req);
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c51f8dd01dc4..6ccf2d098d9f 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -495,6 +495,12 @@ static inline u32 nvmet_rw_len(struct nvmet_req *req)
 			req->ns->blksize_shift;
 }
 
+static inline u32 nvmet_dsm_len(struct nvmet_req *req)
+{
+	return (le32_to_cpu(req->cmd->dsm.nr) + 1) *
+		sizeof(struct nvme_dsm_range);
+}
+
 u16 errno_to_nvme_status(struct nvmet_req *req, int errno);
 
 /* Convert a 32-bit number to a 16-bit 0's based number */
-- 
2.18.0.232.gb7bd9486b.dirty

