Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C75B1C904F
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgEGOi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgEGO1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A66032145D;
        Thu,  7 May 2020 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861658;
        bh=wMn0nLYrfQZRRSOMcfXwLIs27DIUrEvIxmjxL1td6J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQ1j6v2lPD4TOvL3JgPYV76xYNvjh3uVRKLsKG+f6xITxKKpX/jo4Js6euh6KUPi+
         IBv/6rhZO095ghriPfzlxf99LblNtc9M1m4mQfrIEOk0nvrpyqLUnHvXncePN4RpLa
         L76fyKYCMgkaoxkyAxie2+C/kThhN2SFRjBDjGic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 09/50] scsi: qla2xxx: set UNLOADING before waiting for session deletion
Date:   Thu,  7 May 2020 10:26:45 -0400
Message-Id: <20200507142726.25751-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 856e152a3c08bf7987cbd41900741d83d9cddc8e ]

The purpose of the UNLOADING flag is to avoid port login procedures to
continue when a controller is in the process of shutting down.  It makes
sense to set this flag before starting session teardown.

Furthermore, use atomic test_and_set_bit() to avoid the shutdown being run
multiple times in parallel. In qla2x00_disable_board_on_pci_error(), the
test for UNLOADING is postponed until after the check for an already
disabled PCI board.

Link: https://lore.kernel.org/r/20200421204621.19228-2-mwilck@suse.com
Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Reviewed-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7a94e1171c726..4a89202115521 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3720,6 +3720,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	}
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	/*
+	 * if UNLOADING flag is already set, then continue unload,
+	 * where it was set first.
+	 */
+	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
+
 	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
 	    IS_QLA28XX(ha)) {
 		if (ha->flags.fw_started)
@@ -3738,15 +3745,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_wait_for_sess_deletion(base_vha);
 
-	/*
-	 * if UNLOAD flag is already set, then continue unload,
-	 * where it was set first.
-	 */
-	if (test_bit(UNLOADING, &base_vha->dpc_flags))
-		return;
-
-	set_bit(UNLOADING, &base_vha->dpc_flags);
-
 	qla_nvme_delete(base_vha);
 
 	dma_free_coherent(&ha->pdev->dev,
@@ -6044,13 +6042,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 	struct pci_dev *pdev = ha->pdev;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	/*
-	 * if UNLOAD flag is already set, then continue unload,
-	 * where it was set first.
-	 */
-	if (test_bit(UNLOADING, &base_vha->dpc_flags))
-		return;
-
 	ql_log(ql_log_warn, base_vha, 0x015b,
 	    "Disabling adapter.\n");
 
@@ -6061,9 +6052,14 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 		return;
 	}
 
-	qla2x00_wait_for_sess_deletion(base_vha);
+	/*
+	 * if UNLOADING flag is already set, then continue unload,
+	 * where it was set first.
+	 */
+	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
 
-	set_bit(UNLOADING, &base_vha->dpc_flags);
+	qla2x00_wait_for_sess_deletion(base_vha);
 
 	qla2x00_delete_all_vps(ha, base_vha);
 
-- 
2.20.1

