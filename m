Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F944F33B2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356406AbiDEKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiDEJbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374B9C3C;
        Tue,  5 Apr 2022 02:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A7A61654;
        Tue,  5 Apr 2022 09:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFBDC385A3;
        Tue,  5 Apr 2022 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150334;
        bh=5z96HNtCSD9lIA7Pp9tRzOIjIWNw7nGrfQ84IMYPEZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRvvDLFl1DUBUp9QeB2J1s+4giLQygF+1dYd0UjVZkrV2GzGQ1q+pZ1dLyll31KhR
         498I3wS4u3cfWg+y5rm0VrNDhycigmKwI6GWJrLzkQQqQot0smZ8qZv9wG3OruduKJ
         wB907/TGar+XumwTL1tIDKqQZAALwfDMOULDwwFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/913] spi: Fix erroneous sgs value with min_t()
Date:   Tue,  5 Apr 2022 09:18:02 +0200
Message-Id: <20220405070340.419902803@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ebc4cb43ea5ada3db46c80156fca58a54b9bbca8 ]

While computing sgs in spi_map_buf(), the data type
used in min_t() for max_seg_size is 'unsigned int' where
as that of ctlr->max_dma_len is 'size_t'.

min_t(unsigned int,x,y) gives wrong results if one of x/y is
'size_t'

Consider the below examples on a 64-bit machine (ie size_t is
64-bits, and unsigned int is 32-bit).
    case 1) min_t(unsigned int, 5, 0x100000001);
    case 2) min_t(size_t, 5, 0x100000001);

Case 1 returns '1', where as case 2 returns '5'. As you can see
the result from case 1 is wrong.

This patch fixes the above issue by using the data type of the
parameters that are used in min_t with maximum data length.

Fixes: commit 1a4e53d2fc4f68aa ("spi: Fix invalid sgs value")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20220316175317.465-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c7c8d13b2f83..cb7eb1e2e0e9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -942,10 +942,10 @@ int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
 	int i, ret;
 
 	if (vmalloced_buf || kmap_buf) {
-		desc_len = min_t(unsigned int, max_seg_size, PAGE_SIZE);
+		desc_len = min_t(unsigned long, max_seg_size, PAGE_SIZE);
 		sgs = DIV_ROUND_UP(len + offset_in_page(buf), desc_len);
 	} else if (virt_addr_valid(buf)) {
-		desc_len = min_t(unsigned int, max_seg_size, ctlr->max_dma_len);
+		desc_len = min_t(size_t, max_seg_size, ctlr->max_dma_len);
 		sgs = DIV_ROUND_UP(len, desc_len);
 	} else {
 		return -EINVAL;
-- 
2.34.1



