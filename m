Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCE676F39
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjAVPTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjAVPTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33B22036
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A5A60C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741E7C433D2;
        Sun, 22 Jan 2023 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400741;
        bh=bosIJdD5zsoy0xeEIrgMLrS3i3JniE4zWZ8mBsrvfNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYo6bzQ8CI6ticnhZYjiNUlg9YlLHCG/V5RTjRrhIJfuJimv4eNo96GrPFglVMpAP
         3xmlCWGw172XOxQ+fDEJBq1fht07Hbj7tYotsdM9n9QUXxq10DO7/oMe8jfrHt1Xy3
         lKlyN7QnhWeNphUShkqAysmYpBDWQRVP+TIyaF38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Tobias Schramm <t.schramm@manjaro.org>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 5.15 091/117] serial: atmel: fix incorrect baudrate setup
Date:   Sun, 22 Jan 2023 16:04:41 +0100
Message-Id: <20230122150236.581696923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Schramm <t.schramm@manjaro.org>

commit 5bfdd3c654bd879bff50c2e85e42f85ae698b42f upstream.

Commit ba47f97a18f2 ("serial: core: remove baud_rates when serial console
setup") changed uart_set_options to select the correct baudrate
configuration based on the absolute error between requested baudrate and
available standard baudrate settings.
Prior to that commit the baudrate was selected based on which predefined
standard baudrate did not exceed the requested baudrate.
This change of selection logic was never reflected in the atmel serial
driver. Thus the comment left in the atmel serial driver is no longer
accurate.
Additionally the manual rounding up described in that comment and applied
via (quot - 1) requests an incorrect baudrate. Since uart_set_options uses
tty_termios_encode_baud_rate to determine the appropriate baudrate flags
this can cause baudrate selection to fail entirely because
tty_termios_encode_baud_rate will only select a baudrate if relative error
between requested and selected baudrate does not exceed +/-2%.
Fix that by requesting actual, exact baudrate used by the serial.

Fixes: ba47f97a18f2 ("serial: core: remove baud_rates when serial console setup")
Cc: stable <stable@kernel.org>
Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Link: https://lore.kernel.org/r/20230109072940.202936-1-t.schramm@manjaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2615,13 +2615,7 @@ static void __init atmel_console_get_opt
 	else if (mr == ATMEL_US_PAR_ODD)
 		*parity = 'o';
 
-	/*
-	 * The serial core only rounds down when matching this to a
-	 * supported baud rate. Make sure we don't end up slightly
-	 * lower than one of those, as it would make us fall through
-	 * to a much lower baud rate than we really want.
-	 */
-	*baud = port->uartclk / (16 * (quot - 1));
+	*baud = port->uartclk / (16 * quot);
 }
 
 static int __init atmel_console_setup(struct console *co, char *options)


