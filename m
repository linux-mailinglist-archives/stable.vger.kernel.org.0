Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA97B6AF481
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjCGTRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCGTQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB81B8612
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC2D2B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A83C433D2;
        Tue,  7 Mar 2023 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215604;
        bh=Qz3Tbn1fXcqseNvnHpqoT7rdbsO/cRgHmJBIKVQI4Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtoHRq0bJsHUrL9Xx2KBVh6Z+Pp09rtDepgj2YCHggIENH4si61EkWUi8Q3WwiyHS
         wR1lTl/VgxZi2caJhWpSbBELFwefGtXW/4QhC47SqPi/WR6nW3Ep1OSoJFIO4/eTbG
         g8MlgqJ9aVnRg+nHb/YJxxv3rlCrnjxhFN32fNEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/567] tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case
Date:   Tue,  7 Mar 2023 18:00:51 +0100
Message-Id: <20230307165919.518610731@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 9ad9df8447547febe9dd09b040f4528a09e495f0 ]

The RXWATER value must be greater than 0 according to the LPUART
reference manual. And when the number of datawords in the receive
FIFO is greater than RXWATER, an interrupt or a DMA request is
generated, so no need to set the different value for lpuart interrupt
case and dma case. Here delete the wrong RXWATER setting for dma case
directly.

Fixes: 42b68768e51b ("serial: fsl_lpuart: DMA support for 32-bit variant")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230130064449.9564-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ccfd6dd5fbf4e..08096d33af8a6 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1700,12 +1700,6 @@ static void lpuart32_configure(struct lpuart_port *sport)
 {
 	unsigned long temp;
 
-	if (sport->lpuart_dma_rx_use) {
-		/* RXWATER must be 0 */
-		temp = lpuart32_read(&sport->port, UARTWATER);
-		temp &= ~(UARTWATER_WATER_MASK << UARTWATER_RXWATER_OFF);
-		lpuart32_write(&sport->port, temp, UARTWATER);
-	}
 	temp = lpuart32_read(&sport->port, UARTCTRL);
 	if (!sport->lpuart_dma_rx_use)
 		temp |= UARTCTRL_RIE;
-- 
2.39.2



