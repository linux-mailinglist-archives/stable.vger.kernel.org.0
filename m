Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B51910B7CB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfK0UhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfK0UhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50560215A4;
        Wed, 27 Nov 2019 20:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887028;
        bh=Ya4z3h/D1ptB65uMeIAiGYXdMxZBBFenfL6jQ59dGu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oajseSHE/F6v3/qEIZ/vbr/zJLDY1+3e9uLnzhqIHocZ+eSLr7fCWmBCExSNiQuuQ
         yq4CryskYrJLmANAj/NhsY8DPI9dCcBa1I0hXAzvjNJjNA1GewEomEw7UdkOVJM6fD
         dU+ANoWLt7+AL9alPVuA82EGi34pQiLEf7gtgAX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 086/132] scsi: mpt3sas: Fix Sync cache command failure during driver unload
Date:   Wed, 27 Nov 2019 21:31:17 +0100
Message-Id: <20191127203016.033453063@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 9029a72500b95578a35877a43473b82cb0386c53 ]

This is to fix SYNC CACHE and START STOP command failures with
DID_NO_CONNECT during driver unload.

In driver's IO submission patch (i.e. in driver's .queuecommand()) driver
won't allow any SCSI commands to the IOC when ioc->remove_host flag is set
and hence SYNC CACHE commands which are issued to the target drives (where
write cache is enabled) during driver unload time is failed with
DID_NO_CONNECT status.

Now modified the driver to allow SYNC CACHE and START STOP commands to IOC,
even when remove_host flag is set.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 36 +++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7d67a68bcc624..8735e4257028a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3254,6 +3254,40 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
 
+/** _scsih_allow_scmd_to_device - check whether scmd needs to
+ *				 issue to IOC or not.
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ *
+ * Returns true if scmd can be issued to IOC otherwise returns false.
+ */
+inline bool _scsih_allow_scmd_to_device(struct MPT3SAS_ADAPTER *ioc,
+	struct scsi_cmnd *scmd)
+{
+
+	if (ioc->pci_error_recovery)
+		return false;
+
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION) {
+		if (ioc->remove_host)
+			return false;
+
+		return true;
+	}
+
+	if (ioc->remove_host) {
+
+		switch (scmd->cmnd[0]) {
+		case SYNCHRONIZE_CACHE:
+		case START_STOP:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return true;
+}
 
 /**
  * _scsih_sas_control_complete - completion routine
@@ -3880,7 +3914,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
-	if (ioc->pci_error_recovery || ioc->remove_host) {
+	if (!(_scsih_allow_scmd_to_device(ioc, scmd))) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
-- 
2.20.1



