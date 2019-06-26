Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466A156066
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfFZDpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfFZDpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:45:49 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B86A6216E3;
        Wed, 26 Jun 2019 03:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520748;
        bh=NC0Nour7rmEOz1JnhkIaZafBUKJxVBxTFvqtGjl9Cdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLQ4MnrtvmQhb4xkg95bdajAmW6PS+p8TelfX65nIxJi6PdkeC8gjOOAHQBIkaL3L
         4I/D+K/Ys8fChHXfBS+N8zHZJpEHyu8ooVQSXdhCFr/RG+CxyML4y+3Lzcahag1q7u
         x7qs3F4AEmq2LETjYBlJ2pz/Wjw9gMQvbCMQMXYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Don Brace <don.brace@microsemi.com>,
        Bader Ali - Saleh <bader.alisaleh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Matt Perricone <matt.perricone@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/21] scsi: hpsa: correct ioaccel2 chaining
Date:   Tue, 25 Jun 2019 23:45:00 -0400
Message-Id: <20190626034506.24125-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034506.24125-1-sashal@kernel.org>
References: <20190626034506.24125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Don Brace <don.brace@microsemi.com>

[ Upstream commit 625d7d3518875c4d303c652a198feaa13d9f52d9 ]

- set ioaccel2_sg_element member 'chain_indicator' to IOACCEL2_LAST_SG for
  the last s/g element.

- set ioaccel2_sg_element member 'chain_indicator' to IOACCEL2_CHAIN when
  chaining.

Reviewed-by: Bader Ali - Saleh <bader.alisaleh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Matt Perricone <matt.perricone@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c     | 7 ++++++-
 drivers/scsi/hpsa_cmd.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5b4b7f9be2d7..6d520e8945f7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4800,7 +4800,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 			curr_sg->reserved[0] = 0;
 			curr_sg->reserved[1] = 0;
 			curr_sg->reserved[2] = 0;
-			curr_sg->chain_indicator = 0x80;
+			curr_sg->chain_indicator = IOACCEL2_CHAIN;
 
 			curr_sg = h->ioaccel2_cmd_sg_list[c->cmdindex];
 		}
@@ -4817,6 +4817,11 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 			curr_sg++;
 		}
 
+		/*
+		 * Set the last s/g element bit
+		 */
+		(curr_sg - 1)->chain_indicator = IOACCEL2_LAST_SG;
+
 		switch (cmd->sc_data_direction) {
 		case DMA_TO_DEVICE:
 			cp->direction &= ~IOACCEL2_DIRECTION_MASK;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 078afe448115..ecf15344b55d 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -516,6 +516,7 @@ struct ioaccel2_sg_element {
 	u8 reserved[3];
 	u8 chain_indicator;
 #define IOACCEL2_CHAIN 0x80
+#define IOACCEL2_LAST_SG 0x40
 };
 
 /*
-- 
2.20.1

