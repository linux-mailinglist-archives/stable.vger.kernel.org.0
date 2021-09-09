Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405FD40570F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357552AbhIIN3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358410AbhIINHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E77632A7;
        Thu,  9 Sep 2021 12:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188831;
        bh=i87e17WOXkm0v1LGGjaD4mjMUEFLsZckqrJ/BER2TAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb7J4p7yDnDfU4Naa6UF9PaFoTPEvyKPe6i4M5zoOSpf4deA6CpM7g/s3BL4I2Vpv
         FVjhMkeDFPqc6D0DkMQw4AoudlBRy8Mqqtn1k3nFQF5XIyoTUAee+4OHkwQ5QzPv3U
         OyoCyD7EGDUybSWgWUHt8TMwGEmD1wkH4sxd9JUWtRyTs+PCEVj8IVpvcneb3wMLfn
         MItGW4nTX3z6hkNZAB3H90+nkB1Lu62mi7btg9n3ZBGCn01quJVKv4+2/zxLfeKEh+
         S6rD3xOA1LnR+vEEQD/hJS2XYkNmSKFhIjdlenZjLjoGW1nSbuswBugDDT6ZfEYsiC
         ZAshrIXwE20/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/48] tty: serial: jsm: hold port lock when reporting modem line changes
Date:   Thu,  9 Sep 2021 07:59:39 -0400
Message-Id: <20210909120015.150411-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 240e126c28df084222f0b661321e8e3ecb0d232e ]

uart_handle_dcd_change() requires a port lock to be held and will emit a
warning when lockdep is enabled.

Held corresponding lock to fix the following warnings.

[  132.528648] WARNING: CPU: 5 PID: 11600 at drivers/tty/serial/serial_core.c:3046 uart_handle_dcd_change+0xf4/0x120
[  132.530482] Modules linked in:
[  132.531050] CPU: 5 PID: 11600 Comm: jsm Not tainted 5.14.0-rc1-00003-g7fef2edf7cc7-dirty #31
[  132.535268] RIP: 0010:uart_handle_dcd_change+0xf4/0x120
[  132.557100] Call Trace:
[  132.557562]  ? __free_pages+0x83/0xb0
[  132.558213]  neo_parse_modem+0x156/0x220
[  132.558897]  neo_param+0x399/0x840
[  132.559495]  jsm_tty_open+0x12f/0x2d0
[  132.560131]  uart_startup.part.18+0x153/0x340
[  132.560888]  ? lock_is_held_type+0xe9/0x140
[  132.561660]  uart_port_activate+0x7f/0xe0
[  132.562351]  ? uart_startup.part.18+0x340/0x340
[  132.563003]  tty_port_open+0x8d/0xf0
[  132.563523]  ? uart_set_options+0x1e0/0x1e0
[  132.564125]  uart_open+0x24/0x40
[  132.564604]  tty_open+0x15c/0x630

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/1626242003-3809-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/jsm/jsm_neo.c | 2 ++
 drivers/tty/serial/jsm/jsm_tty.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index c6fdd6369534..96e01bf4599c 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -827,7 +827,9 @@ static void neo_parse_isr(struct jsm_board *brd, u32 port)
 		/* Parse any modem signal changes */
 		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
 			"MOD_STAT: sending to parse_modem_sigs\n");
+		spin_lock_irqsave(&ch->uart_port.lock, lock_flags);
 		neo_parse_modem(ch, readb(&ch->ch_neo_uart->msr));
+		spin_unlock_irqrestore(&ch->uart_port.lock, lock_flags);
 	}
 }
 
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index ec7d8383900f..7c790ff6b511 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -195,6 +195,7 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 
 static int jsm_tty_open(struct uart_port *port)
 {
+	unsigned long lock_flags;
 	struct jsm_board *brd;
 	struct jsm_channel *channel =
 		container_of(port, struct jsm_channel, uart_port);
@@ -248,6 +249,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_cached_lsr = 0;
 	channel->ch_stops_sent = 0;
 
+	spin_lock_irqsave(&port->lock, lock_flags);
 	termios = &port->state->port.tty->termios;
 	channel->ch_c_cflag	= termios->c_cflag;
 	channel->ch_c_iflag	= termios->c_iflag;
@@ -267,6 +269,7 @@ static int jsm_tty_open(struct uart_port *port)
 	jsm_carrier(channel);
 
 	channel->ch_open_count++;
+	spin_unlock_irqrestore(&port->lock, lock_flags);
 
 	jsm_dbg(OPEN, &channel->ch_bd->pci_dev, "finish\n");
 	return 0;
-- 
2.30.2

