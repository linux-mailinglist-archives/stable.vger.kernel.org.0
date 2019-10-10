Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF13D319D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfJJToy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 15:44:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbfJJToy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 15:44:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9AJgaqS012504;
        Thu, 10 Oct 2019 15:44:48 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vj9ft2v91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 15:44:48 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9AJePAo006681;
        Thu, 10 Oct 2019 19:44:47 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 2vejt7rhhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 19:44:47 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9AJijoX15925654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 19:44:46 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D79AD6A04D;
        Thu, 10 Oct 2019 19:44:45 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C836A047;
        Thu, 10 Oct 2019 19:44:45 +0000 (GMT)
Received: from oc6220003374.ibm.com (unknown [9.40.45.99])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Oct 2019 19:44:45 +0000 (GMT)
From:   KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
To:     alexander.deucher@amd.com
Cc:     stable@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Subject: [PATCH v3] drm/radeon: Fix EEH during kexec
Date:   Thu, 10 Oct 2019 14:44:29 -0500
Message-Id: <1570736672-10644-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=643 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100164
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During kexec some adapters hit an EEH since they are not properly
shut down in the radeon_pci_shutdown() function. Adding
radeon_suspend_kms() fixes this issue.
Enabled only on PPC because this patch causes issues on some other
boards.

Signed-off-by: Kyle Mahlkuch <Kyle.Mahlkuch at ibm.com>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 9e55076..4528f4d 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -379,11 +379,25 @@ static int radeon_pci_probe(struct pci_dev *pdev,
 static void
 radeon_pci_shutdown(struct pci_dev *pdev)
 {
+#ifdef CONFIG_PPC64
+	struct drm_device *ddev = pci_get_drvdata(pdev);
+#endif
+
 	/* if we are running in a VM, make sure the device
 	 * torn down properly on reboot/shutdown
 	 */
 	if (radeon_device_is_virtual())
 		radeon_pci_remove(pdev);
+
+#ifdef CONFIG_PPC64
+	/* Some adapters need to be suspended before a
+	 * shutdown occurs in order to prevent an error
+	 * during kexec.
+	 * Make this power specific becauase it breaks
+	 * some non-power boards.
+	 */
+	radeon_suspend_kms(ddev, true, true, false);
+#endif
 }
 
 static int radeon_pmops_suspend(struct device *dev)
-- 
1.8.3.1

