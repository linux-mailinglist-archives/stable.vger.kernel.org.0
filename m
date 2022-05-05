Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E965251CC1F
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiEEWhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386329AbiEEWhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:37:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939ED5EDF3
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C214ACE2C77
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE85AC385A8;
        Thu,  5 May 2022 22:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790027;
        bh=Fi+u5WZET84Zn+vrnBmYoQZHnxOvtg98F0HaE5dPLeg=;
        h=Subject:To:From:Date:From;
        b=WigleAa3f3LpbsQVrFYCNC3PafF3UaadJqrAqnPeNATdqL1VcLt/KMbykhfMubcF6
         Y/aAJ9nIJuLi7exjIC4M7Q5O2Ts916rrN1cXcLJ436VLTlSzBXwcNe3F0L8m45+1Ml
         UvWJngpCIxpcusEUaksGdS2otsBgQJUu+dSpvNDk=
Subject: patch "usb: typec: tcpci: Don't skip cleanup in .remove() on error" added to usb-linus
To:     u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 22:18:19 +0200
Message-ID: <1651781899174173@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci: Don't skip cleanup in .remove() on error

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bbc126ae381cf0a27822c1f822d0aeed74cc40d9 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Mon, 2 May 2022 10:04:56 +0200
Subject: usb: typec: tcpci: Don't skip cleanup in .remove() on error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Returning an error value in an i2c remove callback results in an error
message being emitted by the i2c core, but otherwise it doesn't make a
difference. The device goes away anyhow and the devm cleanups are
called.

In this case the remove callback even returns early without stopping the
tcpm worker thread and various timers. A work scheduled on the work
queue, or a firing timer after tcpci_remove() returned probably results
in a use-after-free situation because the regmap and driver data were
freed. So better make sure that tcpci_unregister_port() is called even
if disabling the irq failed.

Also emit a more specific error message instead of the i2c core's
"remove failed (EIO), will be ignored" and return 0 to suppress the
core's warning.

This patch is (also) a preparation for making i2c remove callbacks
return void.

Fixes: 3ba76256fc4e ("usb: typec: tcpci: mask event interrupts when remove driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220502080456.21568-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index e07d26a3cd8e..f33e08eb7670 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -877,7 +877,7 @@ static int tcpci_remove(struct i2c_client *client)
 	/* Disable chip interrupts before unregistering port */
 	err = tcpci_write16(chip->tcpci, TCPC_ALERT_MASK, 0);
 	if (err < 0)
-		return err;
+		dev_warn(&client->dev, "Failed to disable irqs (%pe)\n", ERR_PTR(err));
 
 	tcpci_unregister_port(chip->tcpci);
 
-- 
2.36.0


