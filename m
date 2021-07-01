Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC4F3B93DA
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 17:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhGAP1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 1 Jul 2021 11:27:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232817AbhGAP1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 11:27:08 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161F371A096487;
        Thu, 1 Jul 2021 11:24:21 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39hcn8q4s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 11:24:20 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 161FDBHu024261;
        Thu, 1 Jul 2021 15:24:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 39fv59rqtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 15:24:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 161FOFtf32506352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jul 2021 15:24:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20300A405B;
        Thu,  1 Jul 2021 15:24:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE11DA4057;
        Thu,  1 Jul 2021 15:24:14 +0000 (GMT)
Received: from smtp.tlslab.ibm.com (unknown [9.101.4.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  1 Jul 2021 15:24:14 +0000 (GMT)
Received: from yukon.ibmuc.com (unknown [9.171.33.183])
        by smtp.tlslab.ibm.com (Postfix) with ESMTP id 228502200C7;
        Thu,  1 Jul 2021 17:24:14 +0200 (CEST)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] powerpc/xive: Fix error handling when allocating an IPI
Date:   Thu,  1 Jul 2021 17:24:12 +0200
Message-Id: <20210701152412.1507612-1-clg@kaod.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Vt0Cgvq0w0KBDaWNmDzss_wptDoTXsf
X-Proofpoint-ORIG-GUID: 5Vt0Cgvq0w0KBDaWNmDzss_wptDoTXsf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_08:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 clxscore=1034 mlxscore=0 mlxlogscore=511
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a smatch warning:

  arch/powerpc/sysdev/xive/common.c:1161 xive_request_ipi() warn: unsigned 'xid->irq' is never less than zero.

Fixes: fd6db2892eba ("powerpc/xive: Modernize XIVE-IPI domain with an 'alloc' handler")
Cc: stable@vger.kernel.org # v5.13
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/sysdev/xive/common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index f8ff558bc305..7bbb9bc83057 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1148,11 +1148,10 @@ static int __init xive_request_ipi(void)
 		 * Since the HW interrupt number doesn't have any meaning,
 		 * simply use the node number.
 		 */
-		xid->irq = irq_domain_alloc_irqs(ipi_domain, 1, node, &info);
-		if (xid->irq < 0) {
-			ret = xid->irq;
+		ret = irq_domain_alloc_irqs(ipi_domain, 1, node, &info);
+		if (ret < 0)
 			goto out_free_xive_ipis;
-		}
+		xid->irq = ret;
 
 		snprintf(xid->name, sizeof(xid->name), "IPI-%d", node);
 
-- 
2.31.1

