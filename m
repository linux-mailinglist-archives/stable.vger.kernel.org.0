Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE51BCA1A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbgD1SqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730044AbgD1SoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F022085B;
        Tue, 28 Apr 2020 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099457;
        bh=sZhZohU2064bhWgEYZVebd2hh7nsqGdpYbtA9VE2usU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRT20zByFkYKcDbErqXIR0GnIK+QCPWORv+IR0qgoIw9Hk6avF1OxqQRD13PpjegK
         QXeqd7rugEgwF63Y3d7mI6ec+4TR0/CH2yMs36/n8/vSkaCQ+FgkH5ARLHclJfKN7B
         Oa+RUFlTN1lf1rUkHTZxXa1RwaaI0c2YsujNNl2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.4 158/168] Revert "serial: uartps: Fix uartps_major handling"
Date:   Tue, 28 Apr 2020 20:25:32 +0200
Message-Id: <20200428182251.102233817@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 2e01911b7cf7aa07a304a809eca1b11a4bd35859 upstream.

This reverts commit 5e9bd2d70ae7c00a95a22994abf1eef728649e64.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
    https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/310999ab5342f788a7bc1b0e68294d4f052cad07.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1550,6 +1550,7 @@ static int cdns_uart_probe(struct platfo
 		goto err_out_id;
 	}
 
+	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
 
 	/*
@@ -1679,7 +1680,6 @@ static int cdns_uart_probe(struct platfo
 		console_port = NULL;
 #endif
 
-	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
 	return 0;
@@ -1741,12 +1741,6 @@ static int cdns_uart_remove(struct platf
 		console_port = NULL;
 #endif
 
-	/* If this is last instance major number should be initialized */
-	mutex_lock(&bitmap_lock);
-	if (bitmap_empty(bitmap, MAX_UART_INSTANCES))
-		uartps_major = 0;
-	mutex_unlock(&bitmap_lock);
-
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }


