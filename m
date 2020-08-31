Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A43258175
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 20:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgHaS7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 14:59:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgHaS7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 14:59:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VIXlNA106098;
        Mon, 31 Aug 2020 14:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=bwAt7yBaCufyhLm38qbJMkOMLiDwp54lE27ZP3Ze8jc=;
 b=s2ultdyKJmW7+3Bc5B5WlzUF1iv9h1Eo5pBa/TsnZPJ45JEQgBtjKbEpIjm4R/oswqKe
 dvpjiyudEaPoNC3AYzOi7c0p8n9dwangOksieEGg2iKY5RzxFLiPAYRSCtuHEPN1d/NA
 GtSL1zqZ5/NpnKULeWexnteGdkm2tYCB1KEQmyhG6ZQ1w6go/d8PNjN6/PgIyhpE8rTn
 eQaamRIfOI2cbRU0vGTl6v1Hz9GwISDGinEf9BjbXAwjJ21y9ZT94R3auztKRJwKXesI
 Lj/c4qnDsadO8xFhE2FGK+TLWyPU+sKgp+0VuF1varstj2pX+SBlfvbATJCF4Vn9PbUe zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3396g98qks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 14:59:34 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07VIXlNe106157;
        Mon, 31 Aug 2020 14:59:33 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3396g98qkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 14:59:33 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VIvMed026783;
        Mon, 31 Aug 2020 18:59:32 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 337en96r16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 18:59:32 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VIxVml49676694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 18:59:32 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8753112064;
        Mon, 31 Aug 2020 18:59:31 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF5D4112061;
        Mon, 31 Aug 2020 18:59:31 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 18:59:31 +0000 (GMT)
From:   Stefan Berger <stefanb@linux.vnet.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     jarkko.sakkinen@linux.intel.com, stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH for-4.19] tpm: Unify the mismatching TPM space buffer sizes
Date:   Mon, 31 Aug 2020 14:59:29 -0400
Message-Id: <20200831185929.2696998-1-stefanb@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_09:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 adultscore=0 impostorscore=0
 spamscore=0 mlxlogscore=818 suspectscore=1 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310110
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

The size of the buffers for storing context's and sessions can vary from
arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
enough for most use with three handles (that is how many we allow at the
moment). Parametrize the buffer size while doing this, so that it is easier
to revisit this later on if required.

Cc: stable@vger.kernel.org
Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c   |  9 ++-------
 drivers/char/tpm/tpm.h        |  6 +++++-
 drivers/char/tpm/tpm2-space.c | 26 ++++++++++++++++----------
 drivers/char/tpm/tpmrm-dev.c  |  2 +-
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 4946c5b37d04d..f79f877942733 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -276,13 +276,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdevs.owner = THIS_MODULE;
 
-	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.context_buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.session_buf) {
+	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
+	if (rc) {
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 289221d653cb2..b9a30f0b88257 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -188,6 +188,7 @@ struct tpm_space {
 	u8 *context_buf;
 	u32 session_tbl[3];
 	u8 *session_buf;
+	u32 buf_size;
 };
 
 enum tpm_chip_flags {
@@ -278,6 +279,9 @@ struct tpm_output_header {
 
 #define TPM_TAG_RQU_COMMAND 193
 
+/* TPM2 specific constants. */
+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -595,7 +599,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
-int tpm2_init_space(struct tpm_space *space);
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index d2e101b32482f..9f4e22dcde270 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -43,18 +43,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
 	}
 }
 
-int tpm2_init_space(struct tpm_space *space)
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
 {
-	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->context_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!space->context_buf)
 		return -ENOMEM;
 
-	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->session_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (space->session_buf == NULL) {
 		kfree(space->context_buf);
+		/* Prevent caller getting a dangling pointer. */
+		space->context_buf = NULL;
 		return -ENOMEM;
 	}
 
+	space->buf_size = buf_size;
 	return 0;
 }
 
@@ -276,8 +279,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 	       sizeof(space->context_tbl));
 	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
-	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
+	memcpy(chip->work_space.context_buf, space->context_buf,
+	       space->buf_size);
+	memcpy(chip->work_space.session_buf, space->session_buf,
+	       space->buf_size);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -456,7 +461,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
+				       space->context_buf, space->buf_size,
 				       &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
@@ -474,9 +479,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
+				       space->session_buf, space->buf_size,
 				       &offset);
-
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -522,8 +526,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 	       sizeof(space->context_tbl));
 	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
-	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
+	memcpy(space->context_buf, chip->work_space.context_buf,
+	       space->buf_size);
+	memcpy(space->session_buf, chip->work_space.session_buf,
+	       space->buf_size);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
index 1a0e97a5da5a4..162fb16243d03 100644
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -22,7 +22,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
 	if (priv == NULL)
 		return -ENOMEM;
 
-	rc = tpm2_init_space(&priv->space);
+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
 		kfree(priv);
 		return -ENOMEM;
-- 
2.26.2

