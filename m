Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2474E4DB2F6
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348987AbiCPOWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343575AbiCPOVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A964EF6B;
        Wed, 16 Mar 2022 07:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C36261277;
        Wed, 16 Mar 2022 14:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93A7C340F0;
        Wed, 16 Mar 2022 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440347;
        bh=Y5zWl7U5Otlds0oDof3do24rzGWPA9Fl6NP3DV3Vw0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ev2AKkdIvRSGsHse2NLrCC2KRLJOXBCgbib0B7zcoEQu900vK6tuJ/BEVBfjNtyck
         jbCKbU7HIvQr5sqH9dCDzLam50ZuQSNQFqPRuT5AQUsy5pNcZrpxMHsOBkgHxQ5+/l
         lcnzwDx3j/tapzQzEq8dmS/oq1NOcPvokGaoMHSTk0FdR1OkRfupEk/gHw0+NY3viH
         DmNRzvBPFc05wxaIkBZuU2q7wfJdp8hIQhaTOl/n/27APTqV14MZC70C28h8s7aXUM
         UGIpyrIrgsWL0xtruoBtSgbvQ6NtMeEfbPGsjEupbFKfXHO0IiFqhqZS31FM0gsD3s
         I9To9zaC7dcgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/3] spi: Fix invalid sgs value
Date:   Wed, 16 Mar 2022 10:18:50 -0400
Message-Id: <20220316141850.248784-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141850.248784-1-sashal@kernel.org>
References: <20220316141850.248784-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 1a4e53d2fc4f68aa654ad96d13ad042e1a8e8a7d ]

max_seg_size is unsigned int and it can have a value up to 2^32
(for eg:-RZ_DMAC driver sets dma_set_max_seg_size as U32_MAX)
When this value is used in min_t() as an integer type, it becomes
-1 and the value of sgs becomes 0.

Fix this issue by replacing the 'int' data type with 'unsigned int'
in min_t().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220307184843.9994-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 71f74015efb9..d26aefed16ac 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -774,10 +774,10 @@ static int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
 	int i, ret;
 
 	if (vmalloced_buf || kmap_buf) {
-		desc_len = min_t(int, max_seg_size, PAGE_SIZE);
+		desc_len = min_t(unsigned int, max_seg_size, PAGE_SIZE);
 		sgs = DIV_ROUND_UP(len + offset_in_page(buf), desc_len);
 	} else if (virt_addr_valid(buf)) {
-		desc_len = min_t(int, max_seg_size, ctlr->max_dma_len);
+		desc_len = min_t(unsigned int, max_seg_size, ctlr->max_dma_len);
 		sgs = DIV_ROUND_UP(len, desc_len);
 	} else {
 		return -EINVAL;
-- 
2.34.1

