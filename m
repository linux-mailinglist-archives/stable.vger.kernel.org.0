Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD3E4E73
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436642AbfJYOHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502362AbfJYNzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CC821D81;
        Fri, 25 Oct 2019 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011732;
        bh=0meya3MA2lOI1CtkbdB1xT+Fow3FlBRZRoOpoYC2tGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvImXxN/rEO3FEDo4W2/oXdgjFoX8LhWLhE7EmK1oGGrwqrxV/D2ztznAi7vAowmq
         MYETiI02tmxffPSlUmF8fJUPzw/iKh99dZ9v8JlBFRFugGAHKg9JXH3Rsm8beU0Fmf
         eXYTQIbp6QLiTFGjyVnLN0vWHi90/SJU617ZVI4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 14/33] scsi: qla2xxx: Fix different size DMA Alloc/Unmap
Date:   Fri, 25 Oct 2019 09:54:46 -0400
Message-Id: <20191025135505.24762-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit d376dbda187317d06d3a2d495b43a7983e4a3250 ]

[   17.177276] qla2xxx 0000:05:00.0: DMA-API: device driver frees DMA memory
    with different size [device address=0x00000006198b0000] [map size=32784 bytes]
    [unmap size=8208 bytes]
[   17.177390] RIP: 0010:check_unmap+0x7a2/0x1750
[   17.177425] Call Trace:
[   17.177438]  debug_dma_free_coherent+0x1b5/0x2d5
[   17.177470]  dma_free_attrs+0x7f/0x140
[   17.177489]  qla24xx_sp_unmap+0x1e2/0x610 [qla2xxx]
[   17.177509]  qla24xx_async_gnnft_done+0x9c6/0x17d0 [qla2xxx]
[   17.177535]  qla2x00_do_work+0x514/0x2200 [qla2xxx]

Fixes: b5f3bc39a0e8 ("scsi: qla2xxx: Fix inconsistent DMA mem alloc/free")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 9f58e591666da..ebf223cfebbc5 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4152,7 +4152,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 								rspsz,
 								&sp->u.iocb_cmd.u.ctarg.rsp_dma,
 								GFP_KERNEL);
-		sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
+		sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = rspsz;
 		if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Failed to allocate ct_sns request.\n");
-- 
2.20.1

