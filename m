Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61D0622B1A
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiKIMF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKIMF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:05:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E3B2A411
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF3F619F2
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 12:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136DC433D6;
        Wed,  9 Nov 2022 12:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667995525;
        bh=G91+MUlOxshbzn4k6urUOOVLJIWgAgOkk+59xwucJBc=;
        h=Subject:To:From:Date:From;
        b=ttkHSCaPCetvm4vjmED8R8CmdR8wvOO59d3NQXJoaV9GJ+GtU3MnoZ/oMzG+96Uz+
         3XrwFFQemnafupWFkSeIm6FSCuv73l0J/RAgM63MiUx2WX8TYYLSAbJchtBNrEQA21
         dzlb0OjXvugqIP+L3tmkPbhQoOOJDuoSefORMUJg=
Subject: patch "serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake" added to tty-linus
To:     ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        wentong.wu@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Nov 2022 13:05:11 +0100
Message-ID: <1667995511351@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7090abd6ad0610a144523ce4ffcb8560909bf2a8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 8 Nov 2022 14:19:51 +0200
Subject: serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Configure DMA to use 16B burst size with Elkhart Lake. This makes the
bus use more efficient and works around an issue which occurs with the
previously used 1B.

The fix was initially developed by Srikanth Thokala and Aman Kumar.
This together with the previous config change is the cleaned up version
of the original fix.

Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
Reported-by: Wentong Wu <wentong.wu@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_lpss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 7d9cddbfef40..0e43bdfb7459 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -174,6 +174,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	 */
 	up->dma = dma;
 
+	lpss->dma_maxburst = 16;
+
 	port->set_termios = dw8250_do_set_termios;
 
 	return 0;
-- 
2.38.1


