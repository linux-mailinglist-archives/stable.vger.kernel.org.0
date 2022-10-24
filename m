Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D650960A56F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiJXMYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiJXMYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F85FA8;
        Mon, 24 Oct 2022 05:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A048B811E6;
        Mon, 24 Oct 2022 11:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B084C433B5;
        Mon, 24 Oct 2022 11:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612571;
        bh=MPx8MYZaOpRhJircYdIbMtxUIK98qNQOL2IsJCYo8Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sz6U8loaYMgwSKHqpZ71LGpQcWIP+nMdiOXq1Oh7amVNN/XtX8Smpx3c/dXlB/TIk
         8MfxGBMxfnm241msD4iiE9w54yPoG6UNCZ8ptDjDS6DZwP6BO8HlmynWa1NzHUJVpo
         EoPLInAtPDH1Ki4yxmR+YD62Eh0iJu8MOsciyb60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Dahl <ada@thorsis.com>,
        Peter Rosin <peda@axentia.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 037/229] mtd: rawnand: atmel: Unmap streaming DMA mappings
Date:   Mon, 24 Oct 2022 13:29:16 +0200
Message-Id: <20221024113000.304537542@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 1161703c9bd664da5e3b2eb1a3bb40c210e026ea upstream.

Every dma_map_single() call should have its dma_unmap_single() counterpart,
because the DMA address space is a shared resource and one could render the
machine unusable by consuming all DMA addresses.

Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Cc: stable@vger.kernel.org
Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Alexander Dahl <ada@thorsis.com>
Reported-by: Peter Rosin <peda@axentia.se>
Tested-by: Alexander Dahl <ada@thorsis.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220728074014.145406-1-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -398,6 +398,7 @@ static int atmel_nand_dma_transfer(struc
 
 	dma_async_issue_pending(nc->dmac);
 	wait_for_completion(&finished);
+	dma_unmap_single(nc->dev, buf_dma, len, dir);
 
 	return 0;
 


