Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4107E4E60
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395313AbfJYOGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632718AbfJYNzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B36B222CB;
        Fri, 25 Oct 2019 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011739;
        bh=SrB6elDN24ZFvsjcyWtUFkgwdAXQ28zARkeICx883oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcyitPiTcT9C9hH1tXCKKGJiAA1ZzV+rVXGiFvFCiVZmHNZ85HfGt7q/paBycuCZG
         1U0ecvnGwHTMu5dwBYspXLFgeqTTZ1vWlCAGQB9tMhN73wv4N94psNsEIamKa/noib
         h/vj4CEe6/khSS2VVhHdUSi1cD0DXUglOrsLtvGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 20/33] scsi: qedf: Fix crash during sg_reset
Date:   Fri, 25 Oct 2019 09:54:52 -0400
Message-Id: <20191025135505.24762-20-sashal@kernel.org>
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

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 47aeee5549cf9326656a8f9190960dfd35c101e2 ]

Driver was attempting to print cdb[0], which is not set for resets coming
from SCSI ioctls. Check for cmd_len before accessing cmnd.

Crash info:
[84790.864747] BUG: unable to handle kernel NULL pointer dereference at (null)
[84790.864783] IP: qedf_initiate_tmf+0x7a/0x6e0 [qedf]
[84790.865204] Call Trace:
[84790.865246]  scsi_try_target_reset+0x2b/0x90 [scsi_mod]
[84790.865266]  scsi_ioctl_reset+0x20f/0x2a0 [scsi_mod]
[84790.865284]  scsi_ioctl+0x131/0x3a0 [scsi_mod]

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d881e822f92cf..56756a5700867 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2363,8 +2363,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 
 	QEDF_ERR(NULL,
 		 "tm_flags 0x%x sc_cmd %p op = 0x%02x target_id = 0x%x lun=%d\n",
-		 tm_flags, sc_cmd, sc_cmd->cmnd[0], rport->scsi_target_id,
-		 (int)sc_cmd->device->lun);
+		 tm_flags, sc_cmd, sc_cmd->cmd_len ? sc_cmd->cmnd[0] : 0xff,
+		 rport->scsi_target_id, (int)sc_cmd->device->lun);
 
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(NULL, "stale rport\n");
-- 
2.20.1

