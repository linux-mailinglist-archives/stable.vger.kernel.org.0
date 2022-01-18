Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585E04917A7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343989AbiARCm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345821AbiARCcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:32:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD1C06175B;
        Mon, 17 Jan 2022 18:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AADFB81243;
        Tue, 18 Jan 2022 02:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E2DC36AEF;
        Tue, 18 Jan 2022 02:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473080;
        bh=AOczSnWdWced6oq1iyNUhjT2AeFnG/1hKhyVL7vUbzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYPJZ3eZODouLfdLgiMCznUEUJWDGXshBOVaacfD7PpIHZ85ElR2sSrOI5GnQusb9
         GW7aHJQqvrIS4yWX3nXDPWviEf2QOVvkfbu/26UURU1X1OxagAL54ntO4pyIXqMbcX
         MfUT8CMt4AzicBFOlEhIt2a9B3qBFhOPbkHWHbPy1ZoeCALrqhA1p+wdBQ3u3V/VF0
         frADz9AUkMNlSrFKoZMuRF33Y9XAtzMjwmWb5IMnN87D88ukP081Fg1PtSjMt6gOHy
         qoO1zux4ccbAw343af56ACPnEDYACHpkdbrg0xmP8crFTUe9AkSYc2Juy/DLHEyyk0
         Nom1QA67v+tGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 207/217] serial: core: Keep mctrl register state and cached copy in sync
Date:   Mon, 17 Jan 2022 21:19:30 -0500
Message-Id: <20220118021940.1942199-207-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 93a770b7e16772530196674ffc79bb13fa927dc6 ]

struct uart_port contains a cached copy of the Modem Control signals.
It is used to skip register writes in uart_update_mctrl() if the new
signal state equals the old signal state.  It also avoids a register
read to obtain the current state of output signals.

When a uart_port is registered, uart_configure_port() changes signal
state but neglects to keep the cached copy in sync.  That may cause
a subsequent register write to be incorrectly skipped.  Fix it before
it trips somebody up.

This behavior has been present ever since the serial core was introduced
in 2002:
https://git.kernel.org/history/history/c/33c0d1b0c3eb

So far it was never an issue because the cached copy is initialized to 0
by kzalloc() and when uart_configure_port() is executed, at most DTR has
been set by uart_set_options() or sunsu_console_setup().  Therefore,
a stable designation seems unnecessary.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/bceeaba030b028ed810272d55d5fc6f3656ddddb.1641129752.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 61e3dd0222af1..9e7e624a6c9db 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2393,7 +2393,8 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
+		port->mctrl &= TIOCM_DTR;
+		port->ops->set_mctrl(port, port->mctrl);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
-- 
2.34.1

