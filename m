Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959E9500E8B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbiDNNSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243812AbiDNNSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:18:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31B890275;
        Thu, 14 Apr 2022 06:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB4961307;
        Thu, 14 Apr 2022 13:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390A1C385A1;
        Thu, 14 Apr 2022 13:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942132;
        bh=fZ0NMhp8ITe263nvjodv6Z57zmXNL/LGHoSpLaRSkNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+YhTp/797hot6zW4OZJIc3mHTaQVfp5kyA3itm9tSJndj5kHd2WkMESs+8nAjEYg
         136fCpn7wqlv9gDtmhiVBh4WaUegHjo+bFkxdr8iZxW2z/vnDK63J7VvDkDCwn+Zmx
         pzPKo19QzZA5yXq3NuL4fICFUzvx+NEmunc9sYhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/338] spi: Fix invalid sgs value
Date:   Thu, 14 Apr 2022 15:08:31 +0200
Message-Id: <20220414110839.127888557@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 49f592e433a8..518c8e0eef7f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -779,10 +779,10 @@ int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
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



