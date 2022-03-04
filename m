Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9474E4CD5C8
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiCDOAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 09:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239737AbiCDOAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 09:00:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8775741987;
        Fri,  4 Mar 2022 05:59:29 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224DC9wx030855;
        Fri, 4 Mar 2022 13:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tbdbV4jfCcI64Ll9xsovGUPQMa6Rsy7WC7ENFyNeiXo=;
 b=lGNtqPHhJa2/zF2kBJBa9Ydad+l1SOa9E5neTzzcanMCVS87GQF6dSZaqki8/tSlL86Y
 ZXPUmN/ACr9PQ898D/K6sVi4EFL7XCutvz/3uptAYf8ix4Axed9avsMQCMPaolF4+PNr
 4HgtdDeuYkD73MM0dqWKYn71DtCISB58scjroV6ehFqxRanbk93PrVCdYlI00qF590Q8
 nZL8qt7zyRBYUKtiLq8DNNReclmvJXy1sPs0yQtwl38Xr+IQh0Oa+0xqsTn5KTIMCoi2
 jrnvJ9eGQH+Beh2x2NY/cjyIRRjgVPdc9Nec/p83uW4UZNPnAKAXG4/hkxVBv/s1u4CG Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwguw4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224Dsx1a032665;
        Fri, 4 Mar 2022 13:59:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwguw3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224DrAON017018;
        Fri, 4 Mar 2022 13:59:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ek4k41vps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224Dx4F314418230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 13:59:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C24F1AE055;
        Fri,  4 Mar 2022 13:59:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CDB5AE053;
        Fri,  4 Mar 2022 13:59:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 13:59:04 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Ali Haider <ali.haider@ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/2] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Fri,  4 Mar 2022 14:58:59 +0100
Message-Id: <20220304135859.3521513-3-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220304135859.3521513-1-pasic@linux.ibm.com>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 14w4vaCXOMb7OTrL_DJSWH5EqyecwcT8
X-Proofpoint-ORIG-GUID: EvzG-f6FcSwrNA-oUVjwim270ocPDb6w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_02,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
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

This is an swiotlb problem, because the swiotlb should be transparent in
a sense that it does not affect the outcome (if all other participants
are well behaved), and without swiotlb we leak all zeros.  Even if
swiotlb_tbl_map_single() zero-initialised the allocated slot(s) to avoid
leaking stale data back to the caller later, when it comes to unmap or
sync_for_cpu it still fundamentally cannot tell how much of the contents
of the bounce slot have actually changed, therefore if the caller was
expecting the device to do a partial write, the rest of the mapped
buffer *will* be corrupted by bouncing the whole thing back again.

Copying the content of the original buffer into the swiotlb buffer is
the only way I can think of to make swiotlb transparent in such
scenarios. So let's do just that.

The extra bounce is expected to hurt the performance. For the cases
where the extra bounce is not necessary we could get rid of it, if we
were told by the client code, that it is not needed. Such optimisations
are out of scope for this patch, and are likely to be a subject of some
future work.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Ali Haider <ali.haider@ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 kernel/dma/swiotlb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f1e7ea160b43..6db1c475ec82 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -627,9 +627,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		mem->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(mem->start, index) + offset;
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
@@ -696,10 +701,13 @@ void swiotlb_tbl_unmap_single(struct device *dev, phys_addr_t tlb_addr,
 void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
-	else
-		BUG_ON(dir != DMA_FROM_DEVICE);
+	/*
+	 * Unconditional bounce is necessary to avoid corruption on
+	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
+	 * the whole lengt of the bounce buffer.
+	 */
+	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
+	BUG_ON(!valid_dma_direction(dir));
 }
 
 void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,
-- 
2.32.0

