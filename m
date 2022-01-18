Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04717491B1F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349224AbiARDEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349201AbiARC4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936DBC02B749;
        Mon, 17 Jan 2022 18:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E49612CE;
        Tue, 18 Jan 2022 02:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E69C36AE3;
        Tue, 18 Jan 2022 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473859;
        bh=ttfyB81yNQlMenIPGF8dZQXmiBNmpBeJ8w+ZiOjs+5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYNydTgJadtn7XJPbFf98z/uNDPXq1TZDnNCfhOPt1MvU8WQI3g3S3i5PpKzOIXcT
         k3IEk28SjSQQ8t4CE9yx0SXMf8hIne/7l1/tQgGrNO8Jsh6E6568lgmqs9kbz0Mdfy
         ob3kFbCsJsNHV17T+sDN4xuuusZWU1sodYSwcwaHrXK/Ow17s/vim76OtL4ugQ0lKD
         wCThrXPWuV8T58BKiyp16DyOKyHR+MMd4rO+Vu1LudpyNcYIOhODK1g6+l9xRLJhHu
         Aa7zr2Q7yELZ3/lBLMm1AWnUQuJYauZBOlQ/elt08ja8Qr/vLaXi2ExTfP6EapsIsx
         JsVHUN2EOBTDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 111/116] serial: core: Keep mctrl register state and cached copy in sync
Date:   Mon, 17 Jan 2022 21:40:02 -0500
Message-Id: <20220118024007.1950576-111-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 046bedca7b8f5..55108db5b64bf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2414,7 +2414,8 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
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

