Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1523594481
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiHOWiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350695AbiHOWgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB12D72867;
        Mon, 15 Aug 2022 12:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10223B8106C;
        Mon, 15 Aug 2022 19:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED6C433C1;
        Mon, 15 Aug 2022 19:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593024;
        bh=hF+MWjz3NwNhxg062slqc22gSVlrgR4oKLCaB8gyQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6jW55AOcd9npPd0YMh6NsHonPNDUiGhwaJxqj5skM+bz8TnM8U/6j7kLjbeDdX2N
         nucPXiNpa7DAhKWaC0ajHTgcZJMZaO4HfV8chXBlRXZKrmBrepd1RYg9GSGKQ8AZ1N
         TrJ/01gzA2CAABEMohpavhdcwzkc9tFpzk91o96M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0881/1095] serial: 8250_bcm7271: Save/restore RTS in suspend/resume
Date:   Mon, 15 Aug 2022 20:04:40 +0200
Message-Id: <20220815180505.792379523@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 3182efd036c1b955403d131258234896cbd9fbeb ]

Commit 9cabe26e65a8 ("serial: 8250_bcm7271: UART errors after resuming
from S2") prevented an early enabling of RTS during resume, but it did
not actively restore the RTS state after resume.

Fixes: 9cabe26e65a8 ("serial: 8250_bcm7271: UART errors after resuming from S2")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220714031316.404918-1-f.fainelli@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 9b878d023dac..8efdc271eb75 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1139,16 +1139,19 @@ static int __maybe_unused brcmuart_suspend(struct device *dev)
 	struct brcmuart_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
 	struct uart_port *port = &up->port;
-
-	serial8250_suspend_port(priv->line);
-	clk_disable_unprepare(priv->baud_mux_clk);
+	unsigned long flags;
 
 	/*
 	 * This will prevent resume from enabling RTS before the
-	 *  baud rate has been resored.
+	 *  baud rate has been restored.
 	 */
+	spin_lock_irqsave(&port->lock, flags);
 	priv->saved_mctrl = port->mctrl;
-	port->mctrl = 0;
+	port->mctrl &= ~TIOCM_RTS;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	serial8250_suspend_port(priv->line);
+	clk_disable_unprepare(priv->baud_mux_clk);
 
 	return 0;
 }
@@ -1158,6 +1161,7 @@ static int __maybe_unused brcmuart_resume(struct device *dev)
 	struct brcmuart_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
 	struct uart_port *port = &up->port;
+	unsigned long flags;
 	int ret;
 
 	ret = clk_prepare_enable(priv->baud_mux_clk);
@@ -1180,7 +1184,15 @@ static int __maybe_unused brcmuart_resume(struct device *dev)
 		start_rx_dma(serial8250_get_port(priv->line));
 	}
 	serial8250_resume_port(priv->line);
-	port->mctrl = priv->saved_mctrl;
+
+	if (priv->saved_mctrl & TIOCM_RTS) {
+		/* Restore RTS */
+		spin_lock_irqsave(&port->lock, flags);
+		port->mctrl |= TIOCM_RTS;
+		port->ops->set_mctrl(port, port->mctrl);
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
 	return 0;
 }
 
-- 
2.35.1



