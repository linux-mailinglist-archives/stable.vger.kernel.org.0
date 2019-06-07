Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC2390E1
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfFGPpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbfFGPpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019792146E;
        Fri,  7 Jun 2019 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922329;
        bh=SL9zgEgp7BqO3aXwfqo9i/Vh3cSETpa2ZfNoTlqorlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD0qJ0ZuP2JueRLHIxOLEjkskuOQWKC5RCnJ5hmk/AarP4iFPD1HD19MfsKtigd8s
         CyuSgMU/u8qETGCltwqEFsHkHDGlFgsnVHsXAzGxZVgJRX1R8jgp8Ecacbib2vaK8i
         7LyQfIKpXCd/Z7gpSOFXYPnSpcCapAatUE54aS8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Rodin <mrodin@de.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "George G. Davis" <george_davis@mentor.com>
Subject: [PATCH 4.19 49/73] serial: sh-sci: disable DMA for uart_console
Date:   Fri,  7 Jun 2019 17:39:36 +0200
Message-Id: <20190607153854.615721628@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George G. Davis <george_davis@mentor.com>

commit 099506cbbc79c0bd52b19cb6b930f256dabc3950 upstream.

As noted in commit 84b40e3b57ee ("serial: 8250: omap: Disable DMA for
console UART"), UART console lines use low-level PIO only access functions
which will conflict with use of the line when DMA is enabled, e.g. when
the console line is also used for systemd messages. So disable DMA
support for UART console lines.

Reported-by: Michael Rodin <mrodin@de.adit-jv.com>
Link: https://patchwork.kernel.org/patch/10929511/
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Signed-off-by: George G. Davis <george_davis@mentor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sh-sci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1542,6 +1542,13 @@ static void sci_request_dma(struct uart_
 
 	dev_dbg(port->dev, "%s: port %d\n", __func__, port->line);
 
+	/*
+	 * DMA on console may interfere with Kernel log messages which use
+	 * plain putchar(). So, simply don't use it with a console.
+	 */
+	if (uart_console(port))
+		return;
+
 	if (!port->dev->of_node)
 		return;
 


