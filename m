Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB4419AF0
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhI0ROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236470AbhI0RMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD3B6109F;
        Mon, 27 Sep 2021 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762533;
        bh=+zYL7T1/4xrs3hgcpHENCYVk/KXgpQFCdfVnSoBh09k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwLAjxIJEjArctwiy7tabMEIzHX1/8vkdhyAumd9SxYSFUH//3qJ5anHX/+5ILRqy
         M7+JHVWd3iYwT/sbSdXrtfDyRiuwtq2cgfb5t6QwEod1wbJ7JibJnG1ZWAeC21dffN
         iloBE7ChjqLiTmbcnynn3G2JYl3grDFttL+PuEHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.10 027/103] serial: 8250: 8250_omap: Fix RX_LVL register offset
Date:   Mon, 27 Sep 2021 19:01:59 +0200
Message-Id: <20210927170226.677530836@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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


