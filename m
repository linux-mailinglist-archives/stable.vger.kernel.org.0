Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777173CE1D1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347798AbhGSP1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348310AbhGSPYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6B261469;
        Mon, 19 Jul 2021 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710647;
        bh=s8qxXTQl66UCi8CW5gBxbUGTEfvj080RXKdnY+bWkSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fFXwQqdF5JEq2zOiVYgMdrOjXN8MSA7n/QXf55ue66f/FEAGMN72o3spKbvENlKN
         Z3TxoVjFbXZhQh2wy/HJ6s0yLccqOf5p162xhtRlAUnXhbw3PHGR65hAHBcdPCyB+G
         E4IECLsO96/hya923L8IaIgzbDIsemr7l++DT4XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.13 023/351] fbmem: Do not delete the mode that is still in use
Date:   Mon, 19 Jul 2021 16:49:29 +0200
Message-Id: <20210719144945.295570145@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 0af778269a522c988ef0b4188556aba97fb420cc upstream.

The execution of fb_delete_videomode() is not based on the result of the
previous fbcon_mode_deleted(). As a result, the mode is directly deleted,
regardless of whether it is still in use, which may cause UAF.

==================================================================
BUG: KASAN: use-after-free in fb_mode_is_equal+0x36e/0x5e0 \
drivers/video/fbdev/core/modedb.c:924
Read of size 4 at addr ffff88807e0ddb1c by task syz-executor.0/18962

CPU: 2 PID: 18962 Comm: syz-executor.0 Not tainted 5.10.45-rc1+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ...
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:118
 print_address_description+0x6c/0x640 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report+0x13d/0x1e0 mm/kasan/report.c:562
 fb_mode_is_equal+0x36e/0x5e0 drivers/video/fbdev/core/modedb.c:924
 fbcon_mode_deleted+0x16a/0x220 drivers/video/fbdev/core/fbcon.c:2746
 fb_set_var+0x1e1/0xdb0 drivers/video/fbdev/core/fbmem.c:975
 do_fb_ioctl+0x4d9/0x6e0 drivers/video/fbdev/core/fbmem.c:1108
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 18960:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x108/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1541 [inline]
 slab_free_freelist_hook+0xd6/0x1a0 mm/slub.c:1574
 slab_free mm/slub.c:3139 [inline]
 kfree+0xca/0x3d0 mm/slub.c:4121
 fb_delete_videomode+0x56a/0x820 drivers/video/fbdev/core/modedb.c:1104
 fb_set_var+0x1f3/0xdb0 drivers/video/fbdev/core/fbmem.c:978
 do_fb_ioctl+0x4d9/0x6e0 drivers/video/fbdev/core/fbmem.c:1108
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 13ff178ccd6d ("fbcon: Call fbcon_mode_deleted/new_modelist directly")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210712085544.2828-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -970,13 +970,11 @@ fb_set_var(struct fb_info *info, struct
 		fb_var_to_videomode(&mode2, &info->var);
 		/* make sure we don't delete the videomode of current var */
 		ret = fb_mode_is_equal(&mode1, &mode2);
-
-		if (!ret)
-			fbcon_mode_deleted(info, &mode1);
-
-		if (!ret)
-			fb_delete_videomode(&mode1, &info->modelist);
-
+		if (!ret) {
+			ret = fbcon_mode_deleted(info, &mode1);
+			if (!ret)
+				fb_delete_videomode(&mode1, &info->modelist);
+		}
 
 		return ret ? -EINVAL : 0;
 	}


