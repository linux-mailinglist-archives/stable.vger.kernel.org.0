Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4D66C7DB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjAPQf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbjAPQee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4DB222F9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED9ECB8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4832EC433D2;
        Mon, 16 Jan 2023 16:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886135;
        bh=MBu6CtxMxILESpZ9aOISdMboZQllQPiDEDGb5CAHzkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chsq5XciY9NQ4s0oU48A8Sxzz28l+6WcLxHa5c+iJooxEuzHbpnHnuaLUuZ3d1Sc7
         vqBqKGWXRbXKCMQMoGhnQNhD/ST410Kl572Y93jVQEpU6kZvpD6R9Fbq1YWU/E6wve
         a/Eq5g3uGumNVn4b7E4HP1FbhgFxgi9F/ZMvwRTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, delisun <delisun@pateo.com.cn>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 286/658] serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.
Date:   Mon, 16 Jan 2023 16:46:14 +0100
Message-Id: <20230116154922.674423349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 44485689333e..86084090232d 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1771,8 +1771,17 @@ static void pl011_enable_interrupts(struct uart_amba_port *uap)
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



