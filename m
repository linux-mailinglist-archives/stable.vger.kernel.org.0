Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698BB57996D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbiGSMCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiGSMCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DE543E4E;
        Tue, 19 Jul 2022 04:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79CBFB81A8F;
        Tue, 19 Jul 2022 11:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3344C341CA;
        Tue, 19 Jul 2022 11:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231933;
        bh=pneqByNjx/sGoWroweySELz1T991Ow00L40BUVLYOUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9DM7mDLl1cSUgNVgQMgo+od79KLuQfVdjNzgLmyH6pljingi5u3sYYRgtDZyXTWs
         KzYpP1n3pdEirjhgLIu68vwp7Za9pyWha/NQH+jVdJE9VGuWCwvh6SPwE85XNxMGa/
         iwu123Tj1ohxrqn2h8iBXWXXkxCud2zLoICA2xG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 4.14 40/43] tty: serial: samsung_tty: set dma burst_size to 1
Date:   Tue, 19 Jul 2022 13:54:11 +0200
Message-Id: <20220719114525.359838402@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

commit f7e35e4bf1e8dc2c8cbd5e0955dc1bd58558dae0 upstream.

The src_maxburst and dst_maxburst have been changed to 1 but the settings
of the UCON register aren't changed yet. They should be changed as well
according to the dmaengine slave config.

Fixes: aa2f80e752c7 ("serial: samsung: fix maxburst parameter for DMA transactions")
Cc: stable <stable@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20220627065113.139520-1-chanho61.park@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -241,8 +241,7 @@ static void enable_tx_dma(struct s3c24xx
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
-		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
 
@@ -515,7 +514,7 @@ static void enable_rx_dma(struct s3c24xx
 			S3C64XX_UCON_DMASUS_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
 			S3C64XX_UCON_RXMODE_MASK);
-	ucon |= S3C64XX_UCON_RXBURST_16 |
+	ucon |= S3C64XX_UCON_RXBURST_1 |
 			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
 			S3C64XX_UCON_EMPTYINT_EN |
 			S3C64XX_UCON_TIMEOUT_EN |


