Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD775528EF9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbiEPTrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346679AbiEPTqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046F43FD9D;
        Mon, 16 May 2022 12:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9099261510;
        Mon, 16 May 2022 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBAAC36AEA;
        Mon, 16 May 2022 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730240;
        bh=WTHpzwtAqaG4p8ZDiFKFtwWmjszYiarCrdkZOWf9M6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXdGPQp6iJqY61TRtNwx0PMpIpJOsNvZ0aUOUQOS0zDyznQ18xI+q2P8+USdFqGBP
         hebxIGHuP23iNP3Pt5gIOqloasfrxFoD2zsFKDFQm5sZqcfmHRNZpeJy8YAiYgr+8L
         K4qxrYh8x4s4JPRuKQhvW0o1nlF2mUkU6N4hGnlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 27/43] usb: typec: tcpci: Dont skip cleanup in .remove() on error
Date:   Mon, 16 May 2022 21:36:38 +0200
Message-Id: <20220516193615.521087046@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit bbc126ae381cf0a27822c1f822d0aeed74cc40d9 upstream.

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
 drivers/usb/typec/tcpm/tcpci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -611,7 +611,7 @@ static int tcpci_remove(struct i2c_clien
 	/* Disable chip interrupts before unregistering port */
 	err = tcpci_write16(chip->tcpci, TCPC_ALERT_MASK, 0);
 	if (err < 0)
-		return err;
+		dev_warn(&client->dev, "Failed to disable irqs (%pe)\n", ERR_PTR(err));
 
 	tcpci_unregister_port(chip->tcpci);
 


