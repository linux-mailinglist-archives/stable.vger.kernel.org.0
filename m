Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FECEEC97
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbfKDV6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbfKDV6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:42 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E27E7214D9;
        Mon,  4 Nov 2019 21:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904721;
        bh=YL/GOslPbKzWPVIGCvbmtekbS/5Pr6SFRznL14kivv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsulxHnkFFlYmDJ7n1cXjjkwULqpzC6MD3WqIh6V60BA+0tajkQVk+KA4/Idjc8Fi
         i4Jyi81qbyohamRM++kUN/bdNNIgUtO7nxUloKRy68wNj3fPM86mxhTHfkOC7P314q
         sepN6FJOrGzZ0v/R7UmVAu4TWgPgGnThPmDa3kys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/149] scsi: lpfc: Correct localport timeout duration error
Date:   Mon,  4 Nov 2019 22:44:00 +0100
Message-Id: <20191104212139.389997986@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2a0fb340fcc816975b8b0f2fef913d11999c39cf ]

Current code incorrectly specifies a completion wait timeout duration in 5
jiffies, when it should have been 5 seconds.

Fix the adjust for units for the completion timeout call.

[mkp: manual merge]

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 6 +++++-
 drivers/scsi/lpfc/lpfc_nvmet.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e2575c8ec93e8..22efefcc6cd84 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1713,7 +1713,11 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		}
 		tgtp->tport_unreg_cmp = &tport_unreg_cmp;
 		nvmet_fc_unregister_targetport(phba->targetport);
-		wait_for_completion_timeout(&tport_unreg_cmp, 5);
+		if (!wait_for_completion_timeout(tgtp->tport_unreg_cmp,
+					msecs_to_jiffies(LPFC_NVMET_WAIT_TMO)))
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6179 Unreg targetport %p timeout "
+					"reached.\n", phba->targetport);
 		lpfc_nvmet_cleanup_io_context(phba);
 	}
 	phba->targetport = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 0ec1082ce7ef6..3b170284a0e59 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -31,6 +31,8 @@
 #define LPFC_NVMET_MRQ_AUTO		0
 #define LPFC_NVMET_MRQ_MAX		16
 
+#define LPFC_NVMET_WAIT_TMO		(5 * MSEC_PER_SEC)
+
 /* Used for NVME Target */
 struct lpfc_nvmet_tgtport {
 	struct lpfc_hba *phba;
-- 
2.20.1



