Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8241F61F9
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 08:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgFKG7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 02:59:55 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:34906 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgFKG7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 02:59:55 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 05B6xQtP016931; Thu, 11 Jun 2020 15:59:27 +0900
X-Iguazu-Qid: 34triqBKRwjd6RHxUm
X-Iguazu-QSIG: v=2; s=0; t=1591858766; q=34triqBKRwjd6RHxUm; m=70Ngrk9bJygCOCx7/tcZyBeiJApGNrIPfiCfQtVfhws=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 05B6xPlI038625;
        Thu, 11 Jun 2020 15:59:25 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 05B6xPoW013486;
        Thu, 11 Jun 2020 15:59:25 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 05B6xOpx008601;
        Thu, 11 Jun 2020 15:59:24 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4 and 4.9] scsi: return correct blkprep status code in case scsi_init_io() fails.
Date:   Thu, 11 Jun 2020 15:59:21 +0900
X-TSB-HOP: ON
Message-Id: <20200611065921.3619813-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <jthumshirn@suse.de>

commit e7661a8e5ce10b5321882d0bbaf3f81070903319 upstream.

When instrumenting the SCSI layer to run into the
!blk_rq_nr_phys_segments(rq) case the following warning emitted from the
block layer:

blk_peek_request: bad return=-22

This happens because since commit fd3fc0b4d730 ("scsi: don't BUG_ON()
empty DMA transfers") we return the wrong error value from
scsi_prep_fn() back to the block layer.

[mkp: silenced checkpatch]

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: fd3fc0b4d730 scsi: don't BUG_ON() empty DMA transfers
Cc: <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[iwamatsu: - backport for 4.4.y and 4.9.y
    - Use rq->nr_phys_segments instead of blk_rq_nr_phys_segments]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 887045ae5d10a..269198b46adbb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1118,10 +1118,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 	bool is_mq = (rq->mq_ctx != NULL);
-	int error;
+	int error = BLKPREP_KILL;
 
 	if (WARN_ON_ONCE(!rq->nr_phys_segments))
-		return -EINVAL;
+		goto err_exit;
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
-- 
2.27.0

