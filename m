Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D990469EEC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350318AbhLFPou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390596AbhLFPme (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3161C0698DD;
        Mon,  6 Dec 2021 07:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D25FB8111C;
        Mon,  6 Dec 2021 15:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C9BC34901;
        Mon,  6 Dec 2021 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804540;
        bh=le6caFEAm1b95VtNuowG1E68Hs6Z4xMntMNAJkBakVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVwiN9+sL/ocdGVubTu/sTthp5Kiw45jTvUvDYiluYVpTgG0KfIExaRsBE6YIuLOt
         ZudWufAvA+acINt+wIyFWoU6wjEDmntOAnoVKDXWlJEoCooJUgHbOuaFjdT0otIuYM
         /8hJoGxPpBi6Aqek+c1B7OGPl3TXs1/EpyHHqsFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/207] serial: 8250_bcm7271: UART errors after resuming from S2
Date:   Mon,  6 Dec 2021 15:57:18 +0100
Message-Id: <20211206145616.648120791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit 9cabe26e65a893afd5846908aa393bd283ab6609 ]

There is a small window in time during resume where the hardware
flow control signal RTS can be asserted (which allows a sender to
resume sending data to the UART) but the baud rate has not yet
been restored. This will cause corrupted data and FRAMING, OVERRUN
and BREAK errors. This is happening because the MCTRL register is
shadowed in uart_port struct and is later used during resume to set
the MCTRL register during both serial8250_do_startup() and
uart_resume_port(). Unfortunately, serial8250_do_startup()
happens before the UART baud rate is restored. The fix is to clear
the shadowed mctrl value at the end of suspend and restore it at the
end of resume.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Link: https://lore.kernel.org/r/20211201201402.47446-1-alcooperx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 7f656fac503fe..5163d60756b73 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -237,6 +237,7 @@ struct brcmuart_priv {
 	u32		rx_err;
 	u32		rx_timeout;
 	u32		rx_abort;
+	u32		saved_mctrl;
 };
 
 static struct dentry *brcmuart_debugfs_root;
@@ -1133,16 +1134,27 @@ static int brcmuart_remove(struct platform_device *pdev)
 static int __maybe_unused brcmuart_suspend(struct device *dev)
 {
 	struct brcmuart_priv *priv = dev_get_drvdata(dev);
+	struct uart_8250_port *up = serial8250_get_port(priv->line);
+	struct uart_port *port = &up->port;
 
 	serial8250_suspend_port(priv->line);
 	clk_disable_unprepare(priv->baud_mux_clk);
 
+	/*
+	 * This will prevent resume from enabling RTS before the
+	 *  baud rate has been resored.
+	 */
+	priv->saved_mctrl = port->mctrl;
+	port->mctrl = 0;
+
 	return 0;
 }
 
 static int __maybe_unused brcmuart_resume(struct device *dev)
 {
 	struct brcmuart_priv *priv = dev_get_drvdata(dev);
+	struct uart_8250_port *up = serial8250_get_port(priv->line);
+	struct uart_port *port = &up->port;
 	int ret;
 
 	ret = clk_prepare_enable(priv->baud_mux_clk);
@@ -1165,6 +1177,7 @@ static int __maybe_unused brcmuart_resume(struct device *dev)
 		start_rx_dma(serial8250_get_port(priv->line));
 	}
 	serial8250_resume_port(priv->line);
+	port->mctrl = priv->saved_mctrl;
 	return 0;
 }
 
-- 
2.33.0



