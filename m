Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8215F2F4B1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733287AbfE3Ek3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbfE3DMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7847823E29;
        Thu, 30 May 2019 03:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185952;
        bh=W73dIoJV3wsmQyuf+rovhCEIpZz+DHLcbBQufK7xTmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCo5RTr8mmwhEBy9Yyif02O2GW4swb4ofZn7EuFLQoMiv7tr2VXgrX500COrfbnGY
         /yP4c+iQov5349kCwj64kc4SheSar42HY8KeNnL03B/wAaZ2UcRlONUpAWQiRm4iYw
         uhYYGL3/5euqZaAZgywo6wgxwEmuVxmxoAzqACOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 366/405] scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices
Date:   Wed, 29 May 2019 20:06:04 -0700
Message-Id: <20190530030559.117313753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c95a3b4b0fb8d351e2329a96f87c4fc96a149505 ]

During debug, it was seen that the driver is issuing commands specific to
SLI3 on SLI4 devices. Although the adapter correctly rejected the command,
this should not be done.

Revise the code to stop sending these commands on a SLI4 adapter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index aa4961a2caf81..676f4bf3f33a3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -932,7 +932,11 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		}
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
-	/* Clean up any firmware default rpi's */
+
+	/* Clean up any SLI3 firmware default rpi's */
+	if (phba->sli_rev > LPFC_SLI_REV3)
+		goto skip_unreg_did;
+
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mb) {
 		lpfc_unreg_did(phba, 0xffff, LPFC_UNREG_ALL_DFLT_RPIS, mb);
@@ -944,6 +948,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		}
 	}
 
+ skip_unreg_did:
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->pport->fc_flag & FC_PT2PT) {
 		mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -4979,6 +4984,10 @@ lpfc_unreg_default_rpis(struct lpfc_vport *vport)
 	LPFC_MBOXQ_t     *mbox;
 	int rc;
 
+	/* Unreg DID is an SLI3 operation. */
+	if (phba->sli_rev > LPFC_SLI_REV3)
+		return;
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
 		lpfc_unreg_did(phba, vport->vpi, LPFC_UNREG_ALL_DFLT_RPIS,
-- 
2.20.1



