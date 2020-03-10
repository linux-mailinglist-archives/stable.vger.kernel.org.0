Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D417FBC5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgCJNMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbgCJNMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:12:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A212467D;
        Tue, 10 Mar 2020 13:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845970;
        bh=/4ABY4o8TTdcJwj6+fijhNuT5dju9meI2BmNsWpfIck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deLqrseobMM9PnZIrec2y2yhCR53Ns8u7DhxV8uUpsxPAUk5EzhfALJTdzDL+aiO1
         HLGC4axPnXH5IAo/2AXx66I1TOp9UazMCCAh2aC6atwg0cul1KssXz8yt5YdKg76E8
         /CQLaQYfEOku6Hqh9eU18MAWWDWz0JPeI5FJIBmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.19 41/86] vgacon: Fix a UAF in vgacon_invert_region
Date:   Tue, 10 Mar 2020 13:45:05 +0100
Message-Id: <20200310124533.006407683@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 513dc792d6060d5ef572e43852683097a8420f56 upstream.

When syzkaller tests, there is a UAF:
  BUG: KASan: use after free in vgacon_invert_region+0x9d/0x110 at addr
    ffff880000100000
  Read of size 2 by task syz-executor.1/16489
  page:ffffea0000004000 count:0 mapcount:-127 mapping:          (null)
  index:0x0
  page flags: 0xfffff00000000()
  page dumped because: kasan: bad access detected
  CPU: 1 PID: 16489 Comm: syz-executor.1 Not tainted
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
  Call Trace:
    [<ffffffffb119f309>] dump_stack+0x1e/0x20
    [<ffffffffb04af957>] kasan_report+0x577/0x950
    [<ffffffffb04ae652>] __asan_load2+0x62/0x80
    [<ffffffffb090f26d>] vgacon_invert_region+0x9d/0x110
    [<ffffffffb0a39d95>] invert_screen+0xe5/0x470
    [<ffffffffb0a21dcb>] set_selection+0x44b/0x12f0
    [<ffffffffb0a3bfae>] tioclinux+0xee/0x490
    [<ffffffffb0a1d114>] vt_ioctl+0xff4/0x2670
    [<ffffffffb0a0089a>] tty_ioctl+0x46a/0x1a10
    [<ffffffffb052db3d>] do_vfs_ioctl+0x5bd/0xc40
    [<ffffffffb052e2f2>] SyS_ioctl+0x132/0x170
    [<ffffffffb11c9b1b>] system_call_fastpath+0x22/0x27
    Memory state around the buggy address:
     ffff8800000fff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     00 00
     ffff8800000fff80: 00 00 00 00 00 00 00 00 00 00 00 00 00
     00 00 00
    >ffff880000100000: ff ff ff ff ff ff ff ff ff ff ff ff ff
     ff ff ff

It can be reproduce in the linux mainline by the program:
  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>
  #include <fcntl.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <sys/ioctl.h>
  #include <linux/vt.h>

  struct tiocl_selection {
    unsigned short xs;      /* X start */
    unsigned short ys;      /* Y start */
    unsigned short xe;      /* X end */
    unsigned short ye;      /* Y end */
    unsigned short sel_mode; /* selection mode */
  };

  #define TIOCL_SETSEL    2
  struct tiocl {
    unsigned char type;
    unsigned char pad;
    struct tiocl_selection sel;
  };

  int main()
  {
    int fd = 0;
    const char *dev = "/dev/char/4:1";

    struct vt_consize v = {0};
    struct tiocl tioc = {0};

    fd = open(dev, O_RDWR, 0);

    v.v_rows = 3346;
    ioctl(fd, VT_RESIZEX, &v);

    tioc.type = TIOCL_SETSEL;
    ioctl(fd, TIOCLINUX, &tioc);

    return 0;
  }

When resize the screen, update the 'vc->vc_size_row' to the new_row_size,
but when 'set_origin' in 'vgacon_set_origin', vgacon use 'vga_vram_base'
for 'vc_origin' and 'vc_visible_origin', not 'vc_screenbuf'. It maybe
smaller than 'vc_screenbuf'. When TIOCLINUX, use the new_row_size to calc
the offset, it maybe larger than the vga_vram_size in vgacon driver, then
bad access.
Also, if set an larger screenbuf firstly, then set an more larger
screenbuf, when copy old_origin to new_origin, a bad access may happen.

So, If the screen size larger than vga_vram, resize screen should be
failed. This alse fix CVE-2020-8649 and CVE-2020-8647.

Linus pointed out that overflow checking seems absent. We're saved by
the existing bounds checks in vc_do_resize() with rather strict
limits:

	if (cols > VC_RESIZE_MAXCOL || lines > VC_RESIZE_MAXROW)
		return -EINVAL;

Fixes: 0aec4867dca14 ("[PATCH] SVGATextMode fix")
Reference: CVE-2020-8647 and CVE-2020-8649
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
[danvet: augment commit message to point out overflow safety]
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200304022429.37738-1-zhangxiaoxu5@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/vgacon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1316,6 +1316,9 @@ static int vgacon_font_get(struct vc_dat
 static int vgacon_resize(struct vc_data *c, unsigned int width,
 			 unsigned int height, unsigned int user)
 {
+	if ((width << 1) * height > vga_vram_size)
+		return -EINVAL;
+
 	if (width % 2 || width > screen_info.orig_video_cols ||
 	    height > (screen_info.orig_video_lines * vga_default_font_height)/
 	    c->vc_font.height)


