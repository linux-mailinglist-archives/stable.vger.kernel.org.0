Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113A43C54FF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbhGLIIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348247AbhGLH5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D380C61628;
        Mon, 12 Jul 2021 07:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076358;
        bh=izDLI6+M7PG98pfkRd/raJC/feAlSJ1YwtLfRiznLN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEZ+xP0uin1/r8/EhxepyC2O/f/aXaH4Dg9bvwjx2LmN5jQVcp8xJ5oMt3pcwwJGD
         bOmiw6KOwnowgmOX5fjIvUGlCxP/pZ9zZXrzV2m3Mh41Q0ptufEbr4QpWJfYSlrrfc
         VaAjntQqSep69Y+crQlpYK4oVcbFSRgx4LhU6MPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 607/800] serial: fsl_lpuart: dont modify arbitrary data on lpuart32
Date:   Mon, 12 Jul 2021 08:10:30 +0200
Message-Id: <20210712061031.871511339@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 794035041744..fbf2e4d2d22b 100644
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



