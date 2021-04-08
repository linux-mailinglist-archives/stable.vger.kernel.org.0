Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1435810A
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 12:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDHKqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 06:46:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229751AbhDHKqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 06:46:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138AXWod178022;
        Thu, 8 Apr 2021 06:46:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=FBedhqabAR9ndUezuL/L0WFLGfqv4MIWhnlhVtE44hI=;
 b=LZCleAM/auTHOh80dvQb8/hYNPyHld8l9qYGgKlCDVSPx7RMRTnyGFwLUug7hWMVsrO7
 2MEXGV0TkuBruZDmGvldz/enmOONyQZ/ORvQEpVxCpsWsAPYciaE9z6tUPoQmO0legyT
 ZdMOXFyqXF9wFrUgZ+T5jD/xgb/ZtbJdsIiRDnaRGMjDPoi1qYwlwFBlc1kyl5nAoNaX
 FvjPYpjfzjIeN/RJxUMgpu0XhDSueViSFv5KwLiq3DF5czZPhVkPDHIU6SVfOjMjqrLM
 EvaA03OJVhZgiCG+OV0I1+793Bp01DkiESoc5OrzhRGSW4ZCBwXgHiWxYWgqnBMznmuP tg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvy8467m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 06:46:32 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 138AhAM2018402;
        Thu, 8 Apr 2021 10:46:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 37rvc5gt4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 10:46:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 138AkR8N56820140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 10:46:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14EE342045;
        Thu,  8 Apr 2021 10:46:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 385EF42047;
        Thu,  8 Apr 2021 10:46:24 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.70.62])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  8 Apr 2021 10:46:23 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Thu, 08 Apr 2021 16:16:23 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     linux-nvdimm@lists.01.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Santosh Sivaraj <santosh@fossix.org>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to handle explicit 'flush' callbacks
Date:   Thu,  8 Apr 2021 16:16:22 +0530
Message-Id: <20210408104622.943843-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oXgTDmTAy3WrKeJ9KSJZjVmEgRT-6SXp
X-Proofpoint-ORIG-GUID: oXgTDmTAy3WrKeJ9KSJZjVmEgRT-6SXp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_02:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=809
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080071
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case a platform doesn't provide explicit flush-hints but provides an
explicit flush callback, then nvdimm_has_flush() still returns '0'
indicating that writes do not require flushing. This happens on PPC64
with patch at [1] applied, where 'deep_flush' of a region was denied
even though an explicit flush function was provided.

Similar problem is also seen with virtio-pmem where the 'deep_flush'
sysfs attribute is not visible as in absence of any registered nvdimm,
'nd_region->ndr_mappings == 0'.

Fix this by updating nvdimm_has_flush() adding a condition to
nvdimm_has_flush() to test if a 'region->flush' callback is
assigned. Also remove explicit test for 'nd_region->ndr_mapping' since
regions may need 'flush' without any explicit mappings as in case of
virtio-pmem.

References:
[1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399582101498.stgit@e1fbed493c87

Cc: <stable@vger.kernel.org>
Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

v3:
* Removed the test for ND_REGION_SYNC to handle case where a
  synchronous region still wants to expose a deep-flush function.
  [ Aneesh ]
* Updated patch title and description from previous patch
  https://lore.kernel.org/linux-nvdimm/5e64778d-bf48-9f10-7d3d-5e530e5db590@linux.ibm.com

v2:
* Added the fixes tag and addressed the patch to stable tree [ Aneesh ]
* Updated patch description to address the virtio-pmem case.
* Removed test for 'nd_region->ndr_mappings' from beginning of
  nvdimm_has_flush() to handle the virtio-pmem case.
---
 drivers/nvdimm/region_devs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ef23119db574..c4b17bdd527f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1234,11 +1234,15 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 {
 	int i;
 
-	/* no nvdimm or pmem api == flushing capability unknown */
-	if (nd_region->ndr_mappings == 0
-			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
+	/* no pmem api == flushing capability unknown */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
 		return -ENXIO;
 
+	/* Test if an explicit flush function is defined */
+	if (nd_region->flush)
+		return 1;
+
+	/* Test if any flush hints for the region are available */
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -1249,8 +1253,8 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 	}
 
 	/*
-	 * The platform defines dimm devices without hints, assume
-	 * platform persistence mechanism like ADR
+	 * The platform defines dimm devices without hints nor explicit flush,
+	 * assume platform persistence mechanism like ADR
 	 */
 	return 0;
 }
-- 
2.30.2

