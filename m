Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2045C56A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350751AbhKXN5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352995AbhKXNze (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:55:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA36632C4;
        Wed, 24 Nov 2021 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759194;
        bh=FEgnfhqPl81GleE3IRFdHhyPMhCuTyNWnScTp9ADNzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNAKP8l/J2mwQBUnyQsyGHgd9EYYJtmScypNk4604rc78vLNlGXOy5No+drDCNVZY
         1xof+5DlvzI99xnAEmmqpHIUhqkYLkNbyl2NY71FpKU3vqMgOX2inARyV8zESs3ORn
         Lmkwb4b/+ghzcr067Si8mxOGGfuTKntqTyh87B+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/279] scsi: ufs: core: Fix another task management completion race
Date:   Wed, 24 Nov 2021 12:57:22 +0100
Message-Id: <20211124115724.128091686@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 5cb37a26355d79ab290220677b1b57d28e99a895 ]

hba->outstanding_tasks, which is read under host_lock spinlock, tells the
interrupt handler what task management tags are in use by the driver.  The
doorbell register bits indicate which tags are in use by the hardware.  A
doorbell bit that is 0 is because the bit has yet to be set by the driver,
or because the task is complete. It is only possible to disambiguate the 2
cases, if reading/writing the doorbell register is synchronized with
reading/writing hba->outstanding_tasks.

For that reason, reading REG_UTP_TASK_REQ_DOOR_BELL must be done under
spinlock.

Link: https://lore.kernel.org/r/20211108064815.569494-3-adrian.hunter@intel.com
Fixes: f5ef336fd2e4 ("scsi: ufs: core: Fix task management completion")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3d0da8b3fed8a..55f2e4d6f10b7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6382,9 +6382,8 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	issued = hba->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
 		struct request *req = hba->tmf_rqs[tag];
-- 
2.33.0



