Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F0F521A11
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiEJNx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244870AbiEJNrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBAF1B176F;
        Tue, 10 May 2022 06:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF89E615C8;
        Tue, 10 May 2022 13:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37E4C385C9;
        Tue, 10 May 2022 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189539;
        bh=kbIMyA20MLb5r88e4+yEMtTP3fJ10IDe37wFkR1I50g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma1mAT9UIBiD/zIEHVs/9y/rb2k+p88LbsBitItvALc5koCTyYDnQ40XTF5210w9D
         JnFuqTPouDAEXrX4l2vhkDJZYXcgf5fPerEOJfFVDctM2bxGIOYySpwdvxMdrV9iVZ
         uaNmpwlyTNBnOb5NjeKo7DKuufxSCbc6kt+aY2WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Armin Wolf <W_Armin@gmx.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 042/135] hwmon: (adt7470) Fix warning on module removal
Date:   Tue, 10 May 2022 15:07:04 +0200
Message-Id: <20220510130741.607331293@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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
@@ -19,6 +19,7 @@
 #include <linux/log2.h>
 #include <linux/kthread.h>
 #include <linux/regmap.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/util_macros.h>
 
@@ -294,11 +295,10 @@ static int adt7470_update_thread(void *p
 		adt7470_read_temperatures(data);
 		mutex_unlock(&data->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		schedule_timeout(msecs_to_jiffies(data->auto_update_interval));
+		schedule_timeout_interruptible(msecs_to_jiffies(data->auto_update_interval));
 	}
 
 	return 0;


