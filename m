Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B329498B5E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiAXTNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37678 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344191AbiAXTLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C0EB81235;
        Mon, 24 Jan 2022 19:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B74C340E5;
        Mon, 24 Jan 2022 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051498;
        bh=0NWLm4MpjGOMUQ6L/3GRQzNj72Wo2Ip9yWEX2IoCPiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZIEwKxNHzuHmtvQ8HYkCgMBArjs3WJw3upEg93d8Femu8eA5YG6WhvU/Ut3L5YNA
         /by5kzFrSgXbyF8clPNCzRmI46b9Iwr1Y5MkUkv2R4YN2m4XYFYr7WN6LV8AA3SGlQ
         385rYS4F6Qv3UYNS2f8fKpf0aI8kdLs0bfFJKzDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Gago Castano <rgc@hms.se>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 4.14 149/186] serial: Fix incorrect rs485 polarity on uart open
Date:   Mon, 24 Jan 2022 19:43:44 +0100
Message-Id: <20220124183941.900319614@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit d3b3404df318504ec084213ab1065b73f49b0f1d upstream.

Commit a6845e1e1b78 ("serial: core: Consider rs485 settings to drive
RTS") sought to deassert RTS when opening an rs485-enabled uart port.
That way, the transceiver does not occupy the bus until it transmits
data.

Unfortunately, the commit mixed up the logic and *asserted* RTS instead
of *deasserting* it:

The commit amended uart_port_dtr_rts(), which raises DTR and RTS when
opening an rs232 port.  "Raising" actually means lowering the signal
that's coming out of the uart, because an rs232 transceiver not only
changes a signal's voltage level, it also *inverts* the signal.  See
the simplified schematic in the MAX232 datasheet for an example:
https://www.ti.com/lit/ds/symlink/max232.pdf

So, to raise RTS on an rs232 port, TIOCM_RTS is *set* in port->mctrl
and that results in the signal being driven low.

In contrast to rs232, the signal level for rs485 Transmit Enable is the
identity, not the inversion:  If the transceiver expects a "high" RTS
signal for Transmit Enable, the signal coming out of the uart must also
be high, so TIOCM_RTS must be *cleared* in port->mctrl.

The commit did the exact opposite, but it's easy to see why given the
confusing semantics of rs232 and rs485.  Fix it.

Fixes: a6845e1e1b78 ("serial: core: Consider rs485 settings to drive RTS")
Cc: stable@vger.kernel.org # v4.14+
Cc: Rafael Gago Castano <rgc@hms.se>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Su Bao Cheng <baocheng.su@siemens.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/9395767847833f2f3193c49cde38501eeb3b5669.1639821059.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -172,7 +172,7 @@ static void uart_port_dtr_rts(struct uar
 	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
 
 	if (raise) {
-		if (rs485_on && !RTS_after_send) {
+		if (rs485_on && RTS_after_send) {
 			uart_set_mctrl(uport, TIOCM_DTR);
 			uart_clear_mctrl(uport, TIOCM_RTS);
 		} else {
@@ -181,7 +181,7 @@ static void uart_port_dtr_rts(struct uar
 	} else {
 		unsigned int clear = TIOCM_DTR;
 
-		clear |= (!rs485_on || !RTS_after_send) ? TIOCM_RTS : 0;
+		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
 		uart_clear_mctrl(uport, clear);
 	}
 }


