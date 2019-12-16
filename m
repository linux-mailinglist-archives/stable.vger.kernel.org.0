Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D08121496
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbfLPSMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbfLPSMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E304206E0;
        Mon, 16 Dec 2019 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519962;
        bh=0meya3MA2lOI1CtkbdB1xT+Fow3FlBRZRoOpoYC2tGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwmqZRPUEY0kOsdcaBOoKpF3uVGwvN2UZr7WgFJ2CfKGwhonMSoy60IA27pVwQ8+E
         ES5PWU1rVsFpoq6bwAzxe+goCa2ZesqxlVSGvXTYCHW5wjlM0vhntX21rC/piXDC+N
         Q5WtZUFgEHK7aRE2XscdvFQhVvjZQqrd9B0qN5Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 140/180] scsi: qla2xxx: Fix different size DMA Alloc/Unmap
Date:   Mon, 16 Dec 2019 18:49:40 +0100
Message-Id: <20191216174842.923126364@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



