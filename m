Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FB966C57F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjAPQGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjAPQGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E1D23DBC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F3661048
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D0FC433EF;
        Mon, 16 Jan 2023 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885078;
        bh=V5Na7RThr0Rb0XUgY3epO5DtmYIA6cse1GiLo/TXo3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h81zdMNNCrgM/rTOCutiPcicNYw0AKajtSLJF1eZGdb7rmEKsrGbM6LNKB8C/Wr2h
         gPP7zS1rrWj/yA0ebPXzjbzQGZV2/ZCCvACipXwOy8mwcLL/shqxQ08U80cNnQLV3r
         lMSZdAvmVeeZAqwXyBky8Ij8xN/hqma3NMWZiBhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        jianjiao zeng <jianjiao.zeng@mediatek.com>,
        Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 37/86] iommu/iova: Fix alloc iova overflows issue
Date:   Mon, 16 Jan 2023 16:51:11 +0100
Message-Id: <20230116154748.627449646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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
@@ -252,7 +252,7 @@ static int __alloc_and_insert_iova_range
 
 	curr = __get_cached_rbnode(iovad, limit_pfn);
 	curr_iova = to_iova(curr);
-	retry_pfn = curr_iova->pfn_hi + 1;
+	retry_pfn = curr_iova->pfn_hi;
 
 retry:
 	do {
@@ -266,7 +266,7 @@ retry:
 	if (high_pfn < size || new_pfn < low_pfn) {
 		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
 			high_pfn = limit_pfn;
-			low_pfn = retry_pfn;
+			low_pfn = retry_pfn + 1;
 			curr = iova_find_limit(iovad, limit_pfn);
 			curr_iova = to_iova(curr);
 			goto retry;


