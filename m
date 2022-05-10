Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119E15218B1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbiEJNjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244715AbiEJNh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F15353E38;
        Tue, 10 May 2022 06:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4E75B81DA0;
        Tue, 10 May 2022 13:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02B9C385C2;
        Tue, 10 May 2022 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189169;
        bh=fEpcMmrKFpB8UztQOH0NvMjh+LJsGZOvJM5WGQPdAbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP83Ba5yyWj5jqfXfAkKkItQ8rcHUxYUAO0sFTROUsQQIXvreUd4D7e044Ae82il3
         ZjOVF2L25XSxKiO+jydvNidYNuLQMc44UBNg2kvd+ogMSrF3Ur17JqgFwtO/azlXdX
         G+z0kF15zv/bqWR9upTiZoIkxBLM7XELWViUj/vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Armin Wolf <W_Armin@gmx.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 35/70] hwmon: (adt7470) Fix warning on module removal
Date:   Tue, 10 May 2022 15:07:54 +0200
Message-Id: <20220510130733.895483141@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

commit 7b2666ce445c700b8dcee994da44ddcf050a0842 upstream.

When removing the adt7470 module, a warning might be printed:

do not call blocking ops when !TASK_RUNNING; state=1
set at [<ffffffffa006052b>] adt7470_update_thread+0x7b/0x130 [adt7470]

This happens because adt7470_update_thread() can leave the kthread in
TASK_INTERRUPTIBLE state when the kthread is being stopped before
the call of set_current_state(). Since kthread_exit() might sleep in
exit_signals(), the warning is printed.
Fix that by using schedule_timeout_interruptible() and removing
the call of set_current_state().
This causes TASK_INTERRUPTIBLE to be set after kthread_should_stop()
which might cause the kthread to exit.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Fixes: 93cacfd41f82 (hwmon: (adt7470) Allow faster removal)
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Tested-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220407101312.13331-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/adt7470.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -20,6 +20,7 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/util_macros.h>
+#include <linux/sched.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
@@ -260,11 +261,10 @@ static int adt7470_update_thread(void *p
 		adt7470_read_temperatures(client, data);
 		mutex_unlock(&data->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		schedule_timeout(msecs_to_jiffies(data->auto_update_interval));
+		schedule_timeout_interruptible(msecs_to_jiffies(data->auto_update_interval));
 	}
 
 	return 0;


