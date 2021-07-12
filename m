Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F783C4A7E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhGLGwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239189AbhGLGta (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6013610E5;
        Mon, 12 Jul 2021 06:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072395;
        bh=oKGTv/+PZn0kbg/Fp9P2DxsFCRvl9SzCqxXU/N/6o6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nycpq3H7Va/uKBbwJrPiymFU2A0APsgCoOm7OCp2INGl2xIAXQtHx9s7cFBYCMoC1
         GIpEd1a8NuOiENQXhcNDvo/LXZleMpcnkd4ZoYBOr43giKH0gOS1XbIbRZIR0ISoi4
         M8PD18KvYVsAsC7ugnniCocJsxBtauK4cCm195tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/593] serial: fsl_lpuart: dont modify arbitrary data on lpuart32
Date:   Mon, 12 Jul 2021 08:09:57 +0200
Message-Id: <20210712060936.777103067@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit ccf08fd1204bcb5311cc10aea037c71c6e74720a ]

lpuart_rx_dma_startup() is used for both the 8 bit and the 32 bit
version of the LPUART. Modify the UARTCR only for the 8 bit version.

Fixes: f4eef224a09f ("serial: fsl_lpuart: add sysrq support when using dma")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20210512141255.18277-2-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index bd047e1f9bea..6b8e638c2389 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1625,7 +1625,7 @@ static void lpuart_rx_dma_startup(struct lpuart_port *sport)
 	sport->lpuart_dma_rx_use = true;
 	rx_dma_timer_init(sport);
 
-	if (sport->port.has_sysrq) {
+	if (sport->port.has_sysrq && !lpuart_is_32(sport)) {
 		cr3 = readb(sport->port.membase + UARTCR3);
 		cr3 |= UARTCR3_FEIE;
 		writeb(cr3, sport->port.membase + UARTCR3);
-- 
2.30.2



