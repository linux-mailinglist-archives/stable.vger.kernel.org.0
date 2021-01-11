Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF392F1C71
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbhAKRcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:32:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38840 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389452AbhAKRcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 12:32:16 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BH474D044453
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=yFZRcqGQcx35gUSaEebh5dWRCDUG+R6UG3UQoprpPuE=;
 b=TgrPIpvhQIfKBR/dtOJJpKmd05OAlW0bY47fVix3NVbhQaMY1ihPsNGYqzLy7+Pz3dU3
 C3DY5f5x2x6i7I2ALYJ3WmkFT98olF2A3f9O0bqYTLJxOjEUthySxLNliIUPozk1wTxz
 H8nyB3zeCzsp2WzZuhVfBFOopyCx1oK0oVKMUMTlVBQPa51AA3tpPLIc8VS3MwYREDP3
 jYvWA9aEMPf1uJeoqfnHwfXA+yk8yRuifj4jVJgrxZf4m5Re6QwvM5zm+sdlbf7GCmI7
 83xinA1hO+lecMMu+KkxJmyG0fj7lgoUxgGQe2gjp2ofMocKKCw4yNbgtPmjz3A4/zF9 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xvmck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:34 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BH4BaM044821
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:34 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xvmcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 12:31:34 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BHN7ve031154;
        Mon, 11 Jan 2021 17:31:34 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 35y448r798-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:31:34 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BHVXr824904110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 17:31:33 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3429E136051;
        Mon, 11 Jan 2021 17:31:33 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A3F213604F;
        Mon, 11 Jan 2021 17:31:32 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.159.40])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 17:31:32 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com
Subject: [PATCH] vfio iommu: Add dma available capability
Date:   Mon, 11 Jan 2021 12:31:28 -0500
Message-Id: <1610386288-26220-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610386288-26220-1-git-send-email-mjrosato@linux.ibm.com>
References: <1610386288-26220-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 mlxlogscore=878 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7d6e1329652ed971d1b6e0e7bea66fba5044e271 ]

The following functional changes were needed for backport:
- vfio_iommu_type1_get_info doesn't exist, call
  vfio_iommu_dma_avail_build_caps from vfio_iommu_type1_ioctl.
- As further fallout from this, vfio_iommu_dma_avail_build_caps must
  acquire and release the iommu mutex lock.  To do so, the return value is
  stored in a local variable as in vfio_iommu_iova_build_caps.

Upstream commit description:
Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
added the ability to limit the number of memory backed DMA mappings.
However on s390x, when lazy mapping is in use, we use a very large
number of concurrent mappings.  Let's provide the current allowable
number of DMA mappings to userspace via the IOMMU info chain so that
userspace can take appropriate mitigation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 15 +++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3b31e83..bc6ba41 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2303,6 +2303,24 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_dma_avail_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_dma_avail cap_dma_avail;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	cap_dma_avail.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL;
+	cap_dma_avail.header.version = 1;
+
+	cap_dma_avail.avail = iommu->dma_avail;
+
+	ret = vfio_info_add_capability(caps, &cap_dma_avail.header,
+				       sizeof(cap_dma_avail));
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2349,6 +2367,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
+
+		if (!ret)
+			ret = vfio_iommu_dma_avail_build_caps(iommu, &caps);
+
 		if (ret)
 			return ret;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a1..cabc931 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -748,6 +748,21 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+/*
+ * The DMA available capability allows to report the current number of
+ * simultaneously outstanding DMA mappings that are allowed.
+ *
+ * The structure below defines version 1 of this capability.
+ *
+ * avail: specifies the current number of outstanding DMA mappings allowed.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
+
+struct vfio_iommu_type1_info_dma_avail {
+	struct	vfio_info_cap_header header;
+	__u32	avail;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
1.8.3.1

