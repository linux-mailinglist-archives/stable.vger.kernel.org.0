Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88DA6ADA75
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCGJf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCGJf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:35:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69EC311C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79C67B8117D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E19C433D2;
        Tue,  7 Mar 2023 09:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678181724;
        bh=Eer101FRZNxrWuVZyO4fItdoWH8FONjvH8D9uqvS1aQ=;
        h=Subject:To:Cc:From:Date:From;
        b=2wfXaU+tNS4FXoONLJKARqBGudHRC3c9mBf9MnrloP3n3AJBaTPewN4OM/gXmBOTR
         J5UdEframUH1RHLtCBw1GEQ3Ms+OTf7Dx+4rSoyvrB7GL0Ck4BqhHX8UqZUK+WqFsv
         8yK9bniefHIahlQdovrMGo/52wOR0nwmqWCCCQIA=
Subject: FAILED: patch "[PATCH] Input: exc3000 - properly stop timer on shutdown" failed to apply to 5.4-stable tree
To:     dmitry.torokhov@gmail.com, mstahl@moba.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:35:13 +0100
Message-ID: <1678181713148144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 79c81d137d36f9635bbcbc3916c0cccb418a61dd
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678181713148144@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

79c81d137d36 ("Input: exc3000 - properly stop timer on shutdown")
a63d0120a2dd ("Input: exc3000 - split MT event handling from IRQ handler")
d862a3068ea5 ("Input: exc3000 - add support to query model and fw_version")
3bdd21c6937a ("Input: exc3000 - add EXC80H60 and EXC80H84 support")
1053653ffadb ("dt-bindings: touchscreen: Convert EETI EXC3000 touchscreen to json-schema")
deae576455bb ("Input: exc3000 - switch to i2c's probe_new API")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 79c81d137d36f9635bbcbc3916c0cccb418a61dd Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 3 Feb 2023 16:43:29 -0800
Subject: [PATCH] Input: exc3000 - properly stop timer on shutdown

We need to stop the timer on driver unbind or probe failures, otherwise
we get UAF/Oops.

Fixes: 7e577a17f2ee ("Input: add I2C attached EETI EXC3000 multi touch driver")
Reported-by: "Stahl, Michael" <mstahl@moba.de>
Link: https://lore.kernel.org/r/Y9dK57BFqtlf8NmN@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

diff --git a/drivers/input/touchscreen/exc3000.c b/drivers/input/touchscreen/exc3000.c
index 4b7eee01c6aa..69eae79e2087 100644
--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -109,6 +109,11 @@ static inline void exc3000_schedule_timer(struct exc3000_data *data)
 	mod_timer(&data->timer, jiffies + msecs_to_jiffies(EXC3000_TIMEOUT_MS));
 }
 
+static void exc3000_shutdown_timer(void *timer)
+{
+	timer_shutdown_sync(timer);
+}
+
 static int exc3000_read_frame(struct exc3000_data *data, u8 *buf)
 {
 	struct i2c_client *client = data->client;
@@ -386,6 +391,11 @@ static int exc3000_probe(struct i2c_client *client)
 	if (error)
 		return error;
 
+	error = devm_add_action_or_reset(&client->dev, exc3000_shutdown_timer,
+					 &data->timer);
+	if (error)
+		return error;
+
 	error = devm_request_threaded_irq(&client->dev, client->irq,
 					  NULL, exc3000_interrupt, IRQF_ONESHOT,
 					  client->name, data);

