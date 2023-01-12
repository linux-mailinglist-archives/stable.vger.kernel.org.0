Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF6A6673C8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjALN6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbjALN6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:58:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C506A51320;
        Thu, 12 Jan 2023 05:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17FCACE1E6C;
        Thu, 12 Jan 2023 13:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D91C433EF;
        Thu, 12 Jan 2023 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531866;
        bh=lCEJW+tJ0xDVxotoL8Lbwx0uZXmF1js9Se1ZXIejMwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiL2aLvXQ2Dyf9/k1BUcgxgqzOt0wQh63rueiGrcNkmC9PqKjGk15v0siO2lAilI8
         20DK/77s/mIOGAzaCKzfVn/D3hQ+aAqch5Qwi4vlVosaBWkxVc/wOBbsbNvsxis0hF
         nDdxInI6F9evVhHRSd362veOUEVy+9edKrOvXJPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "linux-serial@vger.kernel.org, stable@vger.kernel.org, Rasmus Villemoes" 
        <linux@rasmusvillemoes.dk>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 5.15 08/10] serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"
Date:   Thu, 12 Jan 2023 14:56:45 +0100
Message-Id: <20230112135327.007152369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
driver-specific way") got backported to 5.15.y, there known as
b079d3775237, some hunks were accidentally left out.

In fsl_lpuart.c, this amounts to uart_remove_one_port() being called
in an error path despite uart_add_one_port() not having been called.

In serial_core.c, it is possible that the omission in
uart_suspend_port() is harmless, but the backport did have the
corresponding hunk in uart_resume_port(), it runs counter to the
original commit's intention of

  Skip any invocation of ->set_mctrl() if RS485 is enabled.

and it's certainly better to be aligned with upstream.

Fixes: b079d3775237 ("serial: Deassert Transmit Enable on probe in driver-specific way")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c  |    2 +-
 drivers/tty/serial/serial_core.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2784,9 +2784,9 @@ static int lpuart_probe(struct platform_
 	return 0;
 
 failed_irq_request:
-failed_get_rs485:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_get_rs485:
 failed_reset:
 	lpuart_disable_clks(sport);
 	return ret;
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2225,7 +2225,8 @@ int uart_suspend_port(struct uart_driver
 
 		spin_lock_irq(&uport->lock);
 		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		ops->stop_rx(uport);
 		spin_unlock_irq(&uport->lock);
 


