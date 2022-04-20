Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA0508860
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiDTMqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237999AbiDTMqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:46:39 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161E6201B2
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650458634; x=1681994634;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=LBcV0/cV31qWGIIVxxIEtffDZLby3XV/liKOUCV3+uM=;
  b=ol4NMq0jWC8kNQRv6HgIMCvNy6diw3hKDTGUTqJPeH5xMmfW6AhjE0ey
   3QeKctgK5ri7SIi4Q+cdRmY8w+RlEs0vc0t2wff631qH/NoqRAeCWutW4
   ZV2iA4lGoXw1TxalK9wsthfYPTPfv/S4HNjYOeFRg6w1QKKOg2Muv4i1B
   0=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Apr 2022 05:43:53 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 05:43:52 -0700
Received: from hu-c-gdjako-lv.qualcomm.com (10.49.16.6) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Apr 2022 05:43:52 -0700
From:   Georgi Djakov <quic_c_gdjako@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@linux.ibm.com>, <anshuman.khandual@arm.com>,
        <david@redhat.com>, <will@kernel.org>, <catalin.marinas@arm.com>,
        <hch@lst.de>, <akpm@linux-foundation.org>, <surenb@google.com>,
        <quic_sudaraja@quicinc.com>, <djakov@kernel.org>
Subject: [PATCH 5.15 1/2] dma-mapping: remove bogus test for pfn_valid from dma_map_resource
Date:   Wed, 20 Apr 2022 05:43:40 -0700
Message-ID: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit a9c38c5d267cb94871dfa2de5539c92025c855d7 ]

dma_map_resource() uses pfn_valid() to ensure the range is not RAM.
However, pfn_valid() only checks for availability of the memory map for a
PFN but it does not ensure that the PFN is actually backed by RAM.

As dma_map_resource() is the only method in DMA mapping APIs that has this
check, simply drop the pfn_valid() test from dma_map_resource().

Link: https://lore.kernel.org/all/20210824173741.GC623@arm.com/
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20210930013039.11260-2-rppt@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com
Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
---
 kernel/dma/mapping.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 8349a9f2c345..9478eccd1c8e 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -296,10 +296,6 @@ dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
-	/* Don't allow RAM to be mapped */
-	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
-		return DMA_MAPPING_ERROR;
-
 	if (dma_map_direct(dev, ops))
 		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
 	else if (ops->map_resource)
