Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183CD26A20F
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 11:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIOJWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 05:22:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgIOJWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 05:22:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F91MKY038777
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 05:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=I4Zrq+4AMkk+AFCPM/RsDPDVitdge85Okw9mK5U71d4=;
 b=d2/skJSzb1KPAXkThd+zf2XoL9r5KwqdUQOUTJBKXu60q+M1Xzj2iNAhRWrTd8QXHZlN
 Mthx3UFIwI2PhMfHRPAuKLYYqE4xXtYqhTFrIHHllUEIOtKfUqXoBP/AeEpZMJuGnWO2
 g4BeS+CRgYDiezLltQT7B9WaKMBKAdYjH/fXLBT2TIth0EEY14X0w7IWjwUmiWQZXNen
 8ow8bsFZyenYga0qiyMrLw3+t9K2/gW2R7TokK7+51G0eE+IvboS/8Un/ehJUh3Rxb4d
 wfAM32mhRdpxo1hofCuRgVKoJjLhGJWtPzbJiNTLu/4vPGWFpDigsJrHgThJ90jU+RgC Ww== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jr4jwa42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 05:21:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F9He9M010103
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 09:21:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33h2r9avhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 09:21:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F9LsBb24379686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 09:21:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7E044204B;
        Tue, 15 Sep 2020 09:21:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94C634204D;
        Tue, 15 Sep 2020 09:21:54 +0000 (GMT)
Received: from funtu.home.com (unknown [9.171.43.108])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 09:21:54 +0000 (GMT)
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Alexander.Egorenkov@ibm.com,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] s390/pkey: fix paes selftest failure with paes and pkey static build
Date:   Tue, 15 Sep 2020 11:21:53 +0200
Message-Id: <20200915092153.5483-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_05:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1011 spamscore=0 mlxscore=0 priorityscore=1501 suspectscore=1
 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150079
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When both the paes and the pkey kernel module are statically build
into the kernel, the paes cipher selftests run before the pkey
kernel module is initialized. So a static variable set in the pkey
init function and used in the pkey_clr2protkey function is not
initialized when the paes cipher's selftests request to call pckmo for
transforming a clear key value into a protected key.

This patch moves the initial setup of the static variable into
the function pck_clr2protkey. So it's possible, to use the function
for transforming a clear to a protected key even before the pkey
init function has been called and the paes selftests may run
successful.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reported-by: Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 490917cd44d0..5f75c9dfe071 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -34,9 +34,6 @@ MODULE_DESCRIPTION("s390 protected key interface");
 #define KEYBLOBBUFSIZE 8192  /* key buffer size used for internal processing */
 #define MAXAPQNSINLIST 64    /* max 64 apqns within a apqn list */
 
-/* mask of available pckmo subfunctions, fetched once at module init */
-static cpacf_mask_t pckmo_functions;
-
 /*
  * debug feature data and functions
  */
@@ -90,6 +87,9 @@ static int pkey_clr2protkey(u32 keytype,
 			    const struct pkey_clrkey *clrkey,
 			    struct pkey_protkey *protkey)
 {
+	/* mask of available pckmo subfunctions */
+	static cpacf_mask_t pckmo_functions;
+
 	long fc;
 	int keysize;
 	u8 paramblock[64];
@@ -113,11 +113,13 @@ static int pkey_clr2protkey(u32 keytype,
 		return -EINVAL;
 	}
 
-	/*
-	 * Check if the needed pckmo subfunction is available.
-	 * These subfunctions can be enabled/disabled by customers
-	 * in the LPAR profile or may even change on the fly.
-	 */
+	/* did we already check for PCKMO ? */
+	if (!pckmo_functions.bytes[0]) {
+		/* no, so check now */
+		if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
+			return -ENODEV;
+	}
+	/* check for the pckmo subfunction we need now */
 	if (!cpacf_test_func(&pckmo_functions, fc)) {
 		DEBUG_ERR("%s pckmo functions not available\n", __func__);
 		return -ENODEV;
@@ -1853,7 +1855,7 @@ static struct miscdevice pkey_dev = {
  */
 static int __init pkey_init(void)
 {
-	cpacf_mask_t kmc_functions;
+	cpacf_mask_t func_mask;
 
 	/*
 	 * The pckmo instruction should be available - even if we don't
@@ -1861,15 +1863,15 @@ static int __init pkey_init(void)
 	 * is also the minimum level for the kmc instructions which
 	 * are able to work with protected keys.
 	 */
-	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
+	if (!cpacf_query(CPACF_PCKMO, &func_mask))
 		return -ENODEV;
 
 	/* check for kmc instructions available */
-	if (!cpacf_query(CPACF_KMC, &kmc_functions))
+	if (!cpacf_query(CPACF_KMC, &func_mask))
 		return -ENODEV;
-	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
-	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
-	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
+	if (!cpacf_test_func(&func_mask, CPACF_KMC_PAES_128) ||
+	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_192) ||
+	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_256))
 		return -ENODEV;
 
 	pkey_debug_init();
-- 
2.17.1

