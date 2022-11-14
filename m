Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C607627F6C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiKNM7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237606AbiKNM7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:59:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1809024BE4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB422B80EBD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D184FC433C1;
        Mon, 14 Nov 2022 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430742;
        bh=yayEaSVAsmTsV+jzhq9wA/46qnEAg8zjvEyg7TBX/y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo7pODJbNRxD87bW3iaB5ujIF1+EbQehAO++3qjSO0+akCh7rIWLAbCdVTaKDSAnR
         nJF1iL/emRl/N3bCgCiBD9mYSreP8J8ZJCxhoujn81sIZBtj04jp29mUnLy2gfqtb5
         rRKKrAACMXt98f+fOKJoDcmOt5OuaeoihcJgS4sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 116/131] dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending
Date:   Mon, 14 Nov 2022 13:46:25 +0100
Message-Id: <20221114124453.621782465@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

commit 8a47221fc28417ff8a32a4f92d4448a56c3cf7e1 upstream.

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: 53830cc75974 ("dmaengine: at_hdmac: add cyclic DMA operation support")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-4-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1528,10 +1528,6 @@ static void atc_issue_pending(struct dma
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	/* Not needed for cyclic transfers */
-	if (atc_chan_is_cyclic(atchan))
-		return;
-
 	atc_advance_work(atchan);
 }
 


