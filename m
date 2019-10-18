Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D9BDD19E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfJRWEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfJRWEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC5D222C3;
        Fri, 18 Oct 2019 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436263;
        bh=vOxgA07gZhgreIxvC378VR7YjrXYnrjkGDXa/aPtFWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ9MqoHAbQFXjrsFXiixRxE8S/iFEzbJd990tTRgDnnmXM0MAeVUoijPD5UurRO8g
         foD7XOrpjjvom9I8ypiBHe0M8fXzGZ0fs5UCRolfpKfGQTS2tKem5T20gqSwvAp7lv
         fPeFW9kaSdWjE2Xd1I+MfzzUluepzEPGctPK9Zow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 45/89] serial: 8250_omap: Fix gpio check for auto RTS/CTS
Date:   Fri, 18 Oct 2019 18:02:40 -0400
Message-Id: <20191018220324.8165-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit fc64f7abbef2dae7ee4c94702fb3cf9a2be5431a ]

There are two checks to see if the manual gpio is configured, but
these the check is seeing if the structure is NULL instead it
should check to see if there are CTS and/or RTS pins defined.

This patch uses checks for those individual pins instead of
checking for the structure itself to restore auto RTS/CTS.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20191006163314.23191-2-aford173@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3ef65cbd2478a..e4b08077f8757 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -141,7 +141,7 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	serial8250_do_set_mctrl(port, mctrl);
 
-	if (!up->gpios) {
+	if (!mctrl_gpio_to_gpiod(up->gpios, UART_GPIO_RTS)) {
 		/*
 		 * Turn off autoRTS if RTS is lowered and restore autoRTS
 		 * setting if RTS is raised
@@ -456,7 +456,8 @@ static void omap_8250_set_termios(struct uart_port *port,
 	up->port.status &= ~(UPSTAT_AUTOCTS | UPSTAT_AUTORTS | UPSTAT_AUTOXOFF);
 
 	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW &&
-	    !up->gpios) {
+	    !mctrl_gpio_to_gpiod(up->gpios, UART_GPIO_RTS) &&
+	    !mctrl_gpio_to_gpiod(up->gpios, UART_GPIO_CTS)) {
 		/* Enable AUTOCTS (autoRTS is enabled when RTS is raised) */
 		up->port.status |= UPSTAT_AUTOCTS | UPSTAT_AUTORTS;
 		priv->efr |= UART_EFR_CTS;
-- 
2.20.1

