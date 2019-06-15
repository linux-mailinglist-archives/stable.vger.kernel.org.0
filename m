Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE1246F12
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 10:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFOIkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 04:40:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbfFOIkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 04:40:03 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5F8WFZn149219
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 04:40:02 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t4ta06qs1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 04:40:02 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 15 Jun 2019 09:40:01 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 15 Jun 2019 09:39:59 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5F8dwpA32899392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jun 2019 08:39:58 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2670A124052;
        Sat, 15 Jun 2019 08:39:58 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF5A124053;
        Sat, 15 Jun 2019 08:39:57 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 15 Jun 2019 08:39:57 +0000 (GMT)
Subject: crypto/NX: Set receive window credits to max number of CRBs in
 RxFIFO
From:   Haren Myneni <haren@linux.vnet.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>, mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date:   Sat, 15 Jun 2019 01:39:02 -0700
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061508-0052-0000-0000-000003D14D15
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011265; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01218225; UDB=6.00640686; IPR=6.00999361;
 MB=3.00027320; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-15 08:40:00
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061508-0053-0000-0000-00006155825F
Message-Id: <1560587942.17547.18.camel@hbabu-laptop>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150079
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    
System gets checkstop if RxFIFO overruns with more requests than the
maximum possible number of CRBs in FIFO at the same time. So find max
CRBs from FIFO size and set it to receive window credits.
   
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


