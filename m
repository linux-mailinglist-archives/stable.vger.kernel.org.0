Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967E9627EDD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiKNMwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiKNMw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99209252A6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5171FB80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6440FC433C1;
        Mon, 14 Nov 2022 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430346;
        bh=+P/RdhWhH/6YqWiFbrZyzX8MB81NKIhxvMxfgipKPjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYtZ+FNQSVGVYySzjrRUIWLrbmMnyb9NKLroWlrXEx8LVwSSMHhSwgxNA7VZ/D7f1
         NWwQSzzd9cJFslP+3faiMfrti5IGqgdcCV36vdvI5JOOOPtjC35+BGKjR1i/8UZpbI
         o69iL4Sx9b0wz9RU/bIULkS4OZshUKhIsyPL962Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 79/95] dmaengine: at_hdmac: Fix at_lli struct definition
Date:   Mon, 14 Nov 2022 13:46:13 +0100
Message-Id: <20221114124445.835644734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit f1171bbdd2ba2a50ee64bb198a78c268a5baf5f1 upstream.

Those hardware registers are all of 32 bits, while dma_addr_t ca be of
type u64 or u32 depending on CONFIG_ARCH_DMA_ADDR_T_64BIT. Force u32 to
comply with what the hardware expects.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-2-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac_regs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -164,13 +164,13 @@
 /* LLI == Linked List Item; aka DMA buffer descriptor */
 struct at_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	saddr;
-	dma_addr_t	daddr;
+	u32 saddr;
+	u32 daddr;
 	/* value that may get written back: */
-	u32		ctrla;
+	u32 ctrla;
 	/* more values that are not changed by hardware */
-	u32		ctrlb;
-	dma_addr_t	dscr;	/* chain to next lli */
+	u32 ctrlb;
+	u32 dscr;	/* chain to next lli */
 };
 
 /**


