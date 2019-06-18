Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0A4AAE1
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 21:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfFRTKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 15:10:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730348AbfFRTKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 15:10:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IJ858N047684
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 15:10:28 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t758msrjt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 15:10:28 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 18 Jun 2019 20:10:27 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 20:10:24 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IJANko39584084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:10:23 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F31311207E;
        Tue, 18 Jun 2019 19:10:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F287E11207C;
        Tue, 18 Jun 2019 19:10:22 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jun 2019 19:10:22 +0000 (GMT)
Subject: [PATCH V2] crypto/NX: Set receive window credits to max number of
 CRBs in RxFIFO
From:   Haren Myneni <haren@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au, herbert@gondor.apana.org.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 18 Jun 2019 12:09:22 -0700
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061819-0052-0000-0000-000003D27AC4
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011286; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01219867; UDB=6.00641674; IPR=6.01001008;
 MB=3.00027363; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-18 19:10:26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061819-0053-0000-0000-0000615F0043
Message-Id: <1560884962.22818.9.camel@hbabu-laptop>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    
System gets checkstop if RxFIFO overruns with more requests than the
maximum possible number of CRBs in FIFO at the same time. The max number
of requests per window is controlled by window credits. So find max
CRBs from FIFO size and set it to receive window credits.

Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")
CC: stable@vger.kernel.org # v4.14+   
Signed-off-by:Haren Myneni <haren@us.ibm.com>

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 4acbc47..e78ff5c 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -27,8 +27,6 @@
 #define WORKMEM_ALIGN	(CRB_ALIGN)
 #define CSB_WAIT_MAX	(5000) /* ms */
 #define VAS_RETRIES	(10)
-/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
-#define MAX_CREDITS_PER_RXFIFO	(1024)
 
 struct nx842_workmem {
 	/* Below fields must be properly aligned */
@@ -812,7 +810,11 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	rxattr.lnotify_lpid = lpid;
 	rxattr.lnotify_pid = pid;
 	rxattr.lnotify_tid = tid;
-	rxattr.wcreds_max = MAX_CREDITS_PER_RXFIFO;
+	/*
+	 * Maximum RX window credits can not be more than #CRBs in
+	 * RxFIFO. Otherwise, can get checkstop if RxFIFO overruns.
+	 */
+	rxattr.wcreds_max = fifo_size / CRB_SIZE;
 
 	/*
 	 * Open a VAS receice window which is used to configure RxFIFO
    


