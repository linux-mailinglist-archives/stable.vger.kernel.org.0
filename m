Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D233A5F29F8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiJCH3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiJCH2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B7E657A;
        Mon,  3 Oct 2022 00:19:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34839B80E81;
        Mon,  3 Oct 2022 07:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCFFC433C1;
        Mon,  3 Oct 2022 07:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781486;
        bh=16kv6EE0M1hk+TTangBFeVgAF2owVYJ/Tjd+2RcjAks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=helOcA+7QYg70lyd3fTjN13WqAZH4+Pneg4myPPiAOn6X8Yse15gaaHbVf44XP8Kp
         SIJf+ug2hXZTk41UKEP8vIer8TBslav5B5qj0jB/VwY8zum5yuq2VXldBbS6O0NWpq
         f1lbETIU1BzYevkD/knssPProGM5AYdA/z+u1Fjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Christoph Hellwig <hch@lst.de>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.15 38/83] swiotlb: max mapping size takes min align mask into account
Date:   Mon,  3 Oct 2022 09:11:03 +0200
Message-Id: <20221003070722.955669891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -709,7 +709,18 @@ dma_addr_t swiotlb_map(struct device *de
 
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


