Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E90635367
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiKWI40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbiKWI4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:56:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950511001C1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC95B81EEF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B22C433D6;
        Wed, 23 Nov 2022 08:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193768;
        bh=0J5SWx36ELZfflIC1s0tuWQO5c5CZbocQevuV0nj/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s57SvIrFOVTNYilIMcDuNAqyZdvgKWGyExWlcB54vgoaMIg3s+oiwuYJ7s5ro0nJi
         WzniD2PRgGs272g02PmIdz4YXKQX7EqO6FYLqpODOCU/ZSsnldPskuaw4UGPDXEES/
         Bv2sJJUrGLlxbf8a8nrd+JfDil6HPeHht6G69eBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 26/76] dmaengine: at_hdmac: Dont allow CPU to reorder channel enable
Date:   Wed, 23 Nov 2022 09:50:25 +0100
Message-Id: <20221123084547.582796495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

commit 580ee84405c27d6ed419abe4d2b3de1968abdafd upstream.

at_hdmac uses __raw_writel for register writes. In the absence of a
barrier, the CPU may reorder the register operations.
Introduce a write memory barrier so that the CPU does not reorder the
channel enable, thus the start of the transfer, without making sure that
all the pre-required register fields are already written.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-14-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -253,6 +253,8 @@ static void atc_dostart(struct at_dma_ch
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);


