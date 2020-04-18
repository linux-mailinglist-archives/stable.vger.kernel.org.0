Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF3B1AF13A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgDROlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgDROlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:41:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 665D021D82;
        Sat, 18 Apr 2020 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220860;
        bh=eDTZP46Dc/orj50j4/6k5OiC257YQ0FfV+RyCDxPvF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT+s+0x3BMWOSngFvoQZ4HE03qzM7nGJ+evD/dBWYIC+hpwybGZMIM06Iyx246Anm
         UFBUfMe/kIt1airNK7UmkV07DYthtngoWtQ8mHcD435Xn39bE/RWnMv74tNJ/q8Ivm
         kHcy7djMHNrfAcqHJHvJ/GIK7tBB7s5tltcxaNpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/78] scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG
Date:   Sat, 18 Apr 2020 10:39:39 -0400
Message-Id: <20200418144047.9013-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 807e7353d8a7105ce884d22b0dbc034993c6679c ]

Kernel is crashing with the following stacktrace:

  BUG: unable to handle kernel NULL pointer dereference at
    00000000000005bc
  IP: lpfc_nvme_register_port+0x1a8/0x3a0 [lpfc]
  ...
  Call Trace:
  lpfc_nlp_state_cleanup+0x2b2/0x500 [lpfc]
  lpfc_nlp_set_state+0xd7/0x1a0 [lpfc]
  lpfc_cmpl_prli_prli_issue+0x1f7/0x450 [lpfc]
  lpfc_disc_state_machine+0x7a/0x1e0 [lpfc]
  lpfc_cmpl_els_prli+0x16f/0x1e0 [lpfc]
  lpfc_sli_sp_handle_rspiocb+0x5b2/0x690 [lpfc]
  lpfc_sli_handle_slow_ring_event_s4+0x182/0x230 [lpfc]
  lpfc_do_work+0x87f/0x1570 [lpfc]
  kthread+0x10d/0x130
  ret_from_fork+0x35/0x40

During target side fault injections, it is possible to hit the
NLP_WAIT_FOR_UNREG case in lpfc_nvme_remoteport_delete. A prior commit
fixed a rebind and delete race condition, but called lpfc_nlp_put
unconditionally. This triggered a deletion and the crash.

Fix by movng nlp_put to inside the NLP_WAIT_FOR_UNREG case, where the nlp
will be being unregistered/removed. Leave the reference if the flag isn't
set.

Link: https://lore.kernel.org/r/20200322181304.37655-8-jsmart2021@gmail.com
Fixes: b15bd3e6212e ("scsi: lpfc: Fix nvme remoteport registration race conditions")
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8e0f03ef346b6..c475ae0f2f515 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -342,13 +342,15 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	if (ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
 		ndlp->nrport = NULL;
 		ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
-	}
-	spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&vport->phba->hbalock);
 
-	/* Remove original register reference. The host transport
-	 * won't reference this rport/remoteport any further.
-	 */
-	lpfc_nlp_put(ndlp);
+		/* Remove original register reference. The host transport
+		 * won't reference this rport/remoteport any further.
+		 */
+		lpfc_nlp_put(ndlp);
+	} else {
+		spin_unlock_irq(&vport->phba->hbalock);
+	}
 
  rport_err:
 	return;
-- 
2.20.1

