Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD6371A60
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhECQjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhECQiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B801D613B4;
        Mon,  3 May 2021 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059810;
        bh=VYpGy6PzM/2K9DyLJkpuC5cD1ZlTLPn8f2CdeK1PYbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gubGgq3U/Fh63jBSeU70/Uc/i3/tSPNWYLlMlj8QHb1SvmGCapisdmPPszyM3GLm9
         ZzomR/HxbySqRo7Xp/t0ncH2CgLM/AuEetFHwOYNG4tjAbOXxr198sSLVjav7V3EM9
         2FakRVE3pD744uKgdmbu0fwiXx7Ixn1C49Fggac2k4yMMipEWBg2i4PHD8Nkm/IEG3
         17iw4TH3exhUgyjos02bwaunx/yvbDeBeLBT0gDZcgXbrtaWps/XEoAG6rQqGJC0Wq
         Ys46Y6FCmdZ6j4pt5K9VbzTFWGiHtfsP4fb6WHtFpSnWqHzrEGNQ4bF8FEimMz9le9
         jj7uwnckcjkEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 062/134] scsi: qla2xxx: Fix use after free in bsg
Date:   Mon,  3 May 2021 12:34:01 -0400
Message-Id: <20210503163513.2851510-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 2ce35c0821afc2acd5ee1c3f60d149f8b2520ce8 ]

On bsg command completion, bsg_job_done() was called while qla driver
continued to access the bsg_job buffer. bsg_job_done() would free up
resources that ended up being reused by other task while the driver
continued to access the buffers. As a result, driver was reading garbage
data.

localhost kernel: BUG: KASAN: use-after-free in sg_next+0x64/0x80
localhost kernel: Read of size 8 at addr ffff8883228a3330 by task swapper/26/0
localhost kernel:
localhost kernel: CPU: 26 PID: 0 Comm: swapper/26 Kdump:
loaded Tainted: G          OE    --------- -  - 4.18.0-193.el8.x86_64+debug #1
localhost kernel: Hardware name: HP ProLiant DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 08/12/2016
localhost kernel: Call Trace:
localhost kernel: <IRQ>
localhost kernel: dump_stack+0x9a/0xf0
localhost kernel: print_address_description.cold.3+0x9/0x23b
localhost kernel: kasan_report.cold.4+0x65/0x95
localhost kernel: debug_dma_unmap_sg.part.12+0x10d/0x2d0
localhost kernel: qla2x00_bsg_sp_free+0xaf6/0x1010 [qla2xxx]

Link: https://lore.kernel.org/r/20210329085229.4367-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index bee8cf9f8123..d021e51344f5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -25,10 +25,11 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
+	sp->free(sp);
+
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-	sp->free(sp);
 }
 
 void qla2x00_bsg_sp_free(srb_t *sp)
-- 
2.30.2

