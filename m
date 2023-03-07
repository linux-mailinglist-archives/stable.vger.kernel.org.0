Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40816AF01F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbjCGS3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjCGS1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:27:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE27B1EE2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2537161501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6F3C433EF;
        Tue,  7 Mar 2023 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213263;
        bh=wf9SYX8NJ5Dn7mHRvEWx2FKJIXqZv/kXobggqN2tlH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIj8mrNAQbqL7qGfc/lOIT4zYAPmv/PbEj4RdduLea319tq7W7wTBc+X/wHTQTSa7
         Ur/o7isXG0PZVJ+rqo5ebtJiD6dabHsE6/Zw/xoeEPLZHyPzAaJPVC04yItzM7Hovh
         UhWoZeteJ5j4c0kqtlygv9NTEyaJCJ28yFZMfJt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 452/885] tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case
Date:   Tue,  7 Mar 2023 17:56:26 +0100
Message-Id: <20230307170022.131521118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 110c8720af47a..f6ac46879dc7b 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1684,12 +1684,6 @@ static void lpuart32_configure(struct lpuart_port *sport)
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



