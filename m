Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C32459A38D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354151AbiHSQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354283AbiHSQu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03AA2BB00;
        Fri, 19 Aug 2022 09:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99915B825D3;
        Fri, 19 Aug 2022 16:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9C2C433C1;
        Fri, 19 Aug 2022 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925575;
        bh=TaGVqnPMEkQffKhmRjy1brbL7Z23ysfYatVe3lgFh5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZvAO9CG2ipyjgIc1rzkE9V6MAQaXjHSm1fv7EJOH+/GCb7Mm1HEFUZlAYQxSjmrj
         s7OE9jWd1qKW6Ohc4tsaVAMH5zDXOaTBgCfhZ/UbM0ZxqfImVe50OTiGEaN1y4q02B
         ETY5cAoGmak6Hvj8kzWpSii/CB3/GGmHejKVcwoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 5.10 533/545] Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"
Date:   Fri, 19 Aug 2022 17:45:03 +0200
Message-Id: <20220819153853.435975225@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5f8954e099b8ae96e7de1bb95950e00c85bedd40 upstream.

This reverts commit a52ed4866d2b90dd5e4ae9dabd453f3ed8fa3cbc as it
causes build problems in linux-next.  It needs to be reintroduced in a
way that can allow the api to evolve and not require a "flag day" to
catch all users.

Link: https://lore.kernel.org/r/20220623160723.7a44b573@canb.auug.org.au
Cc: Duoming Zhou <duoming@zju.edu.cn>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c      |    9 ++++-----
 drivers/net/wireless/marvell/mwifiex/main.h      |    3 +--
 drivers/net/wireless/marvell/mwifiex/sta_event.c |    6 +++---
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -63,10 +63,9 @@ static void wakeup_timer_fn(struct timer
 		adapter->if_ops.card_reset(adapter);
 }
 
-static void fw_dump_work(struct work_struct *work)
+static void fw_dump_timer_fn(struct timer_list *t)
 {
-	struct mwifiex_adapter *adapter =
-		container_of(work, struct mwifiex_adapter, devdump_work.work);
+	struct mwifiex_adapter *adapter = from_timer(adapter, t, devdump_timer);
 
 	mwifiex_upload_device_dump(adapter);
 }
@@ -322,7 +321,7 @@ static void mwifiex_init_adapter(struct
 	adapter->active_scan_triggered = false;
 	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
 	adapter->devdump_len = 0;
-	INIT_DELAYED_WORK(&adapter->devdump_work, fw_dump_work);
+	timer_setup(&adapter->devdump_timer, fw_dump_timer_fn, 0);
 }
 
 /*
@@ -401,7 +400,7 @@ static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	del_timer(&adapter->wakeup_timer);
-	cancel_delayed_work_sync(&adapter->devdump_work);
+	del_timer_sync(&adapter->devdump_timer);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -49,7 +49,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/of_irq.h>
-#include <linux/workqueue.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -1054,7 +1053,7 @@ struct mwifiex_adapter {
 	/* Device dump data/length */
 	void *devdump_data;
 	int devdump_len;
-	struct delayed_work devdump_work;
+	struct timer_list devdump_timer;
 
 	bool ignore_btcoex_events;
 };
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -622,8 +622,8 @@ mwifiex_fw_dump_info_event(struct mwifie
 		 * transmission event get lost, in this cornel case,
 		 * user would still get partial of the dump.
 		 */
-		schedule_delayed_work(&adapter->devdump_work,
-				      msecs_to_jiffies(MWIFIEX_TIMER_10S));
+		mod_timer(&adapter->devdump_timer,
+			  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
 	}
 
 	/* Overflow check */
@@ -642,7 +642,7 @@ mwifiex_fw_dump_info_event(struct mwifie
 	return;
 
 upload_dump:
-	cancel_delayed_work_sync(&adapter->devdump_work);
+	del_timer_sync(&adapter->devdump_timer);
 	mwifiex_upload_device_dump(adapter);
 }
 


