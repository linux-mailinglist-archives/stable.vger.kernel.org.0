Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407EC5EB30F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 23:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiIZVZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 17:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIZVZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 17:25:30 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AFD96FD1
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 14:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664227530; x=1695763530;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/UbFaGx53MCbbq9CS7PAV/ZsvE6nQPiPuFg48sx+4tQ=;
  b=RPo/pAybEwDKzyNEG0Xvtuy3bAh5pZDtb0W71MlmhnPpLK6tB790cU/n
   m6xlPnzC3ZmQrpkKYsIhrS5UYja9V1hODoLeoSOzRSyrQ6H8HlojZLm6R
   N4M8bYj/4okGyP6gG2HvhzdOKPG5hE7h1fBN8APlrcRrv//Omjrzcqx7p
   A=;
X-IronPort-AV: E=Sophos;i="5.93,347,1654560000"; 
   d="scan'208";a="263416246"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 21:25:29 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id A34D7C0966;
        Mon, 26 Sep 2022 21:25:26 +0000 (UTC)
Received: from EX19D012UWC002.ant.amazon.com (10.13.138.165) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 26 Sep 2022 21:25:25 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D012UWC002.ant.amazon.com (10.13.138.165) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Mon, 26 Sep 2022 21:25:25 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Mon, 26 Sep 2022 21:25:24
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 5E6BF273C; Mon, 26 Sep 2022 21:25:24 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>, <sagi@grimberg.me>, <mbacco@amazon.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.15] swiotlb: max mapping size takes min align mask into account
Date:   Mon, 26 Sep 2022 21:25:04 +0000
Message-ID: <20220926212504.11671-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 018f140aaaf4..a9849670bdb5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -709,7 +709,18 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 
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
 
 bool is_swiotlb_active(struct device *dev)
-- 
2.37.1

