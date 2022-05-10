Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDF95216DF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242384AbiEJNUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbiEJNSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:18:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C514D7DE21;
        Tue, 10 May 2022 06:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 490A2B81CE7;
        Tue, 10 May 2022 13:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB26C385C9;
        Tue, 10 May 2022 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188387;
        bh=beJbuLc5DeQE1QzkilhzXFk8FrAnqajPtypHf3GrpYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0ZIIVFXFfm1L382MjfVWcpwHH3f6OEqkhDRd8QZ4x02DSXiKx4lwl4ZkPQU9bF58
         KiiJdIH4xo7UrYWfWQX50/wPznhOHRbSX5vVVbdTe1vRm/PEyfp0Xin7BYsxUhGzQ+
         3EY7MdQS/YKw2JEyXn2ftBDIEi7xyxWvAEtH62Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Armin Wolf <W_Armin@gmx.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 56/66] hwmon: (adt7470) Fix warning on module removal
Date:   Tue, 10 May 2022 15:07:46 +0200
Message-Id: <20220510130731.408091772@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
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
@@ -33,6 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/util_macros.h>
+#include <linux/sched.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
@@ -273,11 +274,10 @@ static int adt7470_update_thread(void *p
 		adt7470_read_temperatures(client, data);
 		mutex_unlock(&data->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		schedule_timeout(msecs_to_jiffies(data->auto_update_interval));
+		schedule_timeout_interruptible(msecs_to_jiffies(data->auto_update_interval));
 	}
 
 	return 0;


