Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9164DE6AC
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 08:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiCSHW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 03:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242375AbiCSHW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 03:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A4F2A1293
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 00:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C545360C8F
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 07:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F540C340EC;
        Sat, 19 Mar 2022 07:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647674468;
        bh=R+nmVjW1EM4Xz0DDBUNMIKomF5nAAyJQh7nwdobx+sM=;
        h=Subject:To:From:Date:From;
        b=oPPcFqCKLUwO6WL84mX6UZeU8cf05T3Odo5uNuubyqO8z29A9pw7Y6mxg/IC9C6Mp
         KLcPCMA7QfwpP+UgDaoeU3+IMdTASUkgVrzgylSDNbtXxtB6XQycf4FdgnitRWDygO
         +OahJfCZhiSoXHS/jbD/t0isYc46aOhDKP/C5iwk=
Subject: patch "serial: sc16is7xx: Clear RS485 bits in the shutdown" added to tty-next
To:     hui.wang@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 19 Mar 2022 08:19:29 +0100
Message-ID: <16476743699618@kroah.com>
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
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


