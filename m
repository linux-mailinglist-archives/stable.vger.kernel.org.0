Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE5431E34
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhJRN7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhJRN5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D42961354;
        Mon, 18 Oct 2021 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564446;
        bh=MsdUmbpXvV4lcIRozA/dovk6qBH59yfUaSmkIk4/WsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8ZKHFKXibUHaJC0LDyVtT0BmsC5XtW7zYos5pE0sOgRI9eqIHw719s69gX5oSnCw
         YkDZmXn/QAjcFtwj5bqf+i6kNpvZmeb4+ROGioTFJEJH0my34gW8E3DJS/zt4muFku
         BQHBIbinBYUWH3MYdIN+AQPyhdG7v1/hxbcP/2BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.14 092/151] firmware: arm_ffa: Fix __ffa_devices_unregister
Date:   Mon, 18 Oct 2021 15:24:31 +0200
Message-Id: <20211018132343.676268357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit eb7b52e6db7c21400b9b2d539f9343fb6e94bd94 upstream.

When arm_ffa firmware driver module is unloaded or removed we call
__ffa_devices_unregister on all the devices on the ffa bus. It must
unregister all the devices instead it is currently just releasing the
devices without unregistering. That is pure wrong as when we try to
load the module back again, it will result in the kernel crash something
like below.

-->8
 CPU: 2 PID: 232 Comm: modprobe Not tainted 5.15.0-rc2+ #169
 Hardware name: FVP Base RevC (DT)
 Call trace:
  dump_backtrace+0x0/0x1cc
  show_stack+0x18/0x64
  dump_stack_lvl+0x64/0x7c
  dump_stack+0x18/0x38
  sysfs_create_dir_ns+0xe4/0x140
  kobject_add_internal+0x170/0x358
  kobject_add+0x94/0x100
  device_add+0x178/0x5f0
  device_register+0x20/0x30
  ffa_device_register+0x80/0xcc [ffa_module]
  ffa_setup_partitions+0x7c/0x108 [ffa_module]
  init_module+0x290/0x2dc [ffa_module]
  do_one_initcall+0xbc/0x230
  do_init_module+0x58/0x304
  load_module+0x15e0/0x1f68
  __arm64_sys_finit_module+0xb8/0xf4
  invoke_syscall+0x44/0x140
  el0_svc_common+0xb4/0xf0
  do_el0_svc+0x24/0x80
  el0_svc+0x20/0x50
  el0t_64_sync_handler+0x84/0xe4
  el0t_64_sync+0x1a0/0x1a4
 kobject_add_internal failed for arm-ffa-8001 with -EEXIST, don't try to
 register things with the same name in the same directory.
----

Fix the issue by calling device_unregister in __ffa_devices_unregister
which will also take care of calling device_release(which is mapped to
ffa_release_device)

Link: https://lore.kernel.org/r/20210924092859.3057562-2-sudeep.holla@arm.com
Fixes: e781858488b9 ("firmware: arm_ffa: Add initial FFA bus support for device enumeration")
Tested-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_ffa/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -127,7 +127,7 @@ static void ffa_release_device(struct de
 
 static int __ffa_devices_unregister(struct device *dev, void *data)
 {
-	ffa_release_device(dev);
+	device_unregister(dev);
 
 	return 0;
 }


