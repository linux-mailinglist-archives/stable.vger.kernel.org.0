Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31AF43919D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhJYIol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:44:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhJYIol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:44:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P7oG3X003534
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 04:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yVJHcpygom9/Bv53WPPa4vjZg+CyydfkimVaS0uQfUM=;
 b=aOeUn9iyXVlFMXnBUSkDaXTWZDJtROw8iM13xheh69UC9DhzOVU3CwdxilH1/xMqqKSP
 YK0zOVCtkW5OAVPJ5wZdgvs25eOcnzj9B/1VjEAgIJ2pC7ICyeMf2gIcLOM90cLYwUc7
 odnjl0vvXqi86sxWZSLljSu/4lJNQeAtCNsHxCT8KPVCrSprW9Pirp8Csp6yfBGHg00V
 xupOptbzXmysrl9vSZOIUIfOAyvyPGkIGnw6oRv8aobXt8HeIy0yvgbq1SsjI1ZGRJwp
 ZyRywWB0muFUsuKowIayqovy17zDH4BYIRkpavMmu0k2rfW0AUrxNvR0yI8ZjSwFW4Ls 3A== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvydfvqh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 04:42:18 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8Yu6G001771
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 08:42:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bva19j4jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 08:42:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8gCAr40436210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:42:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFB2F4C040;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 944794C059;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 08:42:12 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v2 5.14 1/2] s390/pci: cleanup resources only if necessary
Date:   Mon, 25 Oct 2021 10:42:11 +0200
Message-Id: <20211025084212.3366683-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025084212.3366683-1-schnelle@linux.ibm.com>
References: <20211025084212.3366683-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SS6jaZezYvApBCj9umqQ3gCwhWfFzjZR
X-Proofpoint-GUID: SS6jaZezYvApBCj9umqQ3gCwhWfFzjZR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=607
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 02368b7cf6c7badefa13741aed7a8b91d9a11b19 upstream.

It's currently safe to call zpci_cleanup_bus_resources() even if the
resources were never created but it makes no sense so check
zdev->has_resources before we call zpci_cleanup_bus_resources() in
zpci_release_device().

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
v1->v2:
- Correct upstream commit hash

 arch/s390/pci/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 34839bad33e4..5e234cb2ad7b 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -829,7 +829,8 @@ void zpci_release_device(struct kref *kref)
 	case ZPCI_FN_STATE_STANDBY:
 		if (zdev->has_hp_slot)
 			zpci_exit_slot(zdev);
-		zpci_cleanup_bus_resources(zdev);
+		if (zdev->has_resources)
+			zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
 		zpci_destroy_iommu(zdev);
 		fallthrough;
-- 
2.25.1

