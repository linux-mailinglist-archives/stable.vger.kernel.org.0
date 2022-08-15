Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93CB594C0E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiHPAq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245146AbiHPAnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB7ED41B6;
        Mon, 15 Aug 2022 13:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBAE2B8113E;
        Mon, 15 Aug 2022 20:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFE0C433C1;
        Mon, 15 Aug 2022 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596021;
        bh=2TB88MHsu1Xh+jypbMXWSsaOFWNOriUCzj5MZUghOAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy1K5d/BSZm5WQBG7ZL+PLnupo2c3QOkcnunrFkOkp/c033bLp1jYLp59qJbXF0It
         56zqP/An9gk16atD854Ze0OdFBmS76usc3hPwQQKt7B4p7BSDBMFA9xFb+4op1S0cQ
         Oy+tBXFiTKblhYvSB6b95wGg4E32Bfu+BLTJPvVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0949/1157] swiotlb: fail map correctly with failed io_tlb_default_mem
Date:   Mon, 15 Aug 2022 20:05:05 +0200
Message-Id: <20220815180517.523648968@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit c51ba246cb172c9e947dc6fb8868a1eaf0b2a913 ]

In the failure case of trying to use a buffer which we'd previously
failed to allocate, the "!mem" condition is no longer sufficient since
io_tlb_default_mem became static and assigned by default. Update the
condition to work as intended per the rest of that conversion.

Fixes: 463e862ac63e ("swiotlb: Convert io_default_tlb_mem to static allocation")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index cb50f8d38360..5830dce6081b 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -580,7 +580,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	int index;
 	phys_addr_t tlb_addr;
 
-	if (!mem)
+	if (!mem || !mem->nslabs)
 		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
 
 	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
-- 
2.35.1



