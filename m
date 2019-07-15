Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4441469191
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391417AbfGOOad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391496AbfGOOac (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:30:32 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A791B20868;
        Mon, 15 Jul 2019 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201031;
        bh=WaQJ4w1G/4/4mf18m/yOUo3K4h4XN4e8RUmCfgx4ICI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ece+GiTFMpVPxDz76H40fPILQ2WA78V3FSMtmOaJUL3XVy0kp/VxAFLf/DkgV+F7g
         8tc4/TkQ4iJpf/vMtOoftMDikxTd6Tbu/GWXi2rFVBcEipUeYbwR3qVT3p9IUlzmf/
         UMctnqwz7vou5KkbZ13o0OYO0ECvqd1MxlrcPxgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 031/105] media: wl128x: Fix some error handling in fm_v4l2_init_video_device()
Date:   Mon, 15 Jul 2019 10:27:25 -0400
Message-Id: <20190715142839.9896-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 69fbb3f47327d959830c94bf31893972b8c8f700 ]

X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
The fm_v4l2_init_video_device() forget to unregister v4l2/video device
in the error path, it could lead to UAF issue, eg,

  BUG: KASAN: use-after-free in atomic64_read include/asm-generic/atomic-instrumented.h:836 [inline]
  BUG: KASAN: use-after-free in atomic_long_read include/asm-generic/atomic-long.h:28 [inline]
  BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x92/0x690 kernel/locking/mutex.c:1206
  Read of size 8 at addr ffff8881e84a7c70 by task v4l_id/3659

  CPU: 1 PID: 3659 Comm: v4l_id Not tainted 5.1.0 #8
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0xa9/0x10e lib/dump_stack.c:113
   print_address_description+0x65/0x270 mm/kasan/report.c:187
   kasan_report+0x149/0x18d mm/kasan/report.c:317
   atomic64_read include/asm-generic/atomic-instrumented.h:836 [inline]
   atomic_long_read include/asm-generic/atomic-long.h:28 [inline]
   __mutex_unlock_slowpath+0x92/0x690 kernel/locking/mutex.c:1206
   fm_v4l2_fops_open+0xac/0x120 [fm_drv]
   v4l2_open+0x191/0x390 [videodev]
   chrdev_open+0x20d/0x570 fs/char_dev.c:417
   do_dentry_open+0x700/0xf30 fs/open.c:777
   do_last fs/namei.c:3416 [inline]
   path_openat+0x7c4/0x2a90 fs/namei.c:3532
   do_filp_open+0x1a5/0x2b0 fs/namei.c:3563
   do_sys_open+0x302/0x490 fs/open.c:1069
   do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f8180c17c8e
  ...
  Allocated by task 3642:
   set_track mm/kasan/common.c:87 [inline]
   __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:497
   fm_drv_init+0x13/0x1000 [fm_drv]
   do_one_initcall+0xbc/0x47d init/main.c:901
   do_init_module+0x1b5/0x547 kernel/module.c:3456
   load_module+0x6405/0x8c10 kernel/module.c:3804
   __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
   do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

  Freed by task 3642:
   set_track mm/kasan/common.c:87 [inline]
   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
   slab_free_hook mm/slub.c:1429 [inline]
   slab_free_freelist_hook mm/slub.c:1456 [inline]
   slab_free mm/slub.c:3003 [inline]
   kfree+0xe1/0x270 mm/slub.c:3958
   fm_drv_init+0x1e6/0x1000 [fm_drv]
   do_one_initcall+0xbc/0x47d init/main.c:901
   do_init_module+0x1b5/0x547 kernel/module.c:3456
   load_module+0x6405/0x8c10 kernel/module.c:3804
   __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
   do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Add relevant unregister functions to fix it.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index fc5a7abc83d2..77778c86e04d 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -549,6 +549,7 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 
 	/* Register with V4L2 subsystem as RADIO device */
 	if (video_register_device(&gradio_dev, VFL_TYPE_RADIO, radio_nr)) {
+		v4l2_device_unregister(&fmdev->v4l2_dev);
 		fmerr("Could not register video device\n");
 		return -ENOMEM;
 	}
@@ -562,6 +563,8 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	if (ret < 0) {
 		fmerr("(fmdev): Can't init ctrl handler\n");
 		v4l2_ctrl_handler_free(&fmdev->ctrl_handler);
+		video_unregister_device(fmdev->radio_dev);
+		v4l2_device_unregister(&fmdev->v4l2_dev);
 		return -EBUSY;
 	}
 
-- 
2.20.1

