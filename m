Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709AC18C5C1
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 04:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCTD2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 23:28:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbgCTD2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 23:28:11 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K33p4r005852;
        Thu, 19 Mar 2020 23:28:09 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8btj2v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 23:28:09 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02K3Q2P1008849;
        Fri, 20 Mar 2020 03:28:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2yrpw7gnu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Mar 2020 03:28:08 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02K3S7R653608798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 03:28:07 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FBF2112062;
        Fri, 20 Mar 2020 03:28:07 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27CB2112065;
        Fri, 20 Mar 2020 03:28:07 +0000 (GMT)
Received: from crimini9.aus.stglabs.ibm.com (unknown [9.40.192.141])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 20 Mar 2020 03:28:07 +0000 (GMT)
Received: (from gcwilson@localhost)
        by crimini9.aus.stglabs.ibm.com (8.15.2/8.15.2/Submit) id 02K3S2QX228135;
        Thu, 19 Mar 2020 23:28:02 -0400
X-Authentication-Warning: crimini9.aus.stglabs.ibm.com: gcwilson set sender to gcwilson@linux.ibm.com using -f
From:   George Wilson <gcwilson@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nayna Jain <nayna@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        George Wilson <gcwilson@linux.ibm.com>,
        Linh Pham <phaml@us.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v4] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
Date:   Thu, 19 Mar 2020 23:27:58 -0400
Message-Id: <20200320032758.228088-1-gcwilson@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200011
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tpm_ibmvtpm_send() can fail during PowerVM Live Partition Mobility resume
with an H_CLOSED return from ibmvtpm_send_crq().  The PAPR says, 'The
"partner partition suspended" transport event disables the associated CRQ
such that any H_SEND_CRQ hcall() to the associated CRQ returns H_Closed
until the CRQ has been explicitly enabled using the H_ENABLE_CRQ hcall.'
This patch adds a check in tpm_ibmvtpm_send() for an H_CLOSED return from
ibmvtpm_send_crq() and in that case calls tpm_ibmvtpm_resume() and
retries the ibmvtpm_send_crq() once.

Reported-by: Linh Pham <phaml@us.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Tested-by: Linh Pham <phaml@us.ibm.com>
Fixes: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM")
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm_ibmvtpm.c | 136 ++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 63 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 78cc52690177..e82013d587b4 100644
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
@@ -133,6 +133,64 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return len;
 }
 
+/**
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
 /**
  * tpm_ibmvtpm_send() - Send a TPM command
  * @chip:	tpm chip struct
@@ -146,6 +204,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	bool retry = true;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -179,18 +238,27 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
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
@@ -268,26 +336,6 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
 	return rc;
 }
 
-/**
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
 /**
  * tpm_ibmvtpm_remove - ibm vtpm remove entry point
  * @vdev:	vio device struct
@@ -400,44 +448,6 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
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
-- 
2.24.1

