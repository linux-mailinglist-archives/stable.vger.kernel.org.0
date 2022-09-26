Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32DA5EB2FD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 23:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiIZVUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 17:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIZVUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 17:20:06 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E362F5E331
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 14:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664227206; x=1695763206;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n222fmlUIoM5X6kzIDj/By1nehkuRiCTnw8q9NuDnXo=;
  b=DPL4A8209lSd1n3rbLWJA2KgqihPNMqOzFqExbdJXIoSZwirFOyaIfvH
   lU2ISYFEO6EAYfEOoTV1JInLJ7PhES4OmEAxsTWLSoq38nPTr3itVXZtk
   Bqnlym6NBlEM1DkrQ23ksOpxgovkcr0Mz86bACkURUeG1Ve2tABVLtSMj
   w=;
X-IronPort-AV: E=Sophos;i="5.93,347,1654560000"; 
   d="scan'208";a="134192112"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 21:20:05 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com (Postfix) with ESMTPS id EF35E929A2;
        Mon, 26 Sep 2022 21:20:02 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 26 Sep 2022 21:19:53 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 26 Sep 2022 21:19:53 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Mon, 26 Sep 2022 21:19:52
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id A52D7273C; Mon, 26 Sep 2022 21:19:51 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>, <sagi@grimberg.me>, <mbacco@amazon.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.10] swiotlb: max mapping size takes min align mask into account
Date:   Mon, 26 Sep 2022 21:19:28 +0000
Message-ID: <20220926211928.8186-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit 82806744fd7dde603b64c151eeddaa4ee62193fd upstream.

swiotlb_find_slots() skips slots according to io tlb aligned mask
calculated from min aligned mask and original physical address
offset. This affects max mapping size. The mapping size can't
achieve the IO_TLB_SEGSIZE * IO_TLB_SIZE when original offset is
non-zero. This will cause system boot up failure in Hyper-V
Isolation VM where swiotlb force is enabled. Scsi layer use return
value of dma_max_mapping_size() to set max segment size and it
finally calls swiotlb_max_mapping_size(). Hyper-V storage driver
sets min align mask to 4k - 1. Scsi layer may pass 256k length of
request buffer with 0~4k offset and Hyper-V storage driver can't
get swiotlb bounce buffer via DMA API. Swiotlb_find_slots() can't
find 256k length bounce buffer with offset. Make swiotlb_max_mapping
_size() take min align mask into account.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/dma/swiotlb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 4a9831d01f0e..d897d161366a 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -734,7 +734,18 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 
 size_t swiotlb_max_mapping_size(struct device *dev)
 {
-	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE;
+	int min_align_mask = dma_get_min_align_mask(dev);
+	int min_align = 0;
+
+	/*
+	 * swiotlb_find_slots() skips slots according to
+	 * min align mask. This affects max mapping size.
+	 * Take it into acount here.
+	 */
+	if (min_align_mask)
+		min_align = roundup(min_align_mask, IO_TLB_SIZE);
+
+	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE - min_align;
 }
 
 bool is_swiotlb_active(void)
-- 
2.37.1

