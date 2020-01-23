Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D861460E7
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 04:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgAWDTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 22:19:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbgAWDTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 22:19:36 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00N376IC032190
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 22:19:35 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xp95g6g42-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 22:19:34 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <vaibhav@linux.ibm.com>;
        Thu, 23 Jan 2020 03:19:33 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Jan 2020 03:19:30 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00N3JS4f66650304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 03:19:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 756C44204F;
        Thu, 23 Jan 2020 03:19:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E8BB42041;
        Thu, 23 Jan 2020 03:19:26 +0000 (GMT)
Received: from vajain21.in.ibm.com.com (unknown [9.85.93.69])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jan 2020 03:19:26 +0000 (GMT)
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Oliver O'Halloran" <oohall@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] libnvdimm/of_pmem: Fix leaking bus_desc.provider_name in some paths
Date:   Thu, 23 Jan 2020 08:48:47 +0530
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20012303-0020-0000-0000-000003A32B30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012303-0021-0000-0000-000021FAC29C
Message-Id: <20200123031847.149325-1-vaibhav@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230026
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

String 'bus_desc.provider_name' allocated inside
of_pmem_region_probe() will leak in case call to nvdimm_bus_register()
fails or when of_pmem_region_remove() is called.

This minor patch ensures that 'bus_desc.provider_name' is freed in
error path for of_pmem_region_probe() as well as in
of_pmem_region_remove().

Cc: stable@vger.kernel.org
Fixes:49bddc73d15c2("libnvdimm/of_pmem: Provide a unique name for bus provider")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 drivers/nvdimm/of_pmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 8224d1431ea9..9cb76f9837ad 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -36,6 +36,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 
 	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
 	if (!bus) {
+		kfree(priv->bus_desc.provider_name);
 		kfree(priv);
 		return -ENODEV;
 	}
@@ -81,6 +82,7 @@ static int of_pmem_region_remove(struct platform_device *pdev)
 	struct of_pmem_private *priv = platform_get_drvdata(pdev);
 
 	nvdimm_bus_unregister(priv->bus);
+	kfree(priv->bus_desc.provider_name);
 	kfree(priv);
 
 	return 0;
-- 
2.24.1

