Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F8559E0A1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349876AbiHWLL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357086AbiHWLIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16F870BA;
        Tue, 23 Aug 2022 02:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE11760DB4;
        Tue, 23 Aug 2022 09:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7654C433D7;
        Tue, 23 Aug 2022 09:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246182;
        bh=h4SRFRwWDGFpd+Pvz9NJz6+4oQ+lzHmWydHpMm9CVU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjEMau6YXCzaC6IeS0KQ8s8iRvALqIes9egXoFbcHyNE1cjcK6XYqB+YDNaElNsJv
         wLkXqgvE5gguSgptmmywaBUP82xk89BuRYg4XuRPLhqESCLakwPOnSbggkJtX5ua5W
         XkrAacDUoDtLniDwdGqoLsVaEM56aqBAXJgjm1dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Lukas Wunner <lukas@wunner.de>,
        Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 027/389] usbnet: Fix linkwatch use-after-free on disconnect
Date:   Tue, 23 Aug 2022 10:21:45 +0200
Message-Id: <20220823080116.827872846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit a69e617e533edddf3fa3123149900f36e0a6dc74 upstream.

usbnet uses the work usbnet_deferred_kevent() to perform tasks which may
sleep.  On disconnect, completion of the work was originally awaited in
->ndo_stop().  But in 2003, that was moved to ->disconnect() by historic
commit "[PATCH] USB: usbnet, prevent exotic rtnl deadlock":

  https://git.kernel.org/tglx/history/c/0f138bbfd83c

The change was made because back then, the kernel's workqueue
implementation did not allow waiting for a single work.  One had to wait
for completion of *all* work by calling flush_scheduled_work(), and that
could deadlock when waiting for usbnet_deferred_kevent() with rtnl_mutex
held in ->ndo_stop().

The commit solved one problem but created another:  It causes a
use-after-free in USB Ethernet drivers aqc111.c, asix_devices.c,
ax88179_178a.c, ch9200.c and smsc75xx.c:

* If the drivers receive a link change interrupt immediately before
  disconnect, they raise EVENT_LINK_RESET in their (non-sleepable)
  ->status() callback and schedule usbnet_deferred_kevent().
* usbnet_deferred_kevent() invokes the driver's ->link_reset() callback,
  which calls netif_carrier_{on,off}().
* That in turn schedules the work linkwatch_event().

Because usbnet_deferred_kevent() is awaited after unregister_netdev(),
netif_carrier_{on,off}() may operate on an unregistered netdev and
linkwatch_event() may run after free_netdev(), causing a use-after-free.

In 2010, usbnet was changed to only wait for a single instance of
usbnet_deferred_kevent() instead of *all* work by commit 23f333a2bfaf
("drivers/net: don't use flush_scheduled_work()").

Unfortunately the commit neglected to move the wait back to
->ndo_stop().  Rectify that omission at long last.

Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -833,13 +833,11 @@ int usbnet_stop (struct net_device *net)
 
 	mpn = !test_and_clear_bit(EVENT_NO_RUNTIME_PM, &dev->flags);
 
-	/* deferred work (task, timer, softirq) must also stop.
-	 * can't flush_scheduled_work() until we drop rtnl (later),
-	 * else workers could deadlock; so make workers a NOP.
-	 */
+	/* deferred work (timer, softirq, task) must also stop */
 	dev->flags = 0;
 	del_timer_sync (&dev->delay);
 	tasklet_kill (&dev->bh);
+	cancel_work_sync(&dev->kevent);
 	if (!pm)
 		usb_autopm_put_interface(dev->intf);
 
@@ -1603,8 +1601,6 @@ void usbnet_disconnect (struct usb_inter
 	net = dev->net;
 	unregister_netdev (net);
 
-	cancel_work_sync(&dev->kevent);
-
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
 	if (dev->driver_info->unbind)


