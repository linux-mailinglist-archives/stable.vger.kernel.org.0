Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625AF3C4C0C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbhGLHBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241835AbhGLG7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13A061132;
        Mon, 12 Jul 2021 06:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073004;
        bh=KuJU28+Nk0j1uhAYcQWyZwB8EM40lYnI9HZRqQErR6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1hGUa3jywcRp9XSSOxpbYdhE4Vc16tAHOADuldmnI/XpTSsyzSWgUvqthNUMhWIV
         jX2CaBd98sTfsLpndcpsTunrFmzrZaKPXqK1Ygr+cPkRzQiDFRLFARD0NG6WPPb+hA
         K14+VBBlMgVxHm6VNhrHE1djg7lorIaVg7aNhpvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.12 094/700] serial: mvebu-uart: fix calculation of clock divisor
Date:   Mon, 12 Jul 2021 08:02:57 +0200
Message-Id: <20210712060938.075288830@linuxfoundation.org>
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


