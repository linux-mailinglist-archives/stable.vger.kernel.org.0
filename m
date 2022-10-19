Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7271A603BD8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiJSIk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJSIj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA6780BDA;
        Wed, 19 Oct 2022 01:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B832617D7;
        Wed, 19 Oct 2022 08:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11568C433C1;
        Wed, 19 Oct 2022 08:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168728;
        bh=0LcxMqzKBXHZAcPKt0pyDjPeM3azFWJ3SFXQ6kVQIP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgGSTNNCic+yDWIuNwSXH2R2meeF0U6UFhpmihyEDAEVcLD4x4f4HsdioteOV5uSa
         +7PnD5dLz/rrk7iabA0v1pqHCx+nwGRxVnCE1YSezhNDhkB601y72Iz30ZE9Z9f2qd
         sofHV23qji/Ab5FXtFd+f9I3zHAlL+WxJIpVIg/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Dahl <ada@thorsis.com>,
        Peter Rosin <peda@axentia.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 009/862] mtd: rawnand: atmel: Unmap streaming DMA mappings
Date:   Wed, 19 Oct 2022 10:21:36 +0200
Message-Id: <20221019083250.416041539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struc
 
 	dma_async_issue_pending(nc->dmac);
 	wait_for_completion(&finished);
+	dma_unmap_single(nc->dev, buf_dma, len, dir);
 
 	return 0;
 


