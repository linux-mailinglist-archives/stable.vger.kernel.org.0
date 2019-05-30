Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9702F3E7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbfE3EdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbfE3DN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A2624555;
        Thu, 30 May 2019 03:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186008;
        bh=/2LHEkYu/goeeY7c4o2zeiu0wluSLY7o9LR3wpTiklk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFnFR5mn5KzSAuk/GvWUCxiVL8IXZKP/A3qJh1iRorcV+F35wcWQbqXryDAKfbgVo
         fFN4wKPcqnJfVDdUe7QQoVJpS7QnpGG6oBBRpXSvrSummIvaNU8lSspgNU+S6A2x0M
         LpcNUg+ncJV11aJzjTn19m6Hdb7BkQDsRgYPFrIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Fredrik Noring <noring@nocrew.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.0 023/346] fbdev: fix divide error in fb_var_to_videomode
Date:   Wed, 29 May 2019 20:01:36 -0700
Message-Id: <20190530030541.902184837@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shile Zhang <shile.zhang@linux.alibaba.com>

commit cf84807f6dd0be5214378e66460cfc9187f532f9 upstream.

To fix following divide-by-zero error found by Syzkaller:

  divide error: 0000 [#1] SMP PTI
  CPU: 7 PID: 8447 Comm: test Kdump: loaded Not tainted 4.19.24-8.al7.x86_64 #1
  Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:fb_var_to_videomode+0xae/0xc0
  Code: 04 44 03 46 78 03 4e 7c 44 03 46 68 03 4e 70 89 ce d1 ee 69 c0 e8 03 00 00 f6 c2 01 0f 45 ce 83 e2 02 8d 34 09 0f 45 ce 31 d2 <41> f7 f0 31 d2 f7 f1 89 47 08 f3 c3 66 0f 1f 44 00 00 0f 1f 44 00
  RSP: 0018:ffffb7e189347bf0 EFLAGS: 00010246
  RAX: 00000000e1692410 RBX: ffffb7e189347d60 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb7e189347c10
  RBP: ffff99972a091c00 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000100
  R13: 0000000000010000 R14: 00007ffd66baf6d0 R15: 0000000000000000
  FS:  00007f2054d11740(0000) GS:ffff99972fbc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f205481fd20 CR3: 00000004288a0001 CR4: 00000000001606a0
  Call Trace:
   fb_set_var+0x257/0x390
   ? lookup_fast+0xbb/0x2b0
   ? fb_open+0xc0/0x140
   ? chrdev_open+0xa6/0x1a0
   do_fb_ioctl+0x445/0x5a0
   do_vfs_ioctl+0x92/0x5f0
   ? __alloc_fd+0x3d/0x160
   ksys_ioctl+0x60/0x90
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x5b/0x190
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f20548258d7
  Code: 44 00 00 48 8b 05 b9 15 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 15 2d 00 f7 d8 64 89 01 48

It can be triggered easily with following test code:

  #include <linux/fb.h>
  #include <fcntl.h>
  #include <sys/ioctl.h>
  int main(void)
  {
          struct fb_var_screeninfo var = {.activate = 0x100, .pixclock = 60};
          int fd = open("/dev/fb0", O_RDWR);
          if (fd < 0)
                  return 1;

          if (ioctl(fd, FBIOPUT_VSCREENINFO, &var))
                  return 1;

          return 0;
  }

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Fredrik Noring <noring@nocrew.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/modedb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/core/modedb.c
+++ b/drivers/video/fbdev/core/modedb.c
@@ -935,6 +935,9 @@ void fb_var_to_videomode(struct fb_video
 	if (var->vmode & FB_VMODE_DOUBLE)
 		vtotal *= 2;
 
+	if (!htotal || !vtotal)
+		return;
+
 	hfreq = pixclock/htotal;
 	mode->refresh = hfreq/vtotal;
 }


