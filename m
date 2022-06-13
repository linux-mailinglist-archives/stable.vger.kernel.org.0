Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4BE54875D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383849AbiFMO1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383719AbiFMOXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853EF2E6BD;
        Mon, 13 Jun 2022 04:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 223C9612AC;
        Mon, 13 Jun 2022 11:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3DCC34114;
        Mon, 13 Jun 2022 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120703;
        bh=IwDaFil21y+RmqPmcFfu8yD/yJO63gJXtYpW6HqIQbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJw1HkuNsphHgcAptC6mbbUQfWJR/HEmwSGldL5/0RS/C/4+49RR4H4B8GhQtwLnT
         3jW5lOyrDBzf9QI1UXzIj0X/LCO6P4QwlhYob0e95uUEsHWf5+uPvWJifVhaeNuqVB
         vdC1VElNt5dlsGOJAnSjLW5O6HQbX1AuDKx0W/bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <jstultz@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-pm@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 127/298] driver core: Fix wait_for_device_probe() & deferred_probe_timeout interaction
Date:   Mon, 13 Jun 2022 12:10:21 +0200
Message-Id: <20220613094928.793712131@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 5ee76c256e928455212ab759c51d198fedbe7523 ]

Mounting NFS rootfs was timing out when deferred_probe_timeout was
non-zero [1].  This was because ip_auto_config() initcall times out
waiting for the network interfaces to show up when
deferred_probe_timeout was non-zero. While ip_auto_config() calls
wait_for_device_probe() to make sure any currently running deferred
probe work or asynchronous probe finishes, that wasn't sufficient to
account for devices being deferred until deferred_probe_timeout.

Commit 35a672363ab3 ("driver core: Ensure wait_for_device_probe() waits
until the deferred_probe_timeout fires") tried to fix that by making
sure wait_for_device_probe() waits for deferred_probe_timeout to expire
before returning.

However, if wait_for_device_probe() is called from the kernel_init()
context:

- Before deferred_probe_initcall() [2], it causes the boot process to
  hang due to a deadlock.

- After deferred_probe_initcall() [3], it blocks kernel_init() from
  continuing till deferred_probe_timeout expires and beats the point of
  deferred_probe_timeout that's trying to wait for userspace to load
  modules.

Neither of this is good. So revert the changes to
wait_for_device_probe().

[1] - https://lore.kernel.org/lkml/TYAPR01MB45443DF63B9EF29054F7C41FD8C60@TYAPR01MB4544.jpnprd01.prod.outlook.com/
[2] - https://lore.kernel.org/lkml/YowHNo4sBjr9ijZr@dev-arch.thelio-3990X/
[3] - https://lore.kernel.org/lkml/Yo3WvGnNk3LvLb7R@linutronix.de/

Fixes: 35a672363ab3 ("driver core: Ensure wait_for_device_probe() waits until the deferred_probe_timeout fires")
Cc: John Stultz <jstultz@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Basil Eljuse <Basil.Eljuse@arm.com>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: linux-pm@vger.kernel.org
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20220526034609.480766-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 977e94cf669e..86fd2ea35656 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -257,7 +257,6 @@ DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
 int driver_deferred_probe_timeout;
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
-static DECLARE_WAIT_QUEUE_HEAD(probe_timeout_waitqueue);
 
 static int __init deferred_probe_timeout_setup(char *str)
 {
@@ -312,7 +311,6 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(p->device, "deferred probe pending\n");
 	mutex_unlock(&deferred_probe_mutex);
-	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -720,9 +718,6 @@ int driver_probe_done(void)
  */
 void wait_for_device_probe(void)
 {
-	/* wait for probe timeout */
-	wait_event(probe_timeout_waitqueue, !driver_deferred_probe_timeout);
-
 	/* wait for the deferred probe workqueue to finish */
 	flush_work(&deferred_probe_work);
 
-- 
2.35.1



