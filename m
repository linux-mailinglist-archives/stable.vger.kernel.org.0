Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A938E6BBFD7
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 23:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjCOWfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 18:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCOWf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 18:35:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE3019C70;
        Wed, 15 Mar 2023 15:35:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FMIaDt012449;
        Wed, 15 Mar 2023 22:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=BLJJy1+ZgwpNRd9swz3xcy/irzTsB/Fy3caGqVsf+bo=;
 b=cY3x5ZOWY+3lie5X/xtgZRXu/WcBc+CEjhYemSws5LlIjFnbuEMz4DOGPeDeyFpe67/4
 jIrJsvYSC9RSyu6lc6sgPXVlfQjy22UaLc/MDd1s/ZcklcYwNR34K68fXx9zKTh006nn
 MgHCnVmEuGjshSt++1NwTziH0DFH8ENruyi7z+wp1qoFg5Ibe6hnWfTA3SSvKfCt/fIQ
 wC5sYfC1hDKJPdva/Z+Vxo1qzS6AWOpepZZmWF4r9MEod8azp2nDe1IXMXHbvVg0jQSY
 Rk1fOpi8XPs3UPFxJ+AauCM/nkI0FQrafxlH0xHL07g36pRDp7ZNozyLPqY+y9L0F2Tk tQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbp4q0297-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 22:35:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FLwQIL033432;
        Wed, 15 Mar 2023 22:35:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbpde96dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 22:35:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FMZ8a5020420;
        Wed, 15 Mar 2023 22:35:08 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pbpde96dj-1;
        Wed, 15 Mar 2023 22:35:08 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     stable@vger.kernel.org
Cc:     saeed.mirzamohammadi@oracle.com, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung PM173X
Date:   Wed, 15 Mar 2023 15:34:36 -0700
Message-Id: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_12,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150001
 definitions=main-2303150184
X-Proofpoint-GUID: KZ1i8VvTwu8FNn7ESSBIxWJoDwD4WcPy
X-Proofpoint-ORIG-GUID: KZ1i8VvTwu8FNn7ESSBIxWJoDwD4WcPy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds a quirk to fix the Samsung PM1733a and PM173X reporting
bogus eui64 so they are not marked as "non globally unique" duplicates.

Cc: <stable@vger.kernel.org>
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 drivers/nvme/host/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5b95c94ee40f2..c0b1caba1c893 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3359,6 +3359,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x144d, 0xa824),   /* Samsung PM173X */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x144d, 0xa825),   /* Samsung PM1733a */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1987, 0x5012),	/* Phison E12 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
-- 
2.39.2

