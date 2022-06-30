Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB80561BE8
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiF3NuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiF3NtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237D41A805;
        Thu, 30 Jun 2022 06:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5120EB82AF0;
        Thu, 30 Jun 2022 13:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C6C34115;
        Thu, 30 Jun 2022 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596923;
        bh=W8BfeBtWmhFei7kwlPV3f+SbgahVjVPPOevCVjuPUPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wMuCfmyKigUspQoTutVu91u57OIq4JVFfHK6SHJhM6t1h3F8n79tTgMZ00cdCZV4
         pFvWOJF+4L0sfmS/2GHonT9Rylg++SLvHnt6IzmBvUMN5E56ZarOlhqRljnnwC2ykj
         UfTcYcJTWx5JSnTVvmdmmy0L+ygp12xYD6QydL2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH 4.9 29/29] swiotlb: skip swiotlb_bounce when orig_addr is zero
Date:   Thu, 30 Jun 2022 15:46:29 +0200
Message-Id: <20220630133232.059643291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

After patch ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
swiotlb_bounce will be called in swiotlb_tbl_map_single unconditionally.
This requires that the physical address must be valid, which is not always
true on stable-4.19 or earlier version.
On stable-4.19, swiotlb_alloc_buffer will call swiotlb_tbl_map_single with
orig_addr equal to zero, which cause such a panic:

Unable to handle kernel paging request at virtual address ffffb77a40000000
...
pc : __memcpy+0x100/0x180
lr : swiotlb_bounce+0x74/0x88
...
Call trace:
 __memcpy+0x100/0x180
 swiotlb_tbl_map_single+0x2c8/0x338
 swiotlb_alloc+0xb4/0x198
 __dma_alloc+0x84/0x1d8
 ...

On stable-4.9 and stable-4.14, swiotlb_alloc_coherent wille call map_single
with orig_addr equal to zero, which can cause same panic.

Fix this by skipping swiotlb_bounce when orig_addr is zero.

Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/swiotlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -539,7 +539,8 @@ found:
 	 * unconditional bounce may prevent leaking swiotlb content (i.e.
 	 * kernel memory) to user-space.
 	 */
-	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
+	if (orig_addr)
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);


