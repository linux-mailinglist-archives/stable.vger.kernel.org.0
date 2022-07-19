Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12335579B28
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiGSMZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbiGSMYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307A950702;
        Tue, 19 Jul 2022 05:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914516173C;
        Tue, 19 Jul 2022 12:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6912CC36AE7;
        Tue, 19 Jul 2022 12:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232578;
        bh=5C9CX3TfIGRzabzlHGTv31drQYzVJ8lHORyA60Fs4VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhKeXV91g+veJNQquJx+LrBI57T0CgwLGdeKPjQoeLHa7VNPe6YGFRtPCLSCbejvp
         0IF12GzCsqTTUp6BK43IBs+gsk02E36j4tIZbq4sOwi/JMKMAUwtqZYWzNBQt7MDvI
         DUO7cmME44FVRF/C+3CrCVbEysTDZbsjwAo3BbCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 5.10 106/112] tty: serial: samsung_tty: set dma burst_size to 1
Date:   Tue, 19 Jul 2022 13:54:39 +0200
Message-Id: <20220719114637.354665249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
 drivers/tty/serial/samsung_tty.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -361,8 +361,7 @@ static void enable_tx_dma(struct s3c24xx
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
-		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
 
@@ -634,7 +633,7 @@ static void enable_rx_dma(struct s3c24xx
 			S3C64XX_UCON_DMASUS_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
 			S3C64XX_UCON_RXMODE_MASK);
-	ucon |= S3C64XX_UCON_RXBURST_16 |
+	ucon |= S3C64XX_UCON_RXBURST_1 |
 			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
 			S3C64XX_UCON_EMPTYINT_EN |
 			S3C64XX_UCON_TIMEOUT_EN |


