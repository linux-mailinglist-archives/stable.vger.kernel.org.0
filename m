Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818F7451D88
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345679AbhKOT3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244391AbhKOTOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B8D6340D;
        Mon, 15 Nov 2021 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000437;
        bh=UIU8fn2r++JvQ/HB870lAGI4pAU7rADe1TVFedbvmdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4eogyrclX+LG8ADhRdm0Zd5ooQ84WPrAdKvl4tIhuds57fHmEK5cZJeF01cq7psJ
         QPEfLHHRE2QfHILO98NM7W4Ee8DvCoZYG1eH2N/FbvPSfeq4ZrGF7tdnRlNHPec5dp
         UpBP/i322z7XXL8IxP8ItsWW0rxSnVnuNzkz/KdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 659/849] serial: cpm_uart: Protect udbg definitions by CONFIG_SERIAL_CPM_CONSOLE
Date:   Mon, 15 Nov 2021 18:02:22 +0100
Message-Id: <20211115165442.553570780@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit d142585bceb3218ad432ed0fcd5be9d6e3cd9052 ]

If CONFIG_CONSOLE_POLL=y, and CONFIG_SERIAL_CPM=m (hence
CONFIG_SERIAL_CPM_CONSOLE=n):

    drivers/tty/serial/cpm_uart/cpm_uart_core.c:1109:12: warning: ‘udbg_cpm_getc’ defined but not used [-Wunused-function]
     1109 | static int udbg_cpm_getc(void)
	  |            ^~~~~~~~~~~~~
    drivers/tty/serial/cpm_uart/cpm_uart_core.c:1095:13: warning: ‘udbg_cpm_putc’ defined but not used [-Wunused-function]
     1095 | static void udbg_cpm_putc(char c)
	  |             ^~~~~~~~~~~~~

Fix this by making the udbg definitions depend on
CONFIG_SERIAL_CPM_CONSOLE, in addition to CONFIG_CONSOLE_POLL.

Fixes: a60526097f42eb98 ("tty: serial: cpm_uart: Add udbg support for enabling xmon")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20211027075326.3270785-1-geert@linux-m68k.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index c719aa2b18328..d6d3db9c3b1f8 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1090,6 +1090,7 @@ static void cpm_put_poll_char(struct uart_port *port,
 	cpm_uart_early_write(pinfo, ch, 1, false);
 }
 
+#ifdef CONFIG_SERIAL_CPM_CONSOLE
 static struct uart_port *udbg_port;
 
 static void udbg_cpm_putc(char c)
@@ -1114,6 +1115,7 @@ static int udbg_cpm_getc(void)
 		cpu_relax();
 	return c;
 }
+#endif /* CONFIG_SERIAL_CPM_CONSOLE */
 
 #endif /* CONFIG_CONSOLE_POLL */
 
-- 
2.33.0



