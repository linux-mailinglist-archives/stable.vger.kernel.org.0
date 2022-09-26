Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A05EA3FC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiIZLhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiIZLhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:37:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998A81C11B;
        Mon, 26 Sep 2022 03:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C07E6B80972;
        Mon, 26 Sep 2022 10:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFF8C433D6;
        Mon, 26 Sep 2022 10:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189038;
        bh=d2gwwyn7sUx/cFG3rWOZQeZ+/sihKRv0+wPHQx4XLZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXsjB/t8i7opbs2kAYSCMQmokifqYCptC4QpVohWH4zFmZg0g2aatGYi2Zfk0zPVm
         r4RbJ4BmFI3ecT+xRzu/YfBkWQU1FZEw9oPUTd+/LlFiZFmbR7jdlfzq3SMxSP42aj
         JY5qWpOXpee9AKIRHoL4ddCFq5LThdwKZjCSpAUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.19 053/207] gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully
Date:   Mon, 26 Sep 2022 12:10:42 +0200
Message-Id: <20220926100808.996403154@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -1975,7 +1975,6 @@ static int lineevent_create(struct gpio_
 		ret = -ENODEV;
 		goto out_free_le;
 	}
-	le->irq = irq;
 
 	if (eflags & GPIOEVENT_REQUEST_RISING_EDGE)
 		irqflags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
@@ -1989,7 +1988,7 @@ static int lineevent_create(struct gpio_
 	init_waitqueue_head(&le->wait);
 
 	/* Request a thread to read the events */
-	ret = request_threaded_irq(le->irq,
+	ret = request_threaded_irq(irq,
 				   lineevent_irq_handler,
 				   lineevent_irq_thread,
 				   irqflags,
@@ -1998,6 +1997,8 @@ static int lineevent_create(struct gpio_
 	if (ret)
 		goto out_free_le;
 
+	le->irq = irq;
+
 	fd = get_unused_fd_flags(O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		ret = fd;


