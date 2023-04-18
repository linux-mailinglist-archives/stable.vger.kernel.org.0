Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E1F6E63F7
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjDRMo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjDRMo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A195167DA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E959463383
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0965DC433D2;
        Tue, 18 Apr 2023 12:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821894;
        bh=A7mfIw+XEGZwAFLWejaqGe10w1JDqOHTkHZ0+8YiQ+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbV4zKnlXdNBdena25dViR8CaVNqQud7enbAWc2wbdS1r+vN5G2NKzAnqHQXXIcr7
         BuC0jRXVDkcIVTkXDHFeAXb0kp0VQp8TbiFedVf9CX6weWmTyXIo8QhYEXGlX5QNkC
         KAjwiWXnBmgaLZsE+VIOYR2yJ7hR3cLAo/i4+Vms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/134] dmaengine: apple-admac: Set src_addr_widths capability
Date:   Tue, 18 Apr 2023 14:21:38 +0200
Message-Id: <20230418120314.399984663@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 6e96adcaa7a29827ac8ee8df290a44957a4823ec ]

Add missing setting of 'src_addr_widths', which is the same as for the
other direction.

Fixes: b127315d9a78 ("dmaengine: apple-admac: Add Apple ADMAC driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224152222.26732-3-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index 00cbfafe0ed9d..b9132b495d181 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -858,6 +858,9 @@ static int admac_probe(struct platform_device *pdev)
 
 	dma->directions = BIT(DMA_MEM_TO_DEV) | BIT(DMA_DEV_TO_MEM);
 	dma->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
+	dma->src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+			BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+			BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
 	dma->dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
 			BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
 			BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
-- 
2.39.2



