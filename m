Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA921A0D1F
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDGL4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 07:56:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42272 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbgDGL4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 07:56:19 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037BYREe010658
        for <stable@vger.kernel.org>; Tue, 7 Apr 2020 07:56:17 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306n2587uc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 07:56:17 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Tue, 7 Apr 2020 12:55:48 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 12:55:46 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037Bt5PU50790722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 11:55:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F29A405F;
        Tue,  7 Apr 2020 11:56:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75DDDA405C;
        Tue,  7 Apr 2020 11:56:09 +0000 (GMT)
Received: from pic2.home (unknown [9.145.146.117])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 11:56:09 +0000 (GMT)
From:   Frederic Barrat <fbarrat@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, christophe_lombard@fr.ibm.com,
        ajd@linux.ibm.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] cxl: Rework error message for incompatible slots
Date:   Tue,  7 Apr 2020 13:56:01 +0200
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040711-0020-0000-0000-000003C3440B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040711-0021-0000-0000-0000221C01C3
Message-Id: <20200407115601.25453-1-fbarrat@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_03:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=973
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070095
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Improve the error message shown if a capi adapter is plugged on a
capi-incompatible slot directly under the PHB (no intermediate switch).

Fixes: 5632874311db ("cxl: Add support for POWER9 DD2")
Cc: stable@vger.kernel.org # 4.14+
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
---
 drivers/misc/cxl/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 25a9dd9c0c1b..2ba899f5659f 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -393,8 +393,8 @@ int cxl_calc_capp_routing(struct pci_dev *dev, u64 *chipid,
 	*capp_unit_id = get_capp_unit_id(np, *phb_index);
 	of_node_put(np);
 	if (!*capp_unit_id) {
-		pr_err("cxl: invalid capp unit id (phb_index: %d)\n",
-		       *phb_index);
+		pr_err("cxl: No capp unit found for PHB[%lld,%d]. Make sure the adapter is on a capi-compatible slot\n",
+		       *chipid, *phb_index);
 		return -ENODEV;
 	}
 
-- 
2.25.1

