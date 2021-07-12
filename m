Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE983C4EE3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241327AbhGLHWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344655AbhGLHUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FFC613D2;
        Mon, 12 Jul 2021 07:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074275;
        bh=zlCbgnpyDeBSQsLOPKs0LGmUdYmEeL/3/jJvNrZIKw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBDu8BtgfPbEetZqj16rjN6iDHwhvVEtR/PLWzEa96jIA+LU+VmKXtzBE1KFZDR7f
         bgoheRXT413SmgDip/dUp7zziaN2sLTgf2HewipdinsIRiwiry3J1d9PNsx+nnrCsA
         BELuwNSuMGTWs1caIEvY52pfjvMP/b3MI6x8BPSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 524/700] serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()
Date:   Mon, 12 Jul 2021 08:10:07 +0200
Message-Id: <20210712061032.186037389@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit e60c2991f18bf221fa9908ff10cb24eaedaa9bae ]

The wrong code in set_mctrl() was already removed in commit 2b30efe2e88a
("tty: serial: lpuart: Remove unnecessary code from set_mctrl"), but the
code in get_mctrl() wasn't removed. It will not return the state of the
RTS or CTS line but whether automatic flow control is enabled, which is
wrong for the get_mctrl(). Thus remove it.

Fixes: 2b30efe2e88a ("tty: serial: lpuart: Remove unnecessary code from set_mctrl")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20210512141255.18277-7-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index fbf2e4d2d22b..9c78e43e669d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1408,17 +1408,7 @@ static unsigned int lpuart_get_mctrl(struct uart_port *port)
 
 static unsigned int lpuart32_get_mctrl(struct uart_port *port)
 {
-	unsigned int temp = 0;
-	unsigned long reg;
-
-	reg = lpuart32_read(port, UARTMODIR);
-	if (reg & UARTMODIR_TXCTSE)
-		temp |= TIOCM_CTS;
-
-	if (reg & UARTMODIR_RXRTSE)
-		temp |= TIOCM_RTS;
-
-	return temp;
+	return 0;
 }
 
 static void lpuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
-- 
2.30.2



