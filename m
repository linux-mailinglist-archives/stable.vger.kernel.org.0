Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ECC453A0B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbhKPTVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239881AbhKPTVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:21:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354526322C;
        Tue, 16 Nov 2021 19:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090293;
        bh=cnE1MXGiLmPpRtN/cnvdTU1sq0u1ItfQ4UaqvApuf0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lutaWK18GV7fGck6kElTwzvbshsZ5Qst04PLv8J4HfFMHIP2gG5ACORHLtU0HgX4H
         d1odNUziYDBRkFEUU9tVd7l0Hfong8KukKShvt8ksdMIjQ/NmkuKfkrCkOssaA/Rgx
         xN5B3/YN38ChxO4c4JmeB3DClzV2fB7PhvDVLdD3ICJQC45EGQjygtY2ymcc7PFPc6
         KvfLhBkk5k3oCR4Lf0SYxzakRlrwE3BRm6YLA7ffT/ib7J5/NRlhZdE25CPo9bQ/Nt
         uvWS/zZ4FkA2S9WzQ4+lyPsTTE0QViwAddSuatkzggsHB+SJYB/r3NMXmoPpwF4XyW
         we74fO48JkjdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>, daniel.vetter@ffwll.ch,
        willy@infradead.org, geert+renesas@glider.be,
        william.kucharski@oracle.com, xiyuyang19@fudan.edu.cn,
        penguin-kernel@i-love.sakura.ne.jp, thunder.leizhen@huawei.com,
        linux@roeck-us.net, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/65] fbdev: fbmem: Fix double free of 'fb_info->pixmap.addr'
Date:   Tue, 16 Nov 2021 14:16:52 -0500
Message-Id: <20211116191754.2419097-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 2c0c19b681d5a331b53aab0d170f72a87c7bff12 ]

savagefb and some other drivers call kfree to free 'info->pixmap.addr'
even after calling unregister_framebuffer, which may cause double free.

Fix this by setting 'fb_info->pixmap.addr' to NULL after kfree in
unregister_framebuffer.

The following log reveals it:

[   37.318872] BUG: KASAN: double-free or invalid-free in kfree+0x13e/0x290
[   37.319369]
[   37.320803] Call Trace:
[   37.320992]  dump_stack_lvl+0xa8/0xd1
[   37.321274]  print_address_description+0x87/0x3b0
[   37.321632]  ? kfree+0x13e/0x290
[   37.321879]  ? kfree+0x13e/0x290
[   37.322126]  ? kfree+0x13e/0x290
[   37.322374]  kasan_report_invalid_free+0x58/0x90
[   37.322724]  ____kasan_slab_free+0x123/0x140
[   37.323049]  __kasan_slab_free+0x11/0x20
[   37.323347]  slab_free_freelist_hook+0x81/0x150
[   37.323689]  ? savagefb_remove+0xa1/0xc0 [savagefb]
[   37.324066]  kfree+0x13e/0x290
[   37.324304]  savagefb_remove+0xa1/0xc0 [savagefb]
[   37.324655]  pci_device_remove+0xa9/0x250
[   37.324959]  ? pci_device_probe+0x7d0/0x7d0
[   37.325273]  device_release_driver_internal+0x4f7/0x7a0
[   37.325666]  driver_detach+0x1e8/0x2c0
[   37.325952]  bus_remove_driver+0x134/0x290
[   37.326262]  ? sysfs_remove_groups+0x97/0xb0
[   37.326584]  driver_unregister+0x77/0xa0
[   37.326883]  pci_unregister_driver+0x2c/0x1c0
[   37.336124]
[   37.336245] Allocated by task 5465:
[   37.336507]  ____kasan_kmalloc+0xb5/0xe0
[   37.336801]  __kasan_kmalloc+0x9/0x10
[   37.337069]  kmem_cache_alloc_trace+0x12b/0x220
[   37.337405]  register_framebuffer+0x3f3/0xa00
[   37.337731]  foo_register_framebuffer+0x3b/0x50 [savagefb]
[   37.338136]
[   37.338255] Freed by task 5475:
[   37.338492]  kasan_set_track+0x3d/0x70
[   37.338774]  kasan_set_free_info+0x23/0x40
[   37.339081]  ____kasan_slab_free+0x10b/0x140
[   37.339399]  __kasan_slab_free+0x11/0x20
[   37.339694]  slab_free_freelist_hook+0x81/0x150
[   37.340034]  kfree+0x13e/0x290
[   37.340267]  do_unregister_framebuffer+0x21c/0x3d0
[   37.340624]  unregister_framebuffer+0x23/0x40
[   37.340950]  savagefb_remove+0x45/0xc0 [savagefb]
[   37.341302]  pci_device_remove+0xa9/0x250
[   37.341603]  device_release_driver_internal+0x4f7/0x7a0
[   37.341990]  driver_detach+0x1e8/0x2c0
[   37.342272]  bus_remove_driver+0x134/0x290
[   37.342577]  driver_unregister+0x77/0xa0
[   37.342873]  pci_unregister_driver+0x2c/0x1c0
[   37.343196]  cleanup_module+0x15/0x1c [savagefb]
[   37.343543]  __se_sys_delete_module+0x398/0x490
[   37.343881]  __x64_sys_delete_module+0x56/0x60
[   37.344221]  do_syscall_64+0x4d/0xc0
[   37.344492]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1633848148-29747-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 7420d2c16e47e..826175ad88a2f 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1702,8 +1702,11 @@ static void do_unregister_framebuffer(struct fb_info *fb_info)
 {
 	unlink_framebuffer(fb_info);
 	if (fb_info->pixmap.addr &&
-	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
+	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT)) {
 		kfree(fb_info->pixmap.addr);
+		fb_info->pixmap.addr = NULL;
+	}
+
 	fb_destroy_modelist(&fb_info->modelist);
 	registered_fb[fb_info->node] = NULL;
 	num_registered_fb--;
-- 
2.33.0

