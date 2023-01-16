Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F9C66C4B7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjAPP5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjAPP5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290261EFC3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB59561043
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE170C433D2;
        Mon, 16 Jan 2023 15:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884639;
        bh=rLuGTVHTJIk3M2IlQc0GL/2gpd1ktQ6uLCeAUWqKeGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxtJKD8GtmKhyXbLiPN5JUKoY/lSPCtbYqkUKv/p3JysSGGA5OhSd/E6BojDhbz6j
         WCFQsbp/yVkJIlef3cmA1WXyLt3Skqpjy1GPYPeeFcnJVhv4PBymuIxYRm3eM/wPOD
         q8iWOIfUbA8ge6TJSeC8Id205PsrqD9WbEdSCbLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        jianjiao zeng <jianjiao.zeng@mediatek.com>,
        Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 083/183] iommu/iova: Fix alloc iova overflows issue
Date:   Mon, 16 Jan 2023 16:50:06 +0100
Message-Id: <20230116154806.949144694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Yunfei Wang <yf.wang@mediatek.com>

commit dcdb3ba7e2a8caae7bfefd603bc22fd0ce9a389c upstream.

In __alloc_and_insert_iova_range, there is an issue that retry_pfn
overflows. The value of iovad->anchor.pfn_hi is ~0UL, then when
iovad->cached_node is iovad->anchor, curr_iova->pfn_hi + 1 will
overflow. As a result, if the retry logic is executed, low_pfn is
updated to 0, and then new_pfn < low_pfn returns false to make the
allocation successful.

This issue occurs in the following two situations:
1. The first iova size exceeds the domain size. When initializing
iova domain, iovad->cached_node is assigned as iovad->anchor. For
example, the iova domain size is 10M, start_pfn is 0x1_F000_0000,
and the iova size allocated for the first time is 11M. The
following is the log information, new->pfn_lo is smaller than
iovad->cached_node.

Example log as follows:
[  223.798112][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
start_pfn:0x1f0000,retry_pfn:0x0,size:0xb00,limit_pfn:0x1f0a00
[  223.799590][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
success start_pfn:0x1f0000,new->pfn_lo:0x1efe00,new->pfn_hi:0x1f08ff

2. The node with the largest iova->pfn_lo value in the iova domain
is deleted, iovad->cached_node will be updated to iovad->anchor,
and then the alloc iova size exceeds the maximum iova size that can
be allocated in the domain.

After judging that retry_pfn is less than limit_pfn, call retry_pfn+1
to fix the overflow issue.

Signed-off-by: jianjiao zeng <jianjiao.zeng@mediatek.com>
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.15.*
Fixes: 4e89dce72521 ("iommu/iova: Retry from last rb tree node if iova search fails")
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20230111063801.25107-1-yf.wang@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iova.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -197,7 +197,7 @@ static int __alloc_and_insert_iova_range
 
 	curr = __get_cached_rbnode(iovad, limit_pfn);
 	curr_iova = to_iova(curr);
-	retry_pfn = curr_iova->pfn_hi + 1;
+	retry_pfn = curr_iova->pfn_hi;
 
 retry:
 	do {
@@ -211,7 +211,7 @@ retry:
 	if (high_pfn < size || new_pfn < low_pfn) {
 		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
 			high_pfn = limit_pfn;
-			low_pfn = retry_pfn;
+			low_pfn = retry_pfn + 1;
 			curr = iova_find_limit(iovad, limit_pfn);
 			curr_iova = to_iova(curr);
 			goto retry;


