Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011D4E5543
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfJYUk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 16:40:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726453AbfJYUk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 16:40:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PKbUmD186123;
        Fri, 25 Oct 2019 16:40:55 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv4knf1fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 16:40:55 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9PKeGar023843;
        Fri, 25 Oct 2019 20:40:54 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 2vqt48kme7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 20:40:54 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PKernt54002120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 20:40:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 747C26E04E;
        Fri, 25 Oct 2019 20:40:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2523E6E04C;
        Fri, 25 Oct 2019 20:40:53 +0000 (GMT)
Received: from oc6220003374.ibm.com (unknown [9.40.45.99])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 20:40:52 +0000 (GMT)
From:   KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
To:     alexander.deucher@amd.com
Cc:     stable@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
Subject: [PATCH v3] drm/radeon: Fix EEH during kexec
Date:   Fri, 25 Oct 2019 15:40:50 -0500
Message-Id: <1572036050-18945-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=692 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250189
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>

During kexec some adapters hit an EEH since they are not properly
shut down in the radeon_pci_shutdown() function. Adding
radeon_suspend_kms() fixes this issue.
Enabled only on PPC because this patch causes issues on some other
boards.

Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
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

