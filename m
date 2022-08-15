Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5B59515D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiHPE4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiHPE4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4024BB683;
        Mon, 15 Aug 2022 13:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4450A6128D;
        Mon, 15 Aug 2022 20:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E212C433D6;
        Mon, 15 Aug 2022 20:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596641;
        bh=UsI/1rvqLECPRbEyqNSSrEWNvQrZbquWROC02DqDgvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnGvw7R+Z/vhG3+5HoXFZhWXvgCUkBHNJ2yPfFXgCyWEZv7hOvFVvj4vUUW+TZnlS
         I5l7Oa58zd4efX3v/mO1e0Tw15GsQu2ZulCi0hM3WzXv43fBQ1ygA8nx8HblCYnfgx
         D+0hrLCYLlVjYg7lYvRnI7jdWbyN7WwMkxvEK2qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 5.19 1144/1157] Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"
Date:   Mon, 15 Aug 2022 20:08:20 +0200
Message-Id: <20220815180526.252072077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
@@ -1056,7 +1055,7 @@ struct mwifiex_adapter {
 	/* Device dump data/length */
 	void *devdump_data;
 	int devdump_len;
-	struct delayed_work devdump_work;
+	struct timer_list devdump_timer;
 
 	bool ignore_btcoex_events;
 };
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -623,8 +623,8 @@ mwifiex_fw_dump_info_event(struct mwifie
 		 * transmission event get lost, in this cornel case,
 		 * user would still get partial of the dump.
 		 */
-		schedule_delayed_work(&adapter->devdump_work,
-				      msecs_to_jiffies(MWIFIEX_TIMER_10S));
+		mod_timer(&adapter->devdump_timer,
+			  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
 	}
 
 	/* Overflow check */
@@ -643,7 +643,7 @@ mwifiex_fw_dump_info_event(struct mwifie
 	return;
 
 upload_dump:
-	cancel_delayed_work_sync(&adapter->devdump_work);
+	del_timer_sync(&adapter->devdump_timer);
 	mwifiex_upload_device_dump(adapter);
 }
 


