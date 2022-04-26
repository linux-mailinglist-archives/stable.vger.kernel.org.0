Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAE50F63D
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiDZIwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345764AbiDZIra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271E6A76FB;
        Tue, 26 Apr 2022 01:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3C3B81CFA;
        Tue, 26 Apr 2022 08:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B769C385A0;
        Tue, 26 Apr 2022 08:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962261;
        bh=jFm8Koe9x0fNpJvJozkZL3Fjf/sZ/Xq/QG5v5NdJk2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiVnhdl66aFSCoTogcV1sAhXCMyXdu8DQ7cU95KdE9zeJej5T9huth6otwgd4/jM5
         6UfhGYps6FNIxSPfaGlzgWAoHfqpoRUN0jaImKmMB0nOIM2pmsBiSfY1cLAHs/RaU3
         hM6hZWuIGt1TZIp1695JUKCxawPD58akJK2Tlp7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Will Deacon <will@kernel.org>,
        Georgi Djakov <quic_c_gdjako@quicinc.com>
Subject: [PATCH 5.15 006/124] dma-mapping: remove bogus test for pfn_valid from dma_map_resource
Date:   Tue, 26 Apr 2022 10:20:07 +0200
Message-Id: <20220426081747.474819433@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit a9c38c5d267cb94871dfa2de5539c92025c855d7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/mapping.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -296,10 +296,6 @@ dma_addr_t dma_map_resource(struct devic
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
-	/* Don't allow RAM to be mapped */
-	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
-		return DMA_MAPPING_ERROR;
-
 	if (dma_map_direct(dev, ops))
 		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
 	else if (ops->map_resource)


