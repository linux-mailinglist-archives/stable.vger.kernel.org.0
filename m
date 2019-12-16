Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0F7121699
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfLPSaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbfLPSMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D1DC2166E;
        Mon, 16 Dec 2019 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519971;
        bh=/oYdgNYhk8Lv5klb/fdBxyt09HNKyYtpdnKzGykVzPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zw20mGB1S95MlXSQAE1YBEHaY/LIIYP8Si5T/R8/bHblYtRVHcjJuQHj7/BgC9Rwc
         7eywBcbSRYAWmcgJLgjZir6L9iT6GypPC1+EO9+yW4DhIlVH1lHcOLCWKcLDSIS3Ko
         LdjyaAdPw0d0pvPRGnbvuT6RA94XZxr19o6KxrAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 144/180] scsi: qla2xxx: Really fix qla2xxx_eh_abort()
Date:   Mon, 16 Dec 2019 18:49:44 +0100
Message-Id: <20191216174843.370017056@linuxfoundation.org>
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

[ Upstream commit 8dd9593cc07ad7d999bef81b06789ef873a94881 ]

I'm not sure how this happened but the patch that was intended to fix abort
handling was incomplete. This patch fixes that patch as follows:

 - If aborting the SCSI command failed, wait until the SCSI command
   completes.

 - Return SUCCESS instead of FAILED if an abort attempt races with SCSI
   command completion.

 - Since qla2xxx_eh_abort() increments the sp reference count by calling
   sp_get(), decrement the sp reference count before returning.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 219d27d7147e ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 82f6ae4dcfc0b..0f51387ceebdf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1274,6 +1274,7 @@ static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	DECLARE_COMPLETION_ONSTACK(comp);
 	srb_t *sp;
 	int ret;
 	unsigned int id;
@@ -1309,6 +1310,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return SUCCESS;
 	}
 
+	/* Get a reference to the sp and drop the lock. */
 	if (sp_get(sp)){
 		/* ref_count is already 0 */
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
@@ -1336,6 +1338,23 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		sp->done(sp, DID_ABORT << 16);
 		ret = SUCCESS;
 		break;
+	case QLA_FUNCTION_PARAMETER_ERROR: {
+		/* Wait for the command completion. */
+		uint32_t ratov = ha->r_a_tov/10;
+		uint32_t ratov_j = msecs_to_jiffies(4 * ratov * 1000);
+
+		WARN_ON_ONCE(sp->comp);
+		sp->comp = &comp;
+		if (!wait_for_completion_timeout(&comp, ratov_j)) {
+			ql_dbg(ql_dbg_taskm, vha, 0xffff,
+			    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
+			    __func__, ha->r_a_tov);
+			ret = FAILED;
+		} else {
+			ret = SUCCESS;
+		}
+		break;
+	}
 	default:
 		/*
 		 * Either abort failed or abort and completion raced. Let
@@ -1345,6 +1364,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		break;
 	}
 
+	sp->comp = NULL;
+	atomic_dec(&sp->ref_count);
 	ql_log(ql_log_info, vha, 0x801c,
 	    "Abort command issued nexus=%ld:%d:%llu -- %x.\n",
 	    vha->host_no, id, lun, ret);
-- 
2.20.1



