Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F166280C2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiKNNI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiKNNI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677189FE6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F0CB80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8C8C433D6;
        Mon, 14 Nov 2022 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431329;
        bh=5IvOp3N5UzzOO3rWrlgZmMPmxPxuYlnTiEv/FwhDnEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vktrm/XlGVw+akuoiAoLKlmooiWtkd4C9htIXmDffFm8Wvh4wOFVvTve3RnkdPqtx
         zLmxfjv7p/3PCbsENt9JNMvwQJbLqoHAWX6Da52EXIvC7UCv3l3jTet6iCy7YGDJGX
         hNdQD33YjMziuqP86jScIY/xuTsbRJienAOUPOSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 186/190] dmaengine: at_hdmac: Dont allow CPU to reorder channel enable
Date:   Mon, 14 Nov 2022 13:46:50 +0100
Message-Id: <20221114124507.011914545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
@@ -256,6 +256,8 @@ static void atc_dostart(struct at_dma_ch
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);


