Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D95F7C81
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfKKSq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbfKKSq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9560520659;
        Mon, 11 Nov 2019 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498015;
        bh=x4KlDONvL5gFLEFToGLSxDIpUpyTrEGcLppi2wf6V8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7BOR1OvHuywYlvtZ6ty8cyoGs7q/Z8bQqOXOz5sVzgtNVbHii9UW2nYD/uv5amfQ
         C2wOK6TB+krvM8L18N2YhwduFvk4NWubdXUQBjhKKL4KY4VbtQ9G+yARFg0IVNRTvl
         bsTbj7JR+17PMV/gUa2Bo4Ci//WVdaXsVzrfxwlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/125] scsi: qla2xxx: Initialized mailbox to prevent driver load failure
Date:   Mon, 11 Nov 2019 19:28:42 +0100
Message-Id: <20191111181451.235535193@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit c2ff2a36eff60efb5e123c940115216d6bf65684 ]

This patch fixes issue with Gen7 adapter in a blade environment where one
of the ports will not be detected by driver. Firmware expects mailbox 11 to
be set or cleared by driver for newer ISP.

Following message is seen in the log file:

[   18.810892] qla2xxx [0000:d8:00.0]-1820:1: **** Failed=102 mb[0]=4005 mb[1]=37 mb[2]=20 mb[3]=8
[   18.819596]  cmd=2 ****

[mkp: typos]

Link: https://lore.kernel.org/r/20191022193643.7076-2-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 84f57f075455e..128fcff24f1be 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -684,6 +684,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
 		mcp->mb[4] = 0;
+		mcp->mb[11] = 0;
 		ha->flags.using_lr_setting = 0;
 		if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
 		    IS_QLA27XX(ha)) {
@@ -727,7 +728,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		if (ha->flags.exchoffld_enabled)
 			mcp->mb[4] |= ENABLE_EXCHANGE_OFFLD;
 
-		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
+		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
 		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
-- 
2.20.1



