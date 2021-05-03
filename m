Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA250371957
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhECQgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhECQgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A67611CB;
        Mon,  3 May 2021 16:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059717;
        bh=gdFLCCOAI1gxnFlxay9AiPC4qFLH70l2OOQvbtAUULY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0mlu5iGYlh+SEQIP9SNbyAavsjrk6XShzmeimsOdzXHkPzOrZWi1OKwCs0aB5mH/
         A4aLokaaw2mnxr6veQTlxbpWwaMJwKqX7oyixUehHOFj53UyibzTBkWp5pTg1KeAcT
         L9RzkyEBa1AMoXB+qK8n+VHZLffQCw/rTE7xDeMYPeXdG8bH+gUCwJYO2vk+3GZgY3
         xvhUa5iyY2YgCyWChQcPLCl9FxSciDm5oL19cGBb7yLyySpVGgPkNiwhg6HNdOEZ01
         VvHa3F2YsD6bPqsL9KZgYz2R8DCXssqkOLnlPigo6m0G1eCrqsO9BL2G03/gOQ/LJS
         u4pIdfsOfDY5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 002/134] drm/qxl: do not run release if qxl failed to init
Date:   Mon,  3 May 2021 12:33:01 -0400
Message-Id: <20210503163513.2851510-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit b91907a6241193465ca92e357adf16822242296d ]

if qxl_device_init() fail, drm device will not be registered,
in this case, do not run qxl_drm_release()

[    5.258534] ==================================================================
[    5.258931] BUG: KASAN: user-memory-access in qxl_destroy_monitors_object+0x42/0xa0 [qxl]
[    5.259388] Write of size 8 at addr 00000000000014dc by task modprobe/95
[    5.259754]
[    5.259842] CPU: 0 PID: 95 Comm: modprobe Not tainted 5.11.0-rc6-00007-g88bb507a74ea #62
[    5.260309] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda54
[    5.260917] Call Trace:
[    5.261056]  dump_stack+0x7d/0xa3
[    5.261245]  kasan_report.cold+0x10c/0x10e
[    5.261475]  ? qxl_destroy_monitors_object+0x42/0xa0 [qxl]
[    5.261789]  check_memory_region+0x17c/0x1e0
[    5.262029]  qxl_destroy_monitors_object+0x42/0xa0 [qxl]
[    5.262332]  qxl_modeset_fini+0x9/0x20 [qxl]
[    5.262595]  qxl_drm_release+0x22/0x30 [qxl]
[    5.262841]  drm_dev_release+0x32/0x50
[    5.263047]  release_nodes+0x39e/0x410
[    5.263253]  ? devres_release+0x40/0x40
[    5.263462]  really_probe+0x2ea/0x420
[    5.263664]  driver_probe_device+0x6d/0xd0
[    5.263888]  device_driver_attach+0x82/0x90
[    5.264116]  ? device_driver_attach+0x90/0x90
[    5.264353]  __driver_attach+0x60/0x100
[    5.264563]  ? device_driver_attach+0x90/0x90
[    5.264801]  bus_for_each_dev+0xe1/0x140
[    5.265014]  ? subsys_dev_iter_exit+0x10/0x10
[    5.265251]  ? klist_node_init+0x61/0x80
[    5.265464]  bus_add_driver+0x254/0x2a0
[    5.265673]  driver_register+0xd3/0x150
[    5.265882]  ? 0xffffffffc0048000
[    5.266064]  do_one_initcall+0x84/0x250
[    5.266274]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    5.266596]  ? unpoison_range+0xf/0x30
[    5.266801]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    5.267082]  ? unpoison_range+0xf/0x30
[    5.267287]  ? unpoison_range+0xf/0x30
[    5.267491]  do_init_module+0xf8/0x350
[    5.267697]  load_module+0x3fe6/0x4340
[    5.267902]  ? vm_unmap_ram+0x1d0/0x1d0
[    5.268115]  ? module_frob_arch_sections+0x20/0x20
[    5.268375]  ? __do_sys_finit_module+0x108/0x170
[    5.268624]  __do_sys_finit_module+0x108/0x170
[    5.268865]  ? __ia32_sys_init_module+0x40/0x40
[    5.269111]  ? file_open_root+0x200/0x200
[    5.269330]  ? do_sys_open+0x85/0xe0
[    5.269527]  ? filp_open+0x50/0x50
[    5.269714]  ? exit_to_user_mode_prepare+0xfc/0x130
[    5.269978]  do_syscall_64+0x33/0x40
[    5.270176]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    5.270450] RIP: 0033:0x7fa3f685bcf7
[    5.270646] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d1
[    5.271634] RSP: 002b:00007ffca83048d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    5.272037] RAX: ffffffffffffffda RBX: 0000000001e94a70 RCX: 00007fa3f685bcf7
[    5.272416] RDX: 0000000000000000 RSI: 0000000001e939e0 RDI: 0000000000000003
[    5.272794] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    5.273171] R10: 00007fa3f68bf300 R11: 0000000000000246 R12: 0000000001e939e0
[    5.273550] R13: 0000000000000000 R14: 0000000001e93bd0 R15: 0000000000000001
[    5.273928] ==================================================================

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210203040727.868921-1-ztong0001@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
index 1864467f1063..1b09bbe98055 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -144,6 +144,8 @@ static void qxl_drm_release(struct drm_device *dev)
 	 * reordering qxl_modeset_fini() + qxl_device_fini() calls is
 	 * non-trivial though.
 	 */
+	if (!dev->registered)
+		return;
 	qxl_modeset_fini(qdev);
 	qxl_device_fini(qdev);
 }
-- 
2.30.2

