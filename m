Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9076A1A5811
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgDKX1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729935AbgDKXLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5064C20CC7;
        Sat, 11 Apr 2020 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646694;
        bh=lQRj8VNsJOOF8DfDzvqCyTjDoXlEsrTKzjTgMDofYVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHEaFjSs+pQSd/Vdk1U9zj5xB091/+lAmjEwcYK2HjhNbMPArZPDm5Gfw9rISmzrH
         Eny6cAXYruPGSw3G9va8zPJDtoe6WGrj2ranU4znB+mrXuUto8HQcn8cihbHShbJG9
         LF645WW7y9apGXElnmYzV94rFDNfddg33wN/RHiM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 088/108] scsi: qla2xxx: fix FW resource count values
Date:   Sat, 11 Apr 2020 19:09:23 -0400
Message-Id: <20200411230943.24951-88-sashal@kernel.org>
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit ce1ee122e0f048fc67c1259489f0802a28049bfd ]

This patch fixes issue where current and original exchanges count
were swapped for intiator and targets.

Also fix IOCB count for current and original which were swapped.

Link: https://lore.kernel.org/r/20200226224022.24518-9-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0a6fb359f4d5e..e62b2115235e1 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -134,11 +134,11 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	} else {
 		seq_puts(s, "FW Resource count\n\n");
 		seq_printf(s, "Original TGT exchg count[%d]\n", mb[1]);
-		seq_printf(s, "current TGT exchg count[%d]\n", mb[2]);
-		seq_printf(s, "original Initiator Exchange count[%d]\n", mb[3]);
-		seq_printf(s, "Current Initiator Exchange count[%d]\n", mb[6]);
-		seq_printf(s, "Original IOCB count[%d]\n", mb[7]);
-		seq_printf(s, "Current IOCB count[%d]\n", mb[10]);
+		seq_printf(s, "Current TGT exchg count[%d]\n", mb[2]);
+		seq_printf(s, "Current Initiator Exchange count[%d]\n", mb[3]);
+		seq_printf(s, "Original Initiator Exchange count[%d]\n", mb[6]);
+		seq_printf(s, "Current IOCB count[%d]\n", mb[7]);
+		seq_printf(s, "Original IOCB count[%d]\n", mb[10]);
 		seq_printf(s, "MAX VP count[%d]\n", mb[11]);
 		seq_printf(s, "MAX FCF count[%d]\n", mb[12]);
 		seq_printf(s, "Current free pageable XCB buffer cnt[%d]\n",
@@ -149,7 +149,6 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		    mb[22]);
 		seq_printf(s, "Original Target fast XCB buffer cnt[%d]\n",
 		    mb[23]);
-
 	}
 
 	return 0;
-- 
2.20.1

