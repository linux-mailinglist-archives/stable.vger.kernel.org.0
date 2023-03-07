Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC26ADB48
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 11:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCGKCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 05:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCGKC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 05:02:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38F650704
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 02:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CC7EB816AF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A7BC433D2;
        Tue,  7 Mar 2023 10:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678183346;
        bh=fijXMvy6yN0IyRD3hVCist1n+98Zi0D0bJvlix7Vl6M=;
        h=Subject:To:Cc:From:Date:From;
        b=HsVz2ZwtoRUVxWmZw+aiZTHqh+d97pfXRgT61OR2gbhSHYj6M0O6KHjKGxKaKBGQU
         whX/QUsm8HlfS5k5w7YNnaIHcOZUaEzNtYJ8FP6YLRgah8Y33q+0Rf69MRK+jmTM81
         FL3MRPWamyZyyl+Q3rMw2nEt8fXpLYOMVFewD778=
Subject: FAILED: patch "[PATCH] Input: exc3000 - properly stop timer on shutdown" failed to apply to 5.10-stable tree
To:     dmitry.torokhov@gmail.com, mstahl@moba.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 11:01:12 +0100
Message-ID: <16781832721421@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 79c81d137d36f9635bbcbc3916c0cccb418a61dd
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781832721421@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

79c81d137d36 ("Input: exc3000 - properly stop timer on shutdown")
a63d0120a2dd ("Input: exc3000 - split MT event handling from IRQ handler")

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

