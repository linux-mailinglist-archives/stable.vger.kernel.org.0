Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB4A548B94
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377970AbiFMNki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378634AbiFMNjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6767891A;
        Mon, 13 Jun 2022 04:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FB3B80EA8;
        Mon, 13 Jun 2022 11:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C4AC3411C;
        Mon, 13 Jun 2022 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119664;
        bh=5KK2CwmryHRpgwOVonR+RYx+OZFduKmyzbH94Fe4iJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAnGkDh0Q+X4C4Rbd/+Eb8HJCjnSR/bhvupe3KLfHlln8ABbU75kd67/m7tF5WHqo
         ZHX8oKdmVuUmgTtSjDdnziShuoxLv4ujgWKEhAdTtETRurENJZCtRJNjuqIyEQy2mN
         DXgCGihDVN8bQSVmMw+EP5uT9EvvhdfIonQfVj24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/339] Revert "serial: 8250_mtk: Make sure to select the right FEATURE_SEL"
Date:   Mon, 13 Jun 2022 12:08:09 +0200
Message-Id: <20220613094928.464950203@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit f0136f65285bcfb7e8f90d1013723076a35acd51 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index 21053db93ff1..54051ec7b499 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -54,9 +54,6 @@
 #define MTK_UART_TX_TRIGGER	1
 #define MTK_UART_RX_TRIGGER	MTK_UART_RX_SIZE
 
-#define MTK_UART_FEATURE_SEL	39	/* Feature Selection register */
-#define MTK_UART_FEAT_NEWRMAP	BIT(0)	/* Use new register map */
-
 #define MTK_UART_XON1		40	/* I/O: Xon character 1 */
 #define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
 
@@ -575,10 +572,6 @@ static int mtk8250_probe(struct platform_device *pdev)
 		uart.dma = data->dma;
 #endif
 
-	/* Set AP UART new register map */
-	writel(MTK_UART_FEAT_NEWRMAP, uart.port.membase +
-	       (MTK_UART_FEATURE_SEL << uart.port.regshift));
-
 	/* Disable Rate Fix function */
 	writel(0x0, uart.port.membase +
 			(MTK_UART_RATE_FIX << uart.port.regshift));
-- 
2.35.1



