Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5672F3C4472
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhGLGTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233642AbhGLGTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A7F5610CC;
        Mon, 12 Jul 2021 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070572;
        bh=KuJU28+Nk0j1uhAYcQWyZwB8EM40lYnI9HZRqQErR6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMStFkFUn4f00x2yymusoeT1qZAjC5JPqpZkvNzQurUQNW49ih+ZHv15+M1sAjbV9
         6U0BoYp/rPfasSfpb0POKMWO1AbKB1uL2CFRyfB/sggsFBA8N4SzngrbbwXl9SFI2Z
         stBlmTKPDdc0gLBzvE+CD/1iR76qKP+X5N+7vuYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.4 047/348] serial: mvebu-uart: fix calculation of clock divisor
Date:   Mon, 12 Jul 2021 08:07:11 +0200
Message-Id: <20210712060707.582561065@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 9078204ca5c33ba20443a8623a41a68a9995a70d upstream.

The clock divisor should be rounded to the closest value.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
Cc: stable@vger.kernel.org # 0e4cf69ede87 ("serial: mvebu-uart: clarify the baud rate derivation")
Link: https://lore.kernel.org/r/20210624224909.6350-2-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mvebu-uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -463,7 +463,7 @@ static int mvebu_uart_baud_rate_set(stru
 	 * makes use of D to configure the desired baudrate.
 	 */
 	m_divisor = OSAMP_DEFAULT_DIVISOR;
-	d_divisor = DIV_ROUND_UP(port->uartclk, baud * m_divisor);
+	d_divisor = DIV_ROUND_CLOSEST(port->uartclk, baud * m_divisor);
 
 	brdv = readl(port->membase + UART_BRDV);
 	brdv &= ~BRDV_BAUD_MASK;


