Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80404E3C28
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiCVKIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiCVKIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:08:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C077E085
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:07:07 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MA6l31032215;
        Tue, 22 Mar 2022 10:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=anYyDCUmtBzcJqL38SVMqyCWWNPMlBc6J0uYMEyCqiY=;
 b=csBe69RyO8zOWjGVGZ2opSWlC+TFs7XYhRTKjZHm8GLSeFYQZnKF9xMpny66Ns/NO/Nm
 UWjK/3NvDvwWTBCRk0icYlRo4eawdxWKdjyJyJ98Sdg5shmjfA+R+5BXydaOE7XBBg7o
 PzDC7Y2CBQroAMuTM2NBnoj+ZNAHd/K2raiJg6XciHWpPwlWMVq5XsBy5+ZvCXhhPqC7
 DvlsMYLp0JDBjOPJ++C4LhrDHcpLrwBV7Lvi/sMSGxRiKAmeM263A6YCn+yey5qjXp9t
 ZvNZEKb5ox9TrqOKkpcxddU6jTwNXpgEqRj/b/RV3VrBrhMxkzxTRnSAQQfkm8A4So79 Hw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey7abe9d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:06:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22M9rKw8032112;
        Tue, 22 Mar 2022 10:02:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3ew6t8n283-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:02:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22M9ol2040698136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 09:50:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AB46A404D;
        Tue, 22 Mar 2022 10:02:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB66EA4051;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH for 5.10.x 2/2] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
Date:   Tue, 22 Mar 2022 11:02:18 +0100
Message-Id: <20220322100218.2158138-3-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322100218.2158138-1-pasic@linux.ibm.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2fUBJWBKgHxxcqXrH7pk9MiGV9Hgy6PM
X-Proofpoint-ORIG-GUID: 2fUBJWBKgHxxcqXrH7pk9MiGV9Hgy6PM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_03,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unfortunately, we ended up merging an old version of the patch "fix info
leak with DMA_FROM_DEVICE" instead of merging the latest one. Christoph
(the swiotlb maintainer), he asked me to create an incremental fix
(after I have pointed this out the mix up, and asked him for guidance).
So here we go.

The main differences between what we got and what was agreed are:
* swiotlb_sync_single_for_device is also required to do an extra bounce
* We decided not to introduce DMA_ATTR_OVERWRITE until we have exploiters
* The implantation of DMA_ATTR_OVERWRITE is flawed: DMA_ATTR_OVERWRITE
  must take precedence over DMA_ATTR_SKIP_CPU_SYNC

Thus this patch removes DMA_ATTR_OVERWRITE, and makes
swiotlb_sync_single_for_device() bounce unconditionally (that is, also
when dir == DMA_TO_DEVICE) in order do avoid synchronising back stale
data from the swiotlb buffer.

Let me note, that if the size used with dma_sync_* API is less than the
size used with dma_[un]map_*, under certain circumstances we may still
end up with swiotlb not being transparent. In that sense, this is no
perfect fix either.

To get this bullet proof, we would have to bounce the entire
mapping/bounce buffer. For that we would have to figure out the starting
address, and the size of the mapping in
swiotlb_sync_single_for_device(). While this does seem possible, there
seems to be no firm consensus on how things are supposed to work.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[pasic@linux.ibm.com: adapted for 5.10]
---
 Documentation/core-api/dma-attributes.rst |  8 --------
 include/linux/dma-mapping.h               |  8 --------
 kernel/dma/swiotlb.c                      | 25 +++++++++++++++--------
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 17706dc91ec9..1887d92e8e92 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,11 +130,3 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_OVERWRITE
-------------------
-
-This is a hint to the DMA-mapping subsystem that the device is expected to
-overwrite the entire mapped size, thus the caller does not require any of the
-previous buffer contents to be preserved. This allows bounce-buffering
-implementations to optimise DMA_FROM_DEVICE transfers.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a9361178c5db..a7d70cdee25e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,14 +61,6 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 62b1e5fa8673..efcc275aab0a 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -597,10 +597,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		io_tlb_orig_addr[index + i] = slot_addr(orig_addr, i);
 
 	tlb_addr = slot_addr(io_tlb_start, index) + offset;
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
@@ -680,11 +684,14 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
-		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			swiotlb_bounce(orig_addr, tlb_addr,
-				       size, DMA_TO_DEVICE);
-		else
-			BUG_ON(dir != DMA_FROM_DEVICE);
+		/*
+		 * Unconditional bounce is necessary to avoid corruption on
+		 * sync_*_for_cpu or dma_ummap_* when the device didn't
+		 * overwrite the whole lengt of the bounce buffer.
+		 */
+		swiotlb_bounce(orig_addr, tlb_addr,
+			       size, DMA_TO_DEVICE);
+		BUG_ON(!valid_dma_direction(dir));
 		break;
 	default:
 		BUG();
-- 
2.32.0

