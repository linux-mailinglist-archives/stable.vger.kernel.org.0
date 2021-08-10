Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362DF3E8029
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhHJRqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236397AbhHJRoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4EF661008;
        Tue, 10 Aug 2021 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617187;
        bh=6eQgz5dJJKVdVPTuODOG1hu/8yEzdt/COgQH3FX4fBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQ7IU9AyxyU8yZ67qFCZb9KUTuz4hi/5pJgrUxlIiYd1AYjTocIr8mQXl8dRTgsmL
         rFkaIqgKhhYE6Oyr705js9PDvZvxRCH6W6Z/T0oJeMTMMSWGYD6UIT6gwpOZXauMgF
         tedsgrEFo28rQ6dblNYpnSR1Bzz1X+rZ7E0Qf45o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.10 084/135] optee: Refuse to load the driver under the kdump kernel
Date:   Tue, 10 Aug 2021 19:30:18 +0200
Message-Id: <20210810172958.600590876@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit adf752af454e91e123e85e3784972d166837af73 upstream.

Fix a hung task issue, seen when booting the kdump kernel, that is
caused by all of the secure world threads being in a permanent suspended
state:

 INFO: task swapper/0:1 blocked for more than 120 seconds.
       Not tainted 5.4.83 #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 swapper/0       D    0     1      0 0x00000028
 Call trace:
  __switch_to+0xc8/0x118
  __schedule+0x2e0/0x700
  schedule+0x38/0xb8
  schedule_timeout+0x258/0x388
  wait_for_completion+0x16c/0x4b8
  optee_cq_wait_for_completion+0x28/0xa8
  optee_disable_shm_cache+0xb8/0xf8
  optee_probe+0x560/0x61c
  platform_drv_probe+0x58/0xa8
  really_probe+0xe0/0x338
  driver_probe_device+0x5c/0xf0
  device_driver_attach+0x74/0x80
  __driver_attach+0x64/0xe0
  bus_for_each_dev+0x84/0xd8
  driver_attach+0x30/0x40
  bus_add_driver+0x188/0x1e8
  driver_register+0x64/0x110
  __platform_driver_register+0x54/0x60
  optee_driver_init+0x20/0x28
  do_one_initcall+0x54/0x24c
  kernel_init_freeable+0x1e8/0x2c0
  kernel_init+0x18/0x118
  ret_from_fork+0x10/0x18

The invoke_fn hook returned OPTEE_SMC_RETURN_ETHREAD_LIMIT, indicating
that the secure world threads were all in a suspended state at the time
of the kernel crash. This intermittently prevented the kdump kernel from
booting, resulting in a failure to collect the kernel dump.

Make kernel dump collection more reliable on systems utilizing OP-TEE by
refusing to load the driver under the kdump kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/arm-smccc.h>
+#include <linux/crash_dump.h>
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -612,6 +613,16 @@ static int optee_probe(struct platform_d
 	u32 sec_caps;
 	int rc;
 
+	/*
+	 * The kernel may have crashed at the same time that all available
+	 * secure world threads were suspended and we cannot reschedule the
+	 * suspended threads without access to the crashed kernel's wait_queue.
+	 * Therefore, we cannot reliably initialize the OP-TEE driver in the
+	 * kdump kernel.
+	 */
+	if (is_kdump_kernel())
+		return -ENODEV;
+
 	invoke_fn = get_invoke_func(&pdev->dev);
 	if (IS_ERR(invoke_fn))
 		return PTR_ERR(invoke_fn);


