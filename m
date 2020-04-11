Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFB1A5808
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgDKXLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbgDKXLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FAF320708;
        Sat, 11 Apr 2020 23:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646699;
        bh=mfv78u22Til/hjn2TeKo3rMaYO9dwPdixN6dnVDnfAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLc0Dto0YsYPU+qhZJ0EooYsAWdb/d9tRThFpFViTXu4SA1cABKC3r+vzCjr2/UEt
         e+WsJLdhZn/NsGKjPgf1/RSIR3xfbSDRiQO2z8lUnaBegIW7I/LFYuN5ikn8pGw89w
         K6yHyS2mXE77FULlI01/tarqhITzd4YLxAliHNWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Carnuccio <joe.carnuccio@cavium.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 093/108] scsi: qla2xxx: Fix qla2x00_echo_test() based on ISP type
Date:   Sat, 11 Apr 2020 19:09:28 -0400
Message-Id: <20200411230943.24951-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

[ Upstream commit 83cfd3dc002fc730387a1ec5fa0d4097cc31ee9f ]

Ths patch fixes MBX in-direction for setting right bits for
qla2x00_echo_test()

Link: https://lore.kernel.org/r/20200212214436.25532-19-hmadhani@marvell.com
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9011a26710374..101828e95fb34 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5172,10 +5172,11 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 		mcp->out_mb |= MBX_2;
 
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_1;
-	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
+	    IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.20.1

