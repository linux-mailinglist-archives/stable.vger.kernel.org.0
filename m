Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBC1214C3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbfLPSOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbfLPSOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A139B20674;
        Mon, 16 Dec 2019 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520079;
        bh=KG4apQZSbOMfSR+kWEy2u1L5wam7uCLN9MkPUJMk7H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQPV7yQACAZrz0kFh8ErirvThtxCnC/Vr2zibjF5nx4Af9WrT77NCFKo7lfhKT61C
         uOZaG50xj5ti26dXn11bI06WCMaysnSkDU0YsV52qd2oeEKjovZUZGP0ZRBSP/Tt3T
         Uc/l/daKxIKhR2lyFYgWQuj3PRjU/0378wxzLK2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 157/180] scsi: qla2xxx: Fix a dma_pool_free() call
Date:   Mon, 16 Dec 2019 18:49:57 +0100
Message-Id: <20191216174845.422262927@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 162b805e38327135168cb0938bd37b131b481cb0 ]

This patch fixes the following kernel warning:

DMA-API: qla2xxx 0000:00:0a.0: device driver frees DMA memory with different size [device address=0x00000000c7b60000] [map size=4088 bytes] [unmap size=512 bytes]
WARNING: CPU: 3 PID: 1122 at kernel/dma/debug.c:1021 check_unmap+0x4d0/0xbd0
CPU: 3 PID: 1122 Comm: rmmod Tainted: G           O      5.4.0-rc1-dbg+ #1
RIP: 0010:check_unmap+0x4d0/0xbd0
Call Trace:
 debug_dma_free_coherent+0x123/0x173
 dma_free_attrs+0x76/0xe0
 qla2x00_mem_free+0x329/0xc40 [qla2xxx_scst]
 qla2x00_free_device+0x170/0x1c0 [qla2xxx_scst]
 qla2x00_remove_one+0x4f0/0x6d0 [qla2xxx_scst]
 pci_device_remove+0xd5/0x1f0
 device_release_driver_internal+0x159/0x280
 driver_detach+0x8b/0xf2
 bus_remove_driver+0x9a/0x15a
 driver_unregister+0x51/0x70
 pci_unregister_driver+0x2d/0x130
 qla2x00_module_exit+0x1c/0xbc [qla2xxx_scst]
 __x64_sys_delete_module+0x22a/0x300
 do_syscall_64+0x6f/0x2e0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 3f006ac342c0 ("scsi: qla2xxx: Secure flash update support for ISP28XX") # v5.2-rc1~130^2~270.
Cc: Michael Hernandez <mhernandez@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Link: https://lore.kernel.org/r/20191106044226.5207-3-bvanassche@acm.org
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d2e7a4e7b3a9a..6be453985a12d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4703,7 +4703,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->sfp_data = NULL;
 
 	if (ha->flt)
-		dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+		dma_free_coherent(&ha->pdev->dev,
+		    sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 		    ha->flt, ha->flt_dma);
 	ha->flt = NULL;
 	ha->flt_dma = 0;
-- 
2.20.1



