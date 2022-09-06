Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65BF5AECC1
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiIFOOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiIFOMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA01C86FC2;
        Tue,  6 Sep 2022 06:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338F961540;
        Tue,  6 Sep 2022 13:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C5DC433C1;
        Tue,  6 Sep 2022 13:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471982;
        bh=d3KO6J4JH2Ikto3JSUb8HPcLA69we/6vu/tdj+4a8jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2tcU6433+EX+tWxXC6mWvZX0aCKcANl+no2ysZUvsthgnj0XPe1zMnA52BHQRUF+
         SprdzLyFoYaOgi1PlWS3vpCHKFSmYb4xLfhtTdfQZWeauGzx4gESjM3cINRCPsd9K0
         1nbRVQfIGBaasW7gV2QcaeuNDHjKQVWsp6WEAhyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 5.19 066/155] tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete
Date:   Tue,  6 Sep 2022 15:30:14 +0200
Message-Id: <20220906132832.233182809@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

commit d5a2e0834364377a5d5a2fff1890a0b3f0bafd1f upstream.

When the user initializes the uart port, and waits for the transmit
engine to complete in lpuart32_set_termios(), if the UART TX fifo has
dirty data and the UARTMODIR enable the flow control, the TX fifo may
never be empty. So here we should disable the flow control first to make
sure the transmit engin can complete.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20220821101527.10066-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2182,6 +2182,7 @@ lpuart32_set_termios(struct uart_port *p
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* wait transmit engin complete */
+	lpuart32_write(&sport->port, 0, UARTMODIR);
 	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
 
 	/* disable transmit and receive */


