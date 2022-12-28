Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3465811B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiL1QZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiL1QYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F73183AD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC2FB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A83BC433EF;
        Wed, 28 Dec 2022 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244478;
        bh=FkhWfCq6aFAUBTTHKhFSXWhEzPjELgj/IBt//V8wm80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txomsBvqm6ZUzUZ7LqM9Ssw4HuB8XuxsFu63A80PRLyiodMJaORC6HjgLvIWNtr3p
         ChUfbfu52tp/GOhzYNk/EXPeZZsfeoUHFEcAQ58SMaZhhedzUjYkgbSJgi+aXiipng
         8hjnzIu15Yvc37yn3h7WuaM95+JEc+QO9504roSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, delisun <delisun@pateo.com.cn>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0685/1073] serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.
Date:   Wed, 28 Dec 2022 15:37:53 +0100
Message-Id: <20221228144346.642413557@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: delisun <delisun@pateo.com.cn>

[ Upstream commit 032d5a71ed378ffc6a2d41a187d8488a4f9fe415 ]

Clearing the RX FIFO will cause data loss.
Copy the pl011_enabl_interrupts implementation, and remove the clear
interrupt and FIFO part of the code.

Fixes: 211565b10099 ("serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle")
Signed-off-by: delisun <delisun@pateo.com.cn>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20221110020108.7700-1-delisun@pateo.com.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 72c2a978cf61..c211a1e92db7 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1831,8 +1831,17 @@ static void pl011_enable_interrupts(struct uart_amba_port *uap)
 static void pl011_unthrottle_rx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = container_of(port, struct uart_amba_port, port);
+	unsigned long flags;
 
-	pl011_enable_interrupts(uap);
+	spin_lock_irqsave(&uap->port.lock, flags);
+
+	uap->im = UART011_RTIM;
+	if (!pl011_dma_rx_running(uap))
+		uap->im |= UART011_RXIM;
+
+	pl011_write(uap->im, uap, REG_IMSC);
+
+	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
 static int pl011_startup(struct uart_port *port)
-- 
2.35.1



