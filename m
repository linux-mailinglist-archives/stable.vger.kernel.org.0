Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB651064E2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfKVFwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfKVFwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E642A20721;
        Fri, 22 Nov 2019 05:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401952;
        bh=67ctx2UvLzaWfCpTse8B8UnbRzR1jz/Cquxpnsnzme4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW99yPSu5MPovPzhTCaxBhN4yGMfYrwOkHAYzQFmd/2RfoFIPZj7gpGu62u4ehjgy
         fbkNcjwozVXaFRFBjyxqehr1Do1qtvdWd63CwtIuMSMLXQOs/udzoyftuPrF3vkzWl
         yE4+fhNYllsp6JB9mOLlEf6Q/tktGgs2uQdGjZIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Zhe <zhe.he@windriver.com>,
        Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/219] serial: 8250: Fix serial8250 initialization crash
Date:   Fri, 22 Nov 2019 00:48:27 -0500
Message-Id: <20191122054911.1750-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit 352c4cf40c4a7d439fa5d30aa2160f54b394da82 ]

The initialization code of interrupt backoff work might reference NULL
pointer and cause the following crash, if no port was found.

[   10.017727] CPU 0 Unable to handle kernel paging request at virtual address 000001b0, epc == 807088e0, ra == 8070863c
---- snip ----
[   11.704470] [<807088e0>] serial8250_register_8250_port+0x318/0x4ac
[   11.747251] [<80708d74>] serial8250_probe+0x148/0x1c0
[   11.789301] [<80728450>] platform_drv_probe+0x40/0x94
[   11.830515] [<807264f8>] really_probe+0xf8/0x318
[   11.870876] [<80726b7c>] __driver_attach+0x110/0x12c
[   11.910960] [<80724374>] bus_for_each_dev+0x78/0xcc
[   11.951134] [<80725958>] bus_add_driver+0x200/0x234
[   11.989756] [<807273d8>] driver_register+0x84/0x148
[   12.029832] [<80d72f84>] serial8250_init+0x138/0x198
[   12.070447] [<80100e6c>] do_one_initcall+0x5c/0x2a0
[   12.110104] [<80d3a208>] kernel_init_freeable+0x370/0x484
[   12.150722] [<80a49420>] kernel_init+0x10/0xf8
[   12.191517] [<8010756c>] ret_from_kernel_thread+0x14/0x1c

This patch makes sure the initialization code can be reached only if a port
is found.

Fixes: 6d7f677a2afa ("serial: 8250: Rate limit serial port rx interrupts during input overruns")
Signed-off-by: He Zhe <zhe.he@windriver.com>
Reviewed-by: Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 0e65d4261f94c..69aaee5d7fe14 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1074,15 +1074,16 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 
 			ret = 0;
 		}
-	}
 
-	/* Initialise interrupt backoff work if required */
-	if (up->overrun_backoff_time_ms > 0) {
-		uart->overrun_backoff_time_ms = up->overrun_backoff_time_ms;
-		INIT_DELAYED_WORK(&uart->overrun_backoff,
-				  serial_8250_overrun_backoff_work);
-	} else {
-		uart->overrun_backoff_time_ms = 0;
+		/* Initialise interrupt backoff work if required */
+		if (up->overrun_backoff_time_ms > 0) {
+			uart->overrun_backoff_time_ms =
+				up->overrun_backoff_time_ms;
+			INIT_DELAYED_WORK(&uart->overrun_backoff,
+					serial_8250_overrun_backoff_work);
+		} else {
+			uart->overrun_backoff_time_ms = 0;
+		}
 	}
 
 	mutex_unlock(&serial_mutex);
-- 
2.20.1

