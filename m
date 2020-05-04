Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED81C449E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgEDSIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbgEDSHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1FD2075A;
        Mon,  4 May 2020 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615671;
        bh=jLnwdL+bQ47tryUM0Gx+p/BOVwwIranqzTd57rNgdUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOvmZg3jPuL7wogd5TgHEBLdKfM6ar3Xl37dgeEW2t+VFTeBkMbo7L4fngt7cTCvj
         EgXylX9rb0Ey48RPXrpEI4Qm+LVhV+BxV9/63AvMLK1R4NEcf6bubSnvEIKugIssDE
         oi6uWo8gyoQH1/aCAVHe1Fe876QvPWrL0I29ZsaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 41/73] scsi: qla2xxx: set UNLOADING before waiting for session deletion
Date:   Mon,  4 May 2020 19:57:44 +0200
Message-Id: <20200504165508.091879440@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

commit 856e152a3c08bf7987cbd41900741d83d9cddc8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

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
@@ -6044,13 +6042,6 @@ qla2x00_disable_board_on_pci_error(struc
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
 
@@ -6061,9 +6052,14 @@ qla2x00_disable_board_on_pci_error(struc
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
 


