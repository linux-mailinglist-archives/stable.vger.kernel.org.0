Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0272DD9F14
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389488AbfJPV67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438338AbfJPV66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:58 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066C5218DE;
        Wed, 16 Oct 2019 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263137;
        bh=uqDXuX7FvYTlA5CnBCXp8htezwOXB+LqJ3hsJ+v+GvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3AV57GFEUbwppWlg2Z6sCPqdyPrhnH/pncu4E3//W710xMhxwOkgq5a6j2UT6mjM
         C3JIS4USbtv+AyN4oxldyqC1LLlhlcI5leHYDa6c95hQ3wqx4F6cdgdRYclqR6Zox9
         UXacKFb7TbO2sO8CPv/I6Km0eh2Q6XhPOF//vkcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Thomas <pthomas8589@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.3 025/112] serial: uartps: Fix uartps_major handling
Date:   Wed, 16 Oct 2019 14:50:17 -0700
Message-Id: <20191016214852.267606672@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 5e9bd2d70ae7c00a95a22994abf1eef728649e64 upstream.

There are two parts which should be fixed. The first one is to assigned
uartps_major at the end of probe() to avoid complicated logic when
something fails.
The second part is initialized uartps_major number to 0 when last device is
removed. This will ensure that on next probe driver will ask for new
dynamic major number.

Fixes: ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
Reported-by: Paul Thomas <pthomas8589@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/d2652cda992833315c4f96f06953eb547f928918.1570194248.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1550,7 +1550,6 @@ static int cdns_uart_probe(struct platfo
 		goto err_out_id;
 	}
 
-	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
 
 	/*
@@ -1680,6 +1679,7 @@ static int cdns_uart_probe(struct platfo
 		console_port = NULL;
 #endif
 
+	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
 	return 0;
@@ -1741,6 +1741,12 @@ static int cdns_uart_remove(struct platf
 		console_port = NULL;
 #endif
 
+	/* If this is last instance major number should be initialized */
+	mutex_lock(&bitmap_lock);
+	if (bitmap_empty(bitmap, MAX_UART_INSTANCES))
+		uartps_major = 0;
+	mutex_unlock(&bitmap_lock);
+
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }


