Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5CB491A4B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352137AbiARC7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55770 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344858AbiARCq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D757B812A8;
        Tue, 18 Jan 2022 02:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535ADC36AF8;
        Tue, 18 Jan 2022 02:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474015;
        bh=3/QdR6SGlH1mYgnJ4NwJ66sQHw5xtbVGngxoo/WjW6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAu79wltTsU6A8cCPfX4KxefygQs4+jHZUUfr5iS/DNAGVkCLHN4+mgI89us7ptK8
         1cca1+3ogqsrIgIqoaWfhHMA0BUXZQ29Wz7O7npJJ0vyXKq0+XnMWNgIH6+2IKOhuZ
         FQLbiwY/gVPjQw0JiYJGmN9fvFySEcDgFoT+hJKYfHd2E6E17rZxm61soIHKbX671M
         EX4MUGWye/STUk12z+WbXxDINKwidiwBYXgHgyN9ySIajoTHjFhqM6zhGqqTAS0HqH
         VHmskWO2lMOUfkYcpEmj4TRB+0m5R0jlA8/gklFdLhe4nh5OIPJf9skTPFmO4V64mE
         HKKUWJvfZCeLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 71/73] serial: core: Keep mctrl register state and cached copy in sync
Date:   Mon, 17 Jan 2022 21:44:30 -0500
Message-Id: <20220118024432.1952028-71-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index aad640b9e3f4b..c8a047ba76ebe 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2395,7 +2395,8 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
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

