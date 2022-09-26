Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70985EA2C5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbiIZLOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237424AbiIZLM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB96113A;
        Mon, 26 Sep 2022 03:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D168860CF4;
        Mon, 26 Sep 2022 10:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6451C433D6;
        Mon, 26 Sep 2022 10:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188556;
        bh=OvADhlqeYCa4Yp7HsgEaJrJh+PUgpnHrXjRte/55TKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bqk+QyeaEriAqymsWAlITYFYE7BUEHfLm3QdgEkqhqiXHKbfzFk+OsOm86s2cvbt
         JPWA2vCDk20VFV6NrToYEgRuvfBUvhbZP0tXwSgxIGVNM/2l5tD6ox6jKyEiv7tyi7
         DX4IeyTfyggLHpaw2ragDaush4YEqUSC7LbUphZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 045/148] gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully
Date:   Mon, 26 Sep 2022 12:11:19 +0200
Message-Id: <20220926100757.706880800@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit 69bef19d6b9700e96285f4b4e28691cda3dcd0d1 upstream.

When running gpio test on nxp-ls1028 platform with below command
gpiomon --num-events=3 --rising-edge gpiochip1 25
There will be a warning trace as below:
Call trace:
free_irq+0x204/0x360
lineevent_free+0x64/0x70
gpio_ioctl+0x598/0x6a0
__arm64_sys_ioctl+0xb4/0x100
invoke_syscall+0x5c/0x130
......
el0t_64_sync+0x1a0/0x1a4
The reason of this issue is that calling request_threaded_irq()
function failed, and then lineevent_free() is invoked to release
the resource. Since the lineevent_state::irq was already set, so
the subsequent invocation of free_irq() would trigger the above
warning call trace. To fix this issue, set the lineevent_state::irq
after the IRQ register successfully.

Fixes: 468242724143 ("gpiolib: cdev: refactor lineevent cleanup into lineevent_free")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1784,7 +1784,6 @@ static int lineevent_create(struct gpio_
 		ret = -ENODEV;
 		goto out_free_le;
 	}
-	le->irq = irq;
 
 	if (eflags & GPIOEVENT_REQUEST_RISING_EDGE)
 		irqflags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
@@ -1798,7 +1797,7 @@ static int lineevent_create(struct gpio_
 	init_waitqueue_head(&le->wait);
 
 	/* Request a thread to read the events */
-	ret = request_threaded_irq(le->irq,
+	ret = request_threaded_irq(irq,
 				   lineevent_irq_handler,
 				   lineevent_irq_thread,
 				   irqflags,
@@ -1807,6 +1806,8 @@ static int lineevent_create(struct gpio_
 	if (ret)
 		goto out_free_le;
 
+	le->irq = irq;
+
 	fd = get_unused_fd_flags(O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		ret = fd;


