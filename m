Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39A56FDED
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiGKKC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiGKKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:01:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DBF2AF;
        Mon, 11 Jul 2022 02:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24F356136E;
        Mon, 11 Jul 2022 09:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0F5C34115;
        Mon, 11 Jul 2022 09:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531712;
        bh=uHtkAaK8JZ0OMEbRWgllIsKnn+tOA3YooURssre3hfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oks0lPyIG79MGinnRJSmGDZOIuokU3lKgNjt7wvQM37xdXzZggU95P+JVEGC5hVeS
         o/PDrzBM9N8kScbfrljF+rwMuNPVTa1xmSqlrA2J5fYBCXmBkQji3pXtSChL7dE1Y3
         6T5GBTp2GqG37H2W46OefmlQPxLzahKEI8EZ0A9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Malov <ivan.malov@oktetlabs.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/230] xsk: Clear page contiguity bit when unmapping pool
Date:   Mon, 11 Jul 2022 11:07:39 +0200
Message-Id: <20220711090609.863252807@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Ivan Malov <ivan.malov@oktetlabs.ru>

[ Upstream commit 512d1999b8e94a5d43fba3afc73e774849674742 ]

When a XSK pool gets mapped, xp_check_dma_contiguity() adds bit 0x1
to pages' DMA addresses that go in ascending order and at 4K stride.

The problem is that the bit does not get cleared before doing unmap.
As a result, a lot of warnings from iommu_dma_unmap_page() are seen
in dmesg, which indicates that lookups by iommu_iova_to_phys() fail.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Ivan Malov <ivan.malov@oktetlabs.ru>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220628091848.534803-1-ivan.malov@oktetlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index fc7fbfc1e586..ccedbbd27692 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -326,6 +326,7 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
+			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
 			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
 					     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
-- 
2.35.1



