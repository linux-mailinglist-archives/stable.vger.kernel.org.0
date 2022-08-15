Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8193D594413
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348672AbiHOW3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350228AbiHOW0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA9128EC6;
        Mon, 15 Aug 2022 12:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F3061222;
        Mon, 15 Aug 2022 19:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C411C43140;
        Mon, 15 Aug 2022 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592711;
        bh=GoIK9W5tFF1ThOTmt9iGmRMGayudum/t1PMhPQgfubw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDtR42bB7zSmpLIWurUL9CscBs8PSxD6eW/iyaHnRsWM8hMUcib8giUEOqsZTgr7i
         kHTMrEM4/xJgN+daIoAFEbJploEOec5K1Aq5b+04QDpU6dzmJU15RDwwsIZzj1Z/Mh
         rRhWDSSQuPZHpzdLe/CQ3OrA3zhgvQXxSyEFsDws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0834/1095] serial: pic32: free up irq names correctly
Date:   Mon, 15 Aug 2022 20:03:53 +0200
Message-Id: <20220815180503.829667712@linuxfoundation.org>
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

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit fe36fa18ca77ca3ca9f90aab6cf39031416e432b ]

struct pic32_sport contains built-up names for irqs. These are freed
only in error path of pic32_uart_startup(). And even there, the freeing
happens before free_irq().

So fix this by:
* moving frees after free_irq(), and
* add frees to pic32_uart_shutdown() -- the opposite of
  pic32_uart_startup().

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220503063122.20957-11-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pic32_uart.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/pic32_uart.c b/drivers/tty/serial/pic32_uart.c
index b7a3a1b959b1..e3535bd8c8a2 100644
--- a/drivers/tty/serial/pic32_uart.c
+++ b/drivers/tty/serial/pic32_uart.c
@@ -493,14 +493,14 @@ static int pic32_uart_startup(struct uart_port *port)
 	return 0;
 
 out_t:
-	kfree(sport->irq_tx_name);
 	free_irq(sport->irq_tx, port);
+	kfree(sport->irq_tx_name);
 out_r:
-	kfree(sport->irq_rx_name);
 	free_irq(sport->irq_rx, port);
+	kfree(sport->irq_rx_name);
 out_f:
-	kfree(sport->irq_fault_name);
 	free_irq(sport->irq_fault, port);
+	kfree(sport->irq_fault_name);
 out_done:
 	return ret;
 }
@@ -519,8 +519,11 @@ static void pic32_uart_shutdown(struct uart_port *port)
 
 	/* free all 3 interrupts for this UART */
 	free_irq(sport->irq_fault, port);
+	kfree(sport->irq_fault_name);
 	free_irq(sport->irq_tx, port);
+	kfree(sport->irq_tx_name);
 	free_irq(sport->irq_rx, port);
+	kfree(sport->irq_rx_name);
 }
 
 /* serial core request to change current uart setting */
-- 
2.35.1



