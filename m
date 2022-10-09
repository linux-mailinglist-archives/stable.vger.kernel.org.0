Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF445F951A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiJJAP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiJJANt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A9B27FD1;
        Sun,  9 Oct 2022 16:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AED7E60C9B;
        Sun,  9 Oct 2022 23:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F1EC433D7;
        Sun,  9 Oct 2022 23:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359503;
        bh=VPX5uY0+vC4kQAyQ2AZ1elDZASWNeRriFOJsrmT6Rtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5lcu5qdv2t5APieEQn+TczUzYpPCSJj/+rAtod13PRjrpKoyoztGK4XjpH37Lg6Y
         CWwIeIeLOo6UKpjVdixlRmJBYj9CTQp6GuBSto0GBlg+zLfbXI0X8RG0sIKOc8XKjW
         xw0cnCZqC8zpEFAnTuoOEDnYNi2JJG/xYNL0G+wgoeVifTQh8S4K7kbQoy446gHRm2
         IBzSLPevXjKSd5MkB2KMF+6WvG20lMdFOGDXLNHuiuLDJwSP79t+QIzYUioxhSyL0X
         9i1a+cNy2VxLM5b8augoEE94mBYj819+im2ZmSH0toG0xPXnX2m+C3iFR9ZaLyRqDZ
         hy/2ik5eGkINw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, khilman@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 36/44] drm/meson: explicitly remove aggregate driver at module unload time
Date:   Sun,  9 Oct 2022 19:49:24 -0400
Message-Id: <20221009234932.1230196-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 8616f2a0589a80e08434212324250eb22f6a66ce ]

Because component_master_del wasn't being called when unloading the
meson_drm module, the aggregate device would linger forever in the global
aggregate_devices list. That means when unloading and reloading the
meson_dw_hdmi module, component_add would call into
try_to_bring_up_aggregate_device and find the unbound meson_drm aggregate
device.

This would in turn dereference some of the aggregate_device's struct
entries which point to memory automatically freed by the devres API when
unbinding the aggregate device from meson_drv_unbind, and trigger an
use-after-free bug:

[  +0.000014] =============================================================
[  +0.000007] BUG: KASAN: use-after-free in find_components+0x468/0x500
[  +0.000017] Read of size 8 at addr ffff000006731688 by task modprobe/2536
[  +0.000018] CPU: 4 PID: 2536 Comm: modprobe Tainted: G         C O      5.19.0-rc6-lrmbkasan+ #1
[  +0.000010] Hardware name: Hardkernel ODROID-N2Plus (DT)
[  +0.000008] Call trace:
[  +0.000005]  dump_backtrace+0x1ec/0x280
[  +0.000011]  show_stack+0x24/0x80
[  +0.000007]  dump_stack_lvl+0x98/0xd4
[  +0.000010]  print_address_description.constprop.0+0x80/0x520
[  +0.000011]  print_report+0x128/0x260
[  +0.000007]  kasan_report+0xb8/0xfc
[  +0.000007]  __asan_report_load8_noabort+0x3c/0x50
[  +0.000009]  find_components+0x468/0x500
[  +0.000008]  try_to_bring_up_aggregate_device+0x64/0x390
[  +0.000009]  __component_add+0x1dc/0x49c
[  +0.000009]  component_add+0x20/0x30
[  +0.000008]  meson_dw_hdmi_probe+0x28/0x34 [meson_dw_hdmi]
[  +0.000013]  platform_probe+0xd0/0x220
[  +0.000008]  really_probe+0x3ac/0xa80
[  +0.000008]  __driver_probe_device+0x1f8/0x400
[  +0.000008]  driver_probe_device+0x68/0x1b0
[  +0.000008]  __driver_attach+0x20c/0x480
[  +0.000009]  bus_for_each_dev+0x114/0x1b0
[  +0.000007]  driver_attach+0x48/0x64
[  +0.000009]  bus_add_driver+0x390/0x564
[  +0.000007]  driver_register+0x1a8/0x3e4
[  +0.000009]  __platform_driver_register+0x6c/0x94
[  +0.000007]  meson_dw_hdmi_platform_driver_init+0x30/0x1000 [meson_dw_hdmi]
[  +0.000014]  do_one_initcall+0xc4/0x2b0
[  +0.000008]  do_init_module+0x154/0x570
[  +0.000010]  load_module+0x1a78/0x1ea4
[  +0.000008]  __do_sys_init_module+0x184/0x1cc
[  +0.000008]  __arm64_sys_init_module+0x78/0xb0
[  +0.000008]  invoke_syscall+0x74/0x260
[  +0.000008]  el0_svc_common.constprop.0+0xcc/0x260
[  +0.000009]  do_el0_svc+0x50/0x70
[  +0.000008]  el0_svc+0x68/0x1a0
[  +0.000009]  el0t_64_sync_handler+0x11c/0x150
[  +0.000009]  el0t_64_sync+0x18c/0x190

[  +0.000014] Allocated by task 902:
[  +0.000007]  kasan_save_stack+0x2c/0x5c
[  +0.000009]  __kasan_kmalloc+0x90/0xd0
[  +0.000007]  __kmalloc_node+0x240/0x580
[  +0.000010]  memcg_alloc_slab_cgroups+0xa4/0x1ac
[  +0.000010]  memcg_slab_post_alloc_hook+0xbc/0x4c0
[  +0.000008]  kmem_cache_alloc_node+0x1d0/0x490
[  +0.000009]  __alloc_skb+0x1d4/0x310
[  +0.000010]  alloc_skb_with_frags+0x8c/0x620
[  +0.000008]  sock_alloc_send_pskb+0x5ac/0x6d0
[  +0.000010]  unix_dgram_sendmsg+0x2e0/0x12f0
[  +0.000010]  sock_sendmsg+0xcc/0x110
[  +0.000007]  sock_write_iter+0x1d0/0x304
[  +0.000008]  new_sync_write+0x364/0x460
[  +0.000007]  vfs_write+0x420/0x5ac
[  +0.000008]  ksys_write+0x19c/0x1f0
[  +0.000008]  __arm64_sys_write+0x78/0xb0
[  +0.000007]  invoke_syscall+0x74/0x260
[  +0.000008]  el0_svc_common.constprop.0+0x1a8/0x260
[  +0.000009]  do_el0_svc+0x50/0x70
[  +0.000007]  el0_svc+0x68/0x1a0
[  +0.000008]  el0t_64_sync_handler+0x11c/0x150
[  +0.000008]  el0t_64_sync+0x18c/0x190

[  +0.000013] Freed by task 2509:
[  +0.000008]  kasan_save_stack+0x2c/0x5c
[  +0.000007]  kasan_set_track+0x2c/0x40
[  +0.000008]  kasan_set_free_info+0x28/0x50
[  +0.000008]  ____kasan_slab_free+0x128/0x1d4
[  +0.000008]  __kasan_slab_free+0x18/0x24
[  +0.000007]  slab_free_freelist_hook+0x108/0x230
[  +0.000010]  kfree+0x110/0x35c
[  +0.000008]  release_nodes+0xf0/0x16c
[  +0.000008]  devres_release_all+0xfc/0x180
[  +0.000008]  device_unbind_cleanup+0x24/0x164
[  +0.000008]  device_release_driver_internal+0x3e8/0x5b0
[  +0.000010]  driver_detach+0xac/0x1b0
[  +0.000008]  bus_remove_driver+0x158/0x29c
[  +0.000008]  driver_unregister+0x70/0xb0
[  +0.000009]  platform_driver_unregister+0x20/0x2c
[  +0.000007]  0xffff800003722d98
[  +0.000012]  __do_sys_delete_module+0x288/0x400
[  +0.000009]  __arm64_sys_delete_module+0x5c/0x80
[  +0.000008]  invoke_syscall+0x74/0x260
[  +0.000008]  el0_svc_common.constprop.0+0xcc/0x260
[  +0.000008]  do_el0_svc+0x50/0x70
[  +0.000007]  el0_svc+0x68/0x1a0
[  +0.000008]  el0t_64_sync_handler+0x11c/0x150
[  +0.000009]  el0t_64_sync+0x18c/0x190

[  +0.000013] Last potentially related work creation:
[  +0.000007]  kasan_save_stack+0x2c/0x5c
[  +0.000007]  __kasan_record_aux_stack+0xb8/0xf0
[  +0.000009]  kasan_record_aux_stack_noalloc+0x14/0x20
[  +0.000008]  insert_work+0x54/0x290
[  +0.000009]  __queue_work+0x48c/0xd24
[  +0.000008]  queue_work_on+0x90/0x11c
[  +0.000008]  call_usermodehelper_exec+0x188/0x404
[  +0.000010]  kobject_uevent_env+0x5a8/0x794
[  +0.000010]  kobject_uevent+0x14/0x20
[  +0.000008]  driver_register+0x230/0x3e4
[  +0.000009]  __platform_driver_register+0x6c/0x94
[  +0.000007]  gxbb_driver_init+0x28/0x34
[  +0.000010]  do_one_initcall+0xc4/0x2b0
[  +0.000008]  do_initcalls+0x20c/0x24c
[  +0.000010]  kernel_init_freeable+0x22c/0x278
[  +0.000009]  kernel_init+0x3c/0x170
[  +0.000008]  ret_from_fork+0x10/0x20

[  +0.000013] The buggy address belongs to the object at ffff000006731600
               which belongs to the cache kmalloc-256 of size 256
[  +0.000009] The buggy address is located 136 bytes inside of
               256-byte region [ffff000006731600, ffff000006731700)

[  +0.000015] The buggy address belongs to the physical page:
[  +0.000008] page:fffffc000019cc00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff000006730a00 pfn:0x6730
[  +0.000011] head:fffffc000019cc00 order:2 compound_mapcount:0 compound_pincount:0
[  +0.000008] flags: 0xffff00000010200(slab|head|node=0|zone=0|lastcpupid=0xffff)
[  +0.000016] raw: 0ffff00000010200 fffffc00000c3d08 fffffc0000ef2b08 ffff000000002680
[  +0.000009] raw: ffff000006730a00 0000000000150014 00000001ffffffff 0000000000000000
[  +0.000006] page dumped because: kasan: bad access detected

[  +0.000011] Memory state around the buggy address:
[  +0.000007]  ffff000006731580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  +0.000007]  ffff000006731600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007] >ffff000006731680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007]                       ^
[  +0.000006]  ffff000006731700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  +0.000007]  ffff000006731780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  +0.000006] ==================================================================

Fix by adding 'remove' driver callback for meson-drm, and explicitly deleting the
aggregate device.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220919010940.419893-3-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 7df149d42728..8444d90165fb 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -493,6 +493,13 @@ static int meson_drv_probe(struct platform_device *pdev)
 	return 0;
 };
 
+static int meson_drv_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &meson_drv_master_ops);
+
+	return 0;
+}
+
 static struct meson_drm_match_data meson_drm_gxbb_data = {
 	.compat = VPU_COMPATIBLE_GXBB,
 };
@@ -530,6 +537,7 @@ static const struct dev_pm_ops meson_drv_pm_ops = {
 
 static struct platform_driver meson_drm_platform_driver = {
 	.probe      = meson_drv_probe,
+	.remove     = meson_drv_remove,
 	.shutdown   = meson_drv_shutdown,
 	.driver     = {
 		.name	= "meson-drm",
-- 
2.35.1

