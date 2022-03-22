Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADEA4E3C1D
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiCVKEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiCVKEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:04:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8E87EB0D
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:02:44 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M8JwYi018167;
        Tue, 22 Mar 2022 10:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2k3cm8ywVVpFJgV9lmWtXm2Oy+LOQKK99g+cGLBgo6s=;
 b=EEV/Xp9976q6xFEZxgx2czEIQW9uDAMES0vmU1tC58y5wi3EPs69me1nNRhqv7nWwTXK
 //w0/c2CnPKUmPFqIoqIf4uTG6I93dH3o7reVNFuuZU1tnhJMG0W8GpaT8W9SSmQGrVY
 qGllU1e7vJUaJ8oHZZEizM9c8oqIy9ktXgEnvmH1nyzfBnuCMZcwLqJhByzECLI0tLgc
 5UgZDI02oGAtJSajmQDvwUSxQh9AG6igpNxx+Q0QLpAy/noMrb/CngzWK0RyvWWKDG7I
 DDVHs8394LrBKXwVA/F23eAtzt4qqlar9JW23Qo5WNm+iUt9uT/+neEpu5RpZB0Behfb YA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautj4xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:02:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22M9rOTh025894;
        Tue, 22 Mar 2022 10:02:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t8wurc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:02:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MA2VIL38011200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 10:02:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADAB9A4055;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D7FA404D;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH for 5.10.x 1/2] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Tue, 22 Mar 2022 11:02:17 +0100
Message-Id: <20220322100218.2158138-2-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322100218.2158138-1-pasic@linux.ibm.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 58kkBdlrhRFOQqfpFmpsWnQ_4TF-OMgl
X-Proofpoint-ORIG-GUID: 58kkBdlrhRFOQqfpFmpsWnQ_4TF-OMgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_03,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The problem I'm addressing was discovered by the LTP test covering
cve-2018-1000204.

A short description of what happens follows:
1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
   interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
   and a corresponding dxferp. The peculiar thing about this is that TUR
   is not reading from the device.
2) In sg_start_req() the invocation of blk_rq_map_user() effectively
   bounces the user-space buffer. As if the device was to transfer into
   it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
   sg_build_indirect()") we make sure this first bounce buffer is
   allocated with GFP_ZERO.
3) For the rest of the story we keep ignoring that we have a TUR, so the
   device won't touch the buffer we prepare as if the we had a
   DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
   and the  buffer allocated by SG is mapped by the function
   virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
   scatter-gather and not scsi generics). This mapping involves bouncing
   via the swiotlb (we need swiotlb to do virtio in protected guest like
   s390 Secure Execution, or AMD SEV).
4) When the SCSI TUR is done, we first copy back the content of the second
   (that is swiotlb) bounce buffer (which most likely contains some
   previous IO data), to the first bounce buffer, which contains all
   zeros.  Then we copy back the content of the first bounce buffer to
   the user-space buffer.
5) The test case detects that the buffer, which it zero-initialized,
  ain't all zeros and fails.

One can argue that this is an swiotlb problem, because without swiotlb
we leak all zeros, and the swiotlb should be transparent in a sense that
it does not affect the outcome (if all other participants are well
behaved).

Copying the content of the original buffer into the swiotlb buffer is
the only way I can think of to make swiotlb transparent in such
scenarios. So let's do just that if in doubt, but allow the driver
to tell us that the whole mapped buffer is going to be overwritten,
in which case we can preserve the old behavior and avoid the performance
impact of the extra bounce.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
[pasic@linux.ibm.com: resolved merge conflicts]
---
 Documentation/core-api/dma-attributes.rst | 8 ++++++++
 include/linux/dma-mapping.h               | 8 ++++++++
 kernel/dma/swiotlb.c                      | 3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1887d92e8e92..17706dc91ec9 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,3 +130,11 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_OVERWRITE
+------------------
+
+This is a hint to the DMA-mapping subsystem that the device is expected to
+overwrite the entire mapped size, thus the caller does not require any of the
+previous buffer contents to be preserved. This allows bounce-buffering
+implementations to optimise DMA_FROM_DEVICE transfers.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a7d70cdee25e..a9361178c5db 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,6 +61,14 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * This is a hint to the DMA-mapping subsystem that the device is expected
+ * to overwrite the entire mapped size, thus the caller does not require any
+ * of the previous buffer contents to be preserved. This allows
+ * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
+ */
+#define DMA_ATTR_OVERWRITE		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0ed0e1f215c7..62b1e5fa8673 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -598,7 +598,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 
 	tlb_addr = slot_addr(io_tlb_start, index) + offset;
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
-- 
2.32.0

