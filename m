Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1F10BA03
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfK0U7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbfK0U7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 466852084B;
        Wed, 27 Nov 2019 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888347;
        bh=y5GylDGsCz7qIrBi3/WJS/VV0/tGA8o9bj7XaPDIqYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqSgk5WJHvMGgjmRm8qjwNWkSexFFFMriiZymPoZHnZd7E84VlvtQQQlg42Inq9BS
         fEX/28jYIrPhMoW70qBWKsiAm23aHnS0FxzrkoYwYSU8PznFbEiL/h8JYsgGcBwAfC
         mmzWDLXFUIFXxdV2PmkOZG+Nr/OqEsg/5xghWOdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/306] scsi: hisi_sas: Free slot later in slot_complete_vx_hw()
Date:   Wed, 27 Nov 2019 21:28:26 +0100
Message-Id: <20191127203118.872281834@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 3e178f3ecfcf91a258e832b0f0843a4cfd9059ac ]

If an SSP/SMP IO times out, it may be actually in reality be
simultaneously processing completion of the slot in
slot_complete_vx_hw().

Then if the slot is freed in slot_complete_vx_hw() (this IPTT is freed
and it may be re-used by other slot), and we may abort the wrong slot in
hisi_sas_abort_task().

So to solve the issue, free the slot after the check of
SAS_TASK_STATE_ABORTED in slot_complete_vx_hw().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 1c4ea58da1ae1..c4774d63d5d04 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2481,7 +2481,6 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 
 out:
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
@@ -2491,6 +2490,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3922b17e2ea39..fb2a5969181b5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1749,7 +1749,6 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 
 out:
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
@@ -1759,6 +1758,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);
-- 
2.20.1



