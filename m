Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A331291E
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 09:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfECHxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 03:53:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbfECHxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 03:53:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x437qQel107357
        for <stable@vger.kernel.org>; Fri, 3 May 2019 03:53:18 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s8fyu3jsx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 03 May 2019 03:53:18 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Fri, 3 May 2019 08:53:15 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 May 2019 08:53:12 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x437rBFT46268532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 May 2019 07:53:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE469AE045;
        Fri,  3 May 2019 07:53:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 807F7AE051;
        Fri,  3 May 2019 07:53:11 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 May 2019 07:53:11 +0000 (GMT)
Received: from intelligence.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 79FF3A0241;
        Fri,  3 May 2019 17:53:10 +1000 (AEST)
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Stewart Smith <stewart@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2] powerpc/powernv: Restrict OPAL symbol map to only be readable by root
Date:   Fri,  3 May 2019 17:52:53 +1000
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050307-0028-0000-0000-00000369D60F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050307-0029-0000-0000-0000242943E4
Message-Id: <20190503075253.22798-1-ajd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030051
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the OPAL symbol map is globally readable, which seems bad as it
contains physical addresses.

Restrict it to root.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jordan Niethe <jniethe5@gmail.com>
Cc: Stewart Smith <stewart@linux.ibm.com>
Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

---

v1->v2:

- fix tabs vs spaces (Greg)
---
 arch/powerpc/platforms/powernv/opal.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 2b0eca104f86..0582a02623d0 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -681,7 +681,10 @@ static ssize_t symbol_map_read(struct file *fp, struct kobject *kobj,
 				       bin_attr->size);
 }
 
-static BIN_ATTR_RO(symbol_map, 0);
+static struct bin_attribute symbol_map_attr = {
+	.attr = {.name = "symbol_map", .mode = 0400},
+	.read = symbol_map_read
+};
 
 static void opal_export_symmap(void)
 {
@@ -698,10 +701,10 @@ static void opal_export_symmap(void)
 		return;
 
 	/* Setup attributes */
-	bin_attr_symbol_map.private = __va(be64_to_cpu(syms[0]));
-	bin_attr_symbol_map.size = be64_to_cpu(syms[1]);
+	symbol_map_attr.private = __va(be64_to_cpu(syms[0]));
+	symbol_map_attr.size = be64_to_cpu(syms[1]);
 
-	rc = sysfs_create_bin_file(opal_kobj, &bin_attr_symbol_map);
+	rc = sysfs_create_bin_file(opal_kobj, &symbol_map_attr);
 	if (rc)
 		pr_warn("Error %d creating OPAL symbols file\n", rc);
 }
-- 
2.20.1

