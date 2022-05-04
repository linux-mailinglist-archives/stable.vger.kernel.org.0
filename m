Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D786351A7E4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiEDRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355444AbiEDRE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9B54EA23;
        Wed,  4 May 2022 09:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940B3617DE;
        Wed,  4 May 2022 16:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A6CC385A4;
        Wed,  4 May 2022 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683180;
        bh=RxD54wOIf+gtesh7VHfBEjiXkcaf7g6pr7I4+AwcUM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6nlNeODBqhzd3ClvX6epppH5w1bJRUuwozvWubRaaPse6vTYd3y4xaEjWFCqf7Ax
         Q5u/kHw1z1HVXjg4go7dj6PQVnvR/MB87CAEgB9Ty9bbpDgtazB6sD1S1yw1tPc9/T
         ly23VCySTQ98NVmKwxqEGTzkkFFZeFWgOiL53+mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.15 031/177] serial: 8250: Also set sticky MCR bits in console restoration
Date:   Wed,  4 May 2022 18:43:44 +0200
Message-Id: <20220504153055.785959388@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 6e6eebdf5e2455f089ccd000754a0deaeb79af82 upstream.

Sticky MCR bits are lost in console restoration if console suspending
has been disabled.  This currently affects the AFE bit, which works in
combination with RTS which we set, so we want to make sure the UART
retains control of its FIFO where previously requested.  Also specific
drivers may need other bits in the future.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 4516d50aabed ("serial: 8250: Use canary to restart console after suspend")
Cc: stable@vger.kernel.org # v4.0+
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204181518490.9383@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -3340,7 +3340,7 @@ static void serial8250_console_restore(s
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
-	serial8250_out_MCR(up, UART_MCR_DTR | UART_MCR_RTS);
+	serial8250_out_MCR(up, up->mcr | UART_MCR_DTR | UART_MCR_RTS);
 }
 
 /*


