Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3FC1BC9A5
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgD1Snl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbgD1Snl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56AE20575;
        Tue, 28 Apr 2020 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099420;
        bh=uXlG7zY2R4nQkPMFSwhbfOPelFo9eV73KDF2pnAMz+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVtBiVaaXw/YQIjSrLNdXMN6IQEJeLrEHZI/vMydC5IsuTgGH3W8A2sWp6UubuAjF
         06RbelcwO+uQ/gdncXF77ewoneUh/0wjiEjtW9a2wwppJjppDJB8ptgEuBFVs0eBn6
         vpOnCBu1Z3g1dM8Dkl6foM5QOm3ZdaTbcgO8QAxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Singh Tomar <amittomer25@gmail.com>
Subject: [PATCH 5.4 101/168] tty: serial: owl: add "much needed" clk_prepare_enable()
Date:   Tue, 28 Apr 2020 20:24:35 +0200
Message-Id: <20200428182245.145709355@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Singh Tomar <amittomer25@gmail.com>

commit abf42d2f333b21bf8d33b2fbb8a85fa62037ac01 upstream.

commit 8ba92cf59335 ("arm64: dts: actions: s700: Add Clock Management Unit")
breaks the UART on Cubieboard7-lite (based on S700 SoC), This is due to the
fact that generic clk routine clk_disable_unused() disables the gate clks,
and that in turns disables OWL UART (but UART driver never enables it). To
prove this theory, Andre suggested to use "clk_ignore_unused" in kernel
commnd line and it worked (Kernel happily lands into RAMFS world :)).

This commit fix this up by adding clk_prepare_enable().

Fixes: 8ba92cf59335 ("arm64: dts: actions: s700: Add Clock Management Unit")
Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1587067917-1400-1-git-send-email-amittomer25@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/owl-uart.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -680,6 +680,12 @@ static int owl_uart_probe(struct platfor
 		return PTR_ERR(owl_port->clk);
 	}
 
+	ret = clk_prepare_enable(owl_port->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "could not enable clk\n");
+		return ret;
+	}
+
 	owl_port->port.dev = &pdev->dev;
 	owl_port->port.line = pdev->id;
 	owl_port->port.type = PORT_OWL;
@@ -712,6 +718,7 @@ static int owl_uart_remove(struct platfo
 
 	uart_remove_one_port(&owl_uart_driver, &owl_port->port);
 	owl_uart_ports[pdev->id] = NULL;
+	clk_disable_unprepare(owl_port->clk);
 
 	return 0;
 }


