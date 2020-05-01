Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666B91C13CB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgEANdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgEANdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82B3208D6;
        Fri,  1 May 2020 13:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339982;
        bh=+zGfXxaBnz8qg6N/EFEw3eUQup5GCAwwsCQicZoPX5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPsd6FyTN37QP6BFwQRN3bemI+AEATauI56mvqAlIceQM0zuAoW2+S9Svn7snP6RP
         vyA27d84c3aZJIiDoUH30V9y1oLSvGa/mwSpx5Fvy/y8sRmPuNAoDPAmdMeWm3S5XH
         4s8fFB9VozuP3svz3tiwJrM3QnJLEAUw/AxXW3HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linh Pham <phaml@us.ibm.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        George Wilson <gcwilson@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.14 058/117] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
Date:   Fri,  1 May 2020 15:21:34 +0200
Message-Id: <20200501131552.451488373@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012 IBM Corporation
+ * Copyright (C) 2012-2020 IBM Corporation
  *
  * Author: Ashley Lai <ashleydlai@gmail.com>
  *
@@ -141,6 +141,64 @@ static int tpm_ibmvtpm_recv(struct tpm_c
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
@@ -153,6 +211,7 @@ static int tpm_ibmvtpm_recv(struct tpm_c
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	bool retry = true;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -186,18 +245,27 @@ static int tpm_ibmvtpm_send(struct tpm_c
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
@@ -276,26 +344,6 @@ static int ibmvtpm_crq_send_init_complet
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
@@ -407,44 +455,6 @@ static int ibmvtpm_reset_crq(struct ibmv
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


