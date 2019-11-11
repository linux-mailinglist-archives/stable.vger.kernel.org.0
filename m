Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B45F7DF0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfKKSxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfKKSxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04D921783;
        Mon, 11 Nov 2019 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498433;
        bh=tkG/7XE93bwOWzGz6iLk765b1fbL6BXtghTwdX2w60A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdVEXvXg29R72HxDBMl1YZsDEbig63kq9l4BWj3EMCN27HNmokDCx+z8v4lbnuyp0
         izsKQRFnRk6qgqbdZVcsBb2SQkG2mpz4rRXLnA3Z23i/sDmfgHYKyURWGigp2EDpR1
         1gxUMqRXdTbtk0OJ1DONCdMOwl/YGD4TSoWX63MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 119/193] scsi: qla2xxx: Initialized mailbox to prevent driver load failure
Date:   Mon, 11 Nov 2019 19:28:21 +0100
Message-Id: <20191111181509.947823219@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
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
index abfb9c800ce28..ac4640f456786 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -710,6 +710,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
 		mcp->mb[4] = 0;
+		mcp->mb[11] = 0;
 		ha->flags.using_lr_setting = 0;
 		if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
 		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -754,7 +755,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		if (ha->flags.exchoffld_enabled)
 			mcp->mb[4] |= ENABLE_EXCHANGE_OFFLD;
 
-		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
+		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
 		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
-- 
2.20.1



