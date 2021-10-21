Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB94363DB
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhJUOQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 10:16:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59066 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhJUOQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 10:16:04 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBJTm028326
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+S6/frc8cgx1g/Con5LBdAi9LwkCHw5rJ0tej71+9Go=;
 b=hLLh7y33Zwi+5eFv2HrdJFtaBHCw+PqHHpn+yufORD0xmLOgF5A2/Kmw8PSwRAEvS9/X
 zZHjiN4furZoEzAYwBRXn61+GuOoCBpo2nyXGByF6bgXT+uQtsB0xj9FmQsx9COUKECa
 6FNjkj9rQzGcJnn5cSXayvQBXbxLAvIDsrEK9oIFV/Fn4O2tK1PaQ9SmsLiqdMxmCnnk
 o2qHtPB7NQhFzk/YubThZ16g53zYmEZJNOCbTYR+/eQByPWmMiDQhMeDGCEM2k+87wOO
 GNELGMQpjr6OANND2dwpZSVc33Or82dF1COrbgltRgeaovX3cSLRL1zzryslggELFoeF Bw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu9fmrk3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 10:13:48 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LE8Lp2009413
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcb7raa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 14:13:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LEDgwO1966676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:13:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64C46AE061;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B58AE063;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 14:13:42 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 5.14 1/2] s390/pci: cleanup resources only if necessary
Date:   Thu, 21 Oct 2021 16:13:40 +0200
Message-Id: <20211021141341.344756-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021141341.344756-1-schnelle@linux.ibm.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2WgI1BZs6c4yapvdZD_X4r5Fk1TNArui
X-Proofpoint-GUID: 2WgI1BZs6c4yapvdZD_X4r5Fk1TNArui
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=636 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 023cc3cb1e4baa8d1900a4f2e999701c82ce2b6c upstream.

It's currently safe to call zpci_cleanup_bus_resources() even if the
resources were never created but it makes no sense so check
zdev->has_resources before we call zpci_cleanup_bus_resources() in
zpci_release_device().

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
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

