Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874386AED02
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjCGSAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCGR7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFD5ACE3D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755E9B819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2799C433AA;
        Tue,  7 Mar 2023 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211641;
        bh=t3xQDR4r0a/O2lHu8pZiswoxjt17Lh6WORp24in6MDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD9UXxqhF9S+EfJXNG7ftYAtDm4GDV6w/iV1rGNg5LelFOGDmwOvgysRpLuDyrl8o
         WYx7MXaUD+nmugLftBNDrIETiHERE0tbM5s3VVAB6VgA/cbPQkLD+UxHBNlb3gxyoE
         lHtbh+aQCJwb+2uR/Dacpevd1QL0ARFNvVa5U9so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Stahl, Michael" <mstahl@moba.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.2 0896/1001] Input: exc3000 - properly stop timer on shutdown
Date:   Tue,  7 Mar 2023 18:01:08 +0100
Message-Id: <20230307170100.864912496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 79c81d137d36f9635bbcbc3916c0cccb418a61dd upstream.

We need to stop the timer on driver unbind or probe failures, otherwise
we get UAF/Oops.

Fixes: 7e577a17f2ee ("Input: add I2C attached EETI EXC3000 multi touch driver")
Reported-by: "Stahl, Michael" <mstahl@moba.de>
Link: https://lore.kernel.org/r/Y9dK57BFqtlf8NmN@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/exc3000.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -109,6 +109,11 @@ static inline void exc3000_schedule_time
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
@@ -386,6 +391,11 @@ static int exc3000_probe(struct i2c_clie
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


