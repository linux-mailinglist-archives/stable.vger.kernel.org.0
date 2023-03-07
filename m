Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DBC6AEABA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjCGRgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjCGRgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C276F9F070
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A0E61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF7C433EF;
        Tue,  7 Mar 2023 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210344;
        bh=QTtX+QJV8MkZW+xXVm/bIgfbp/Fd9nMNuWB+UsWgdF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Swdj6jJneAcGfZ/T7qNT/BozO/8NuBGnmI8qFsZUDmWFNCXGCP5/1DsxqH5i8bosA
         ocFsOy74dp6FBly6HA/637p7cx3F1Cf0rSBIwSmdSRKgE6MUlEbVUKoQNnSoAK5B9L
         oh3FPOnX9Q3IcjAAtEkcGmyb5MrxgSAd0RQWazUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0511/1001] tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()
Date:   Tue,  7 Mar 2023 17:54:43 +0100
Message-Id: <20230307170043.610637097@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 4029dfc034febb54f6dd8ea83568accc943bc088 ]

The LPUART Status Register needs to be cleared when closing the uart
port to get a clean environment when reopening the uart.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221125101953.18753-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 5d1c28e094bb2..986ec8323c526 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1796,6 +1796,10 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* clear status */
+	temp = lpuart32_read(&sport->port, UARTSTAT);
+	lpuart32_write(&sport->port, temp, UARTSTAT);
+
 	/* disable Rx/Tx DMA */
 	temp = lpuart32_read(port, UARTBAUD);
 	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
-- 
2.39.2



