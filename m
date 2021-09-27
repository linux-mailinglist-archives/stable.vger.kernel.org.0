Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2976419B9B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhI0RUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237449AbhI0RSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E81736128A;
        Mon, 27 Sep 2021 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762752;
        bh=+zYL7T1/4xrs3hgcpHENCYVk/KXgpQFCdfVnSoBh09k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppDh6dU8gc47147R/AN/iY8NXjsn+YdVyumY3PqLxouyFQlbCROFABQOWx6AsL3Nw
         9bAWAh1uWLg9NKuDjPRthun6SOp3muArNLUr4bOx7bjUTOPdAnjugBGiF19XnsYW/7
         KQOz1vfuI+ptL5hn4MrwO6gWcAK8OlsLdeFom4Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.14 038/162] serial: 8250: 8250_omap: Fix RX_LVL register offset
Date:   Mon, 27 Sep 2021 19:01:24 +0200
Message-Id: <20210927170234.808085581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

commit 79e9e30a9292a62d25ab75488d3886108db1eaad upstream.

Commit b67e830d38fa ("serial: 8250: 8250_omap: Fix possible interrupt
storm on K3 SoCs") introduced fixup including a register read to
RX_LVL, however, we should be using word offset than byte offset
since our registers are on 4 byte boundary (port.regshift = 2) for
8250_omap.

Fixes: b67e830d38fa ("serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs")
Cc: stable <stable@vger.kernel.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210903050550.29050-1-nm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -106,7 +106,7 @@
 #define UART_OMAP_EFR2_TIMEOUT_BEHAVE	BIT(6)
 
 /* RX FIFO occupancy indicator */
-#define UART_OMAP_RX_LVL		0x64
+#define UART_OMAP_RX_LVL		0x19
 
 struct omap8250_priv {
 	int line;


