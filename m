Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5B5944EC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347528AbiHOW2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350398AbiHOW0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:26:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F74F616E;
        Mon, 15 Aug 2022 12:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EC48CE1262;
        Mon, 15 Aug 2022 19:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF609C433D6;
        Mon, 15 Aug 2022 19:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592717;
        bh=fo3ll5pcQBNpqpQas4n+4QsnziesAAEYRt8J1PUkuz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcndvjRerDcrVbdnPzsLYD0iekEXt7HN5HFk9HUFei3JawrFwCltKyzjpRCSHDN9+
         FLM3THnCk/LYxWZaSYKzuNvJyl0vTO9P+dQDmhUarYRXy+3vUh7ihevVRB/PcPvhTw
         bTZPXVLisFHkVdqplzgPo5xSSxG7Fd53Yy+a/jTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0835/1095] serial: pic32: fix missing clk_disable_unprepare() on error in pic32_uart_startup()
Date:   Mon, 15 Aug 2022 20:03:54 +0200
Message-Id: <20220815180503.873715086@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6f3cdf2bf1ba9b70de6c2921a415951a0d59873b ]

Fix the missing clk_disable_unprepare() before return
from pic32_uart_startup() in the error handling case.

Fixes: 157b9394709e ("serial: pic32_uart: Add PIC32 UART driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220525021204.2407631-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pic32_uart.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pic32_uart.c b/drivers/tty/serial/pic32_uart.c
index e3535bd8c8a2..a967b586a0a0 100644
--- a/drivers/tty/serial/pic32_uart.c
+++ b/drivers/tty/serial/pic32_uart.c
@@ -427,7 +427,7 @@ static int pic32_uart_startup(struct uart_port *port)
 	if (!sport->irq_fault_name) {
 		dev_err(port->dev, "%s: kasprintf err!", __func__);
 		ret = -ENOMEM;
-		goto out_done;
+		goto out_disable_clk;
 	}
 	irq_set_status_flags(sport->irq_fault, IRQ_NOAUTOEN);
 	ret = request_irq(sport->irq_fault, pic32_uart_fault_interrupt,
@@ -501,6 +501,8 @@ static int pic32_uart_startup(struct uart_port *port)
 out_f:
 	free_irq(sport->irq_fault, port);
 	kfree(sport->irq_fault_name);
+out_disable_clk:
+	clk_disable_unprepare(sport->clk);
 out_done:
 	return ret;
 }
-- 
2.35.1



