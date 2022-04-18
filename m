Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3150512B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbiDRMeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239805AbiDRMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A081B7B6;
        Mon, 18 Apr 2022 05:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6405B80EC4;
        Mon, 18 Apr 2022 12:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8CFC385A7;
        Mon, 18 Apr 2022 12:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284785;
        bh=h6KgK4UlLuqt00S7/NelzItnrRfUYPhvikAZc4K9Z2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rp2FhIxRUpBi4yq9SCzADl9s+ZGd/BMhoK1oUS57yv5Ys6IlijTrGtqYmw9arUavJ
         AyYRWVKkSpWP3HE560D6EeK+DcWadfe7i6jnOiJJnhjAa5lAPlPrARGERO0MuxifVe
         4B0s/J5kllzbBrz8IzFc41hQml/M180WNUxnkFng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Zhaoyang1 <zhaoyang1.wang@intel.com>,
        Gao Liang <liang.gao@intel.com>, Chao Gao <chao.gao@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.17 215/219] dma-direct: avoid redundant memory sync for swiotlb
Date:   Mon, 18 Apr 2022 14:13:04 +0200
Message-Id: <20220418121212.884196794@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

commit 9e02977bfad006af328add9434c8bffa40e053bb upstream.

When we looked into FIO performance with swiotlb enabled in VM, we found
swiotlb_bounce() is always called one more time than expected for each DMA
read request.

It turns out that the bounce buffer is copied to original DMA buffer twice
after the completion of a DMA request (one is done by in
dma_direct_sync_single_for_cpu(), the other by swiotlb_tbl_unmap_single()).
But the content in bounce buffer actually doesn't change between the two
rounds of copy. So, one round of copy is redundant.

Pass DMA_ATTR_SKIP_CPU_SYNC flag to swiotlb_tbl_unmap_single() to
skip the memory copy in it.

This fix increases FIO 64KB sequential read throughput in a guest with
swiotlb=force by 5.6%.

Fixes: 55897af63091 ("dma-direct: merge swiotlb_dma_ops into the dma_direct code")
Reported-by: Wang Zhaoyang1 <zhaoyang1.wang@intel.com>
Reported-by: Gao Liang <liang.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/direct.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -114,6 +114,7 @@ static inline void dma_direct_unmap_page
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 
 	if (unlikely(is_swiotlb_buffer(dev, phys)))
-		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
+		swiotlb_tbl_unmap_single(dev, phys, size, dir,
+					 attrs | DMA_ATTR_SKIP_CPU_SYNC);
 }
 #endif /* _KERNEL_DMA_DIRECT_H */


