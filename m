Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB04DD9C4
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiCRMdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiCRMdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B582E1AA0
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 05:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 542A8B8222A
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 12:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3552C340E8;
        Fri, 18 Mar 2022 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647606738;
        bh=9tg8J5ZyZEwakC7w06ItLJTliJ00b051/r4hFi31nJs=;
        h=Subject:To:From:Date:From;
        b=rxDR5hpI1MFp/BwUQcbfdKCR5RnxNvxlTnIPJ9Jg1wWv4OVvfj8BIr8aqaE91nh/x
         F81mZhPVocLlMcHHadoPkYUyvZCJSDOSnGoePDT+/xnNiDNnyi1CHrORuPqrJa5/YV
         yEGz+GNasfvPqsKxu9OrHfrtCoe/HMe8nm1s7IG8=
Subject: patch "serial: sc16is7xx: Clear RS485 bits in the shutdown" added to tty-testing
To:     hui.wang@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 13:29:11 +0100
Message-ID: <164760655122119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sc16is7xx: Clear RS485 bits in the shutdown

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 927728a34f11b5a27f4610bdb7068317d6fdc72a Mon Sep 17 00:00:00 2001
From: Hui Wang <hui.wang@canonical.com>
Date: Tue, 8 Mar 2022 19:00:42 +0800
Subject: serial: sc16is7xx: Clear RS485 bits in the shutdown

We tested RS485 function on an EVB which has SC16IS752, after
finishing the test, we started the RS232 function test, but found the
RTS is still working in the RS485 mode.

That is because both startup and shutdown call port_update() to set
the EFCR_REG, this will not clear the RS485 bits once the bits are set
in the reconf_rs485(). To fix it, clear the RS485 bits in shutdown.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220308110042.108451-1-hui.wang@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 683dd3be010d..91434876fcde 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1238,10 +1238,12 @@ static void sc16is7xx_shutdown(struct uart_port *port)
 
 	/* Disable all interrupts */
 	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, 0);
-	/* Disable TX/RX */
+	/* Disable TX/RX, clear auto RS485 and RTS invert */
 	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
-			      SC16IS7XX_EFCR_TXDISABLE_BIT,
+			      SC16IS7XX_EFCR_TXDISABLE_BIT |
+			      SC16IS7XX_EFCR_AUTO_RS485_BIT |
+			      SC16IS7XX_EFCR_RTS_INVERT_BIT,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
 			      SC16IS7XX_EFCR_TXDISABLE_BIT);
 
-- 
2.35.1


