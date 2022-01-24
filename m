Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE91499E50
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345750AbiAXWcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582430AbiAXWPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:15:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082C9C0E2631;
        Mon, 24 Jan 2022 12:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD8D60B21;
        Mon, 24 Jan 2022 20:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805EEC340EA;
        Mon, 24 Jan 2022 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057060;
        bh=uAlWWnbqersf2Iz6eORks7ljC27rMrLewZjq8ZOs8Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fxmw28WAXAfLg7yFrcRxFyZ34EGtKmd/K9j+vUhL8nAfY0OESrfsanBrDHvkDDwC
         Yz/aWwF0pSzGRyJ452Nhum41yAbc8HT+TI7LyajBOiv9/poAXBHo4B9qJ1jZoQCHFO
         hmrTIcN10k3p3g4H3V9MFGO4GXKT+rYjcs0rMC2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Gago Castano <rgc@hms.se>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.15 681/846] serial: Fix incorrect rs485 polarity on uart open
Date:   Mon, 24 Jan 2022 19:43:18 +0100
Message-Id: <20220124184124.566153384@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -162,7 +162,7 @@ static void uart_port_dtr_rts(struct uar
 	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
 
 	if (raise) {
-		if (rs485_on && !RTS_after_send) {
+		if (rs485_on && RTS_after_send) {
 			uart_set_mctrl(uport, TIOCM_DTR);
 			uart_clear_mctrl(uport, TIOCM_RTS);
 		} else {
@@ -171,7 +171,7 @@ static void uart_port_dtr_rts(struct uar
 	} else {
 		unsigned int clear = TIOCM_DTR;
 
-		clear |= (!rs485_on || !RTS_after_send) ? TIOCM_RTS : 0;
+		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
 		uart_clear_mctrl(uport, clear);
 	}
 }


