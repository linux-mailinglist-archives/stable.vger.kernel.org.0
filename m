Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C931D0D5D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgEMJw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387790AbgEMJw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB6A23126;
        Wed, 13 May 2020 09:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363545;
        bh=m4OrOZL8crQYHnrOPkXWRFuyywZvyIlriP+ZcXtbBbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqjwboEPIvr72EubkovfI87tXe1gNKbl/RNO+ZTAQq/XOeajIVqfAz6g3QbQreM5D
         SDYs51cXgEji3Uxirv1/WmFLenR1eM00M3pnrDDzKvRPYWMA/7AgzI99FGPOgUxBci
         pGx0CU+ZjhkCMtoFHkgl5ozMzCp3Mj9XBMZmmdmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 006/118] tty: xilinx_uartps: Fix missing id assignment to the console
Date:   Wed, 13 May 2020 11:43:45 +0200
Message-Id: <20200513094418.189283975@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit 2ae11c46d5fdc46cb396e35911c713d271056d35 ]

When serial console has been assigned to ttyPS1 (which is serial1 alias)
console index is not updated property and pointing to index -1 (statically
initialized) which ends up in situation where nothing has been printed on
the port.

The commit 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console
and driver structures"") didn't contain this line which was removed by
accident.

Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/xilinx_uartps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 7a9b360b04386..1d8b6993a4357 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1471,6 +1471,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 		cdns_uart_uart_driver.cons = &cdns_uart_console;
+		cdns_uart_console.index = id;
 #endif
 
 		rc = uart_register_driver(&cdns_uart_uart_driver);
-- 
2.20.1



