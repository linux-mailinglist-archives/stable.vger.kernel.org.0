Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D246AEFA4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjCGSY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjCGSYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4169BA77
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 415A6B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D656C433EF;
        Tue,  7 Mar 2023 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213195;
        bh=oPX0rJt4z7n9guvBarabCHYceq3zpoRIC6U5sWO4xNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTz2MK/y8YGwlBdh+5ajA5zEqfu4+gY6qONUGhDpQxHLRBXwIBc8sewizpg7GEUom
         j1l3wvgebkPHxG2QIvpZcW3M+uJFkeeiBK4m46YtghruI5cfZVf1OTefkHsIAtcPPO
         MGoMzMmHCp/kR/IjadJbix2myN5vMMRmTV34gYyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 429/885] tty: serial: fsl_lpuart: disable Rx/Tx DMA in lpuart32_shutdown()
Date:   Tue,  7 Mar 2023 17:56:03 +0100
Message-Id: <20230307170021.043775423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 1d4bd0e4ae4ba95892bef919a8d4d3f08f122d7e ]

UARTBAUD_RDMAE and UARTBAUD_TDMAE are enabled in lpuart32_startup(), but
lpuart32_shutdown() not disable them, only free the dma ring buffer and
release the dma channels, so here disable the Rx/Tx DMA first in
lpuart32_shutdown().

Fixes: 42b68768e51b ("serial: fsl_lpuart: DMA support for 32-bit variant")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221125101953.18753-3-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 888e01fbd9c5f..262b059e3ee11 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1791,6 +1791,11 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* disable Rx/Tx DMA */
+	temp = lpuart32_read(port, UARTBAUD);
+	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
+	lpuart32_write(port, temp, UARTBAUD);
+
 	/* disable Rx/Tx and interrupts */
 	temp = lpuart32_read(port, UARTCTRL);
 	temp &= ~(UARTCTRL_TE | UARTCTRL_RE |
-- 
2.39.2



