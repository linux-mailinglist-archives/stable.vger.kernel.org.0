Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79A4F3A3F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379430AbiDELk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354572AbiDEKOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ECC48E65;
        Tue,  5 Apr 2022 03:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD408B81C83;
        Tue,  5 Apr 2022 10:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4B1C385A1;
        Tue,  5 Apr 2022 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152880;
        bh=VwFEHE+CO5lRFmJFYl4MnPfpyZ8Welh346AwcCF/UoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flmTRyDC0QWzr7pRoMQ67lyKpYC3ZqOqKVDjk6+1UG3lZYiOld+myEh8GPRSyPYee
         NkcrNyHN3bbKjWZFfg1KvfYXx3diFaFmYkhgdAh5ReyyFcy8vgP6OUYevN/JxiWM5V
         7Frd7kMqvtL0Cj5su9v+4DSXW0370WMl/kbGNUOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 022/599] iommu/iova: Improve 32-bit free space estimate
Date:   Tue,  5 Apr 2022 09:25:16 +0200
Message-Id: <20220405070259.477224916@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 5b61343b50590fb04a3f6be2cdc4868091757262 upstream.

For various reasons based on the allocator behaviour and typical
use-cases at the time, when the max32_alloc_size optimisation was
introduced it seemed reasonable to couple the reset of the tracked
size to the update of cached32_node upon freeing a relevant IOVA.
However, since subsequent optimisations focused on helping genuine
32-bit devices make best use of even more limited address spaces, it
is now a lot more likely for cached32_node to be anywhere in a "full"
32-bit address space, and as such more likely for space to become
available from IOVAs below that node being freed.

At this point, the short-cut in __cached_rbnode_delete_update() really
doesn't hold up any more, and we need to fix the logic to reliably
provide the expected behaviour. We still want cached32_node to only move
upwards, but we should reset the allocation size if *any* 32-bit space
has become available.

Reported-by: Yunfei Wang <yf.wang@mediatek.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iova.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -138,10 +138,11 @@ __cached_rbnode_delete_update(struct iov
 	cached_iova = rb_entry(iovad->cached32_node, struct iova, node);
 	if (free == cached_iova ||
 	    (free->pfn_hi < iovad->dma_32bit_pfn &&
-	     free->pfn_lo >= cached_iova->pfn_lo)) {
+	     free->pfn_lo >= cached_iova->pfn_lo))
 		iovad->cached32_node = rb_next(&free->node);
+
+	if (free->pfn_lo < iovad->dma_32bit_pfn)
 		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
-	}
 
 	cached_iova = rb_entry(iovad->cached_node, struct iova, node);
 	if (free->pfn_lo >= cached_iova->pfn_lo)


