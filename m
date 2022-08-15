Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611D7594C7E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbiHPAhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351696AbiHPAga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E9B18AF6B;
        Mon, 15 Aug 2022 13:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B17760F60;
        Mon, 15 Aug 2022 20:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D314C433D6;
        Mon, 15 Aug 2022 20:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595884;
        bh=ZurvHXy/PIhBJFstbkZGNdrhZW8zwizCA+LB6kC0hGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOWttz6c8s4tSgw5rcSLGgGNDKH3rIamcUU/V31C+33BrWkM7FfMXLOByVStf+caD
         3J3Ru+lQYabj9c8PtZfvcGzmPqjm4bEP/fDWafs3PfoKP53jljwH70hEY/JprE0NUK
         xsYtwSVnnj2AQlM+30bkB9dah2gsEWptr2yzsLGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0898/1157] serial: pic32: fix missing clk_disable_unprepare() on error in pic32_uart_startup()
Date:   Mon, 15 Aug 2022 20:04:14 +0200
Message-Id: <20220815180515.360402684@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index b399aac530fe..f418f1de66b3 100644
--- a/drivers/tty/serial/pic32_uart.c
+++ b/drivers/tty/serial/pic32_uart.c
@@ -503,7 +503,7 @@ static int pic32_uart_startup(struct uart_port *port)
 	if (!sport->irq_fault_name) {
 		dev_err(port->dev, "%s: kasprintf err!", __func__);
 		ret = -ENOMEM;
-		goto out_done;
+		goto out_disable_clk;
 	}
 	irq_set_status_flags(sport->irq_fault, IRQ_NOAUTOEN);
 	ret = request_irq(sport->irq_fault, pic32_uart_fault_interrupt,
@@ -579,6 +579,8 @@ static int pic32_uart_startup(struct uart_port *port)
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



