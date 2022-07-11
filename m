Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF656FE26
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiGKKEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiGKKDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C060D691E9;
        Mon, 11 Jul 2022 02:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D4F8B80D2C;
        Mon, 11 Jul 2022 09:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5602C34115;
        Mon, 11 Jul 2022 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531787;
        bh=BzvaL6bz8Q8ZGA95+tzigYDNQurz4yyyNUfD7glyKlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOBw93q3ObykYJWu1JfV+PWd0fq0a9EakPHDsnP8T6rnL0hsA2IUQhTEcH1nX5Rkr
         7g0yVChunkKCTdPhRGNR6ttj7oboOX2tZs6yHNS+RzWd8/y1JdI1VywAN9t0voMLEx
         aCCCXt1ZruWjtbFOwBGgAkeOaIwp1B1ITDpTxEoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "kernelci.org bot" <bot@kernelci.org>
Subject: [PATCH 5.15 220/230] Revert "serial: 8250_mtk: Make sure to select the right FEATURE_SEL"
Date:   Mon, 11 Jul 2022 11:07:56 +0200
Message-Id: <20220711090610.343165021@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit f0136f65285bcfb7e8f90d1013723076a35acd51 upstream.

It was found that some MediaTek SoCs are incompatible with this
change. Also, this register was mistakenly understood as it was
related to the 16550A register layout selection but, at least
on some IPs, if not all, it's related to something else unknown.

This reverts commit 6f81fdded0d024c7d4084d434764f30bca1cd6b1.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 6f81fdded0d0 ("serial: 8250_mtk: Make sure to select the right FEATURE_SEL")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Link: https://lore.kernel.org/r/20220510122620.150342-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -57,9 +57,6 @@
 #define MTK_UART_XON1		40	/* I/O: Xon character 1 */
 #define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
 
-#define MTK_UART_FEATURE_SEL	39	/* Feature Selection register */
-#define MTK_UART_FEAT_NEWRMAP	BIT(0)	/* Use new register map */
-
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -575,10 +572,6 @@ static int mtk8250_probe(struct platform
 		uart.dma = data->dma;
 #endif
 
-	/* Set AP UART new register map */
-	writel(MTK_UART_FEAT_NEWRMAP, uart.port.membase +
-	       (MTK_UART_FEATURE_SEL << uart.port.regshift));
-
 	/* Disable Rate Fix function */
 	writel(0x0, uart.port.membase +
 			(MTK_UART_RATE_FIX << uart.port.regshift));


