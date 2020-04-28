Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89C1BCB05
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgD1SdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbgD1SdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A34D21841;
        Tue, 28 Apr 2020 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098780;
        bh=FXa31WiGtRYMJ9NfvYoSgeDSudxoMLwVKHcstgY/LuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjaIuE7jH+p42qw/PscCGfvspS9K1eR31ItpeD3OUOLVGGKclqetw7wDuqA65KGhd
         Fnh94RL7oe1d4AFhQsKQ9DWMTwSl35jkzR0BgLR+Y7VkuNRsbjZCIWPb685xQGSL02
         JOGrm/m8/fTUO55Yl76+jKiIPpdABxzu0x2irLZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linh Pham <phaml@us.ibm.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        George Wilson <gcwilson@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.6 111/167] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
Date:   Tue, 28 Apr 2020 20:24:47 +0200
Message-Id: <20200428182239.230472936@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Wilson <gcwilson@linux.ibm.com>

commit eba5cf3dcb844c82f54d4a857e124824e252206d upstream.

tpm_ibmvtpm_send() can fail during PowerVM Live Partition Mobility resume
with an H_CLOSED return from ibmvtpm_send_crq().  The PAPR says, 'The
"partner partition suspended" transport event disables the associated CRQ
such that any H_SEND_CRQ hcall() to the associated CRQ returns H_Closed
until the CRQ has been explicitly enabled using the H_ENABLE_CRQ hcall.'
This patch adds a check in tpm_ibmvtpm_send() for an H_CLOSED return from
ibmvtpm_send_crq() and in that case calls tpm_ibmvtpm_resume() and
retries the ibmvtpm_send_crq() once.

Cc: stable@vger.kernel.org # 3.7.x
Fixes: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM")
Reported-by: Linh Pham <phaml@us.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Tested-by: Linh Pham <phaml@us.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_ibmvtpm.c |  136 ++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 63 deletions(-)

--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2012 IBM Corporation
+ * Copyright (C) 2012-2020 IBM Corporation
  *
  * Author: Ashley Lai <ashleydlai@gmail.com>
  *
@@ -134,6 +134,64 @@ static int tpm_ibmvtpm_recv(struct tpm_c
 }
 
 /**
+ * ibmvtpm_crq_send_init - Send a CRQ initialize message
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return:
+ *	0 on success.
+ *	Non-zero on failure.
+ */
+static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc;
+
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"%s failed rc=%d\n", __func__, rc);
+
+	return rc;
+}
+
+/**
+ * tpm_ibmvtpm_resume - Resume from suspend
+ *
+ * @dev:	device struct
+ *
+ * Return: Always 0.
+ */
+static int tpm_ibmvtpm_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	int rc = 0;
+
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_ENABLE_CRQ,
+					ibmvtpm->vdev->unit_address);
+	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
+
+	if (rc) {
+		dev_err(dev, "Error enabling ibmvtpm rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = vio_enable_interrupts(ibmvtpm->vdev);
+	if (rc) {
+		dev_err(dev, "Error vio_enable_interrupts rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = ibmvtpm_crq_send_init(ibmvtpm);
+	if (rc)
+		dev_err(dev, "Error send_init rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
  * tpm_ibmvtpm_send() - Send a TPM command
  * @chip:	tpm chip struct
  * @buf:	buffer contains data to send
@@ -146,6 +204,7 @@ static int tpm_ibmvtpm_recv(struct tpm_c
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	bool retry = true;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -179,18 +238,27 @@ static int tpm_ibmvtpm_send(struct tpm_c
 	 */
 	ibmvtpm->tpm_processing_cmd = true;
 
+again:
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
 			IBMVTPM_VALID_CMD, VTPM_TPM_COMMAND,
 			count, ibmvtpm->rtce_dma_handle);
 	if (rc != H_SUCCESS) {
+		/*
+		 * H_CLOSED can be returned after LPM resume.  Call
+		 * tpm_ibmvtpm_resume() to re-enable the CRQ then retry
+		 * ibmvtpm_send_crq() once before failing.
+		 */
+		if (rc == H_CLOSED && retry) {
+			tpm_ibmvtpm_resume(ibmvtpm->dev);
+			retry = false;
+			goto again;
+		}
 		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
-		rc = 0;
 		ibmvtpm->tpm_processing_cmd = false;
-	} else
-		rc = 0;
+	}
 
 	spin_unlock(&ibmvtpm->rtce_lock);
-	return rc;
+	return 0;
 }
 
 static void tpm_ibmvtpm_cancel(struct tpm_chip *chip)
@@ -269,26 +337,6 @@ static int ibmvtpm_crq_send_init_complet
 }
 
 /**
- * ibmvtpm_crq_send_init - Send a CRQ initialize message
- * @ibmvtpm:	vtpm device struct
- *
- * Return:
- *	0 on success.
- *	Non-zero on failure.
- */
-static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
-{
-	int rc;
-
-	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
-	if (rc != H_SUCCESS)
-		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
-
-	return rc;
-}
-
-/**
  * tpm_ibmvtpm_remove - ibm vtpm remove entry point
  * @vdev:	vio device struct
  *
@@ -400,44 +448,6 @@ static int ibmvtpm_reset_crq(struct ibmv
 				  ibmvtpm->crq_dma_handle, CRQ_RES_BUF_SIZE);
 }
 
-/**
- * tpm_ibmvtpm_resume - Resume from suspend
- *
- * @dev:	device struct
- *
- * Return: Always 0.
- */
-static int tpm_ibmvtpm_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
-	int rc = 0;
-
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_ENABLE_CRQ,
-					ibmvtpm->vdev->unit_address);
-	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
-
-	if (rc) {
-		dev_err(dev, "Error enabling ibmvtpm rc=%d\n", rc);
-		return rc;
-	}
-
-	rc = vio_enable_interrupts(ibmvtpm->vdev);
-	if (rc) {
-		dev_err(dev, "Error vio_enable_interrupts rc=%d\n", rc);
-		return rc;
-	}
-
-	rc = ibmvtpm_crq_send_init(ibmvtpm);
-	if (rc)
-		dev_err(dev, "Error send_init rc=%d\n", rc);
-
-	return rc;
-}
-
 static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	return (status == 0);


