Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA038EF38
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhEXP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235074AbhEXPzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E188B61447;
        Mon, 24 May 2021 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870925;
        bh=L/xPLGm/qLV+YqHAOHzZxxZtnGQFGf7t85dzR4tXEho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZqwRw7WjTWeNQrq47jtvFzF0FGL87kFUtOjC3D4XygTSPC0wJE9cwS9nJG8UJic/
         4wtWSZRgzHFtPVQ6K6/gKzzwtB/esvuHXlIKytaNeGKITbmBKGGfROvsbIZ1NAMq4I
         +Cw06HUiD/SL9busbJ+iwwX2EaGpu47e2OIqnzqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.10 098/104] tty: vt: always invoke vc->vc_sw->con_resize callback
Date:   Mon, 24 May 2021 17:26:33 +0200
Message-Id: <20210524152336.098232142@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ffb324e6f874121f7dce5bdae5e05d02baae7269 upstream.

syzbot is reporting OOB write at vga16fb_imageblit() [1], for
resize_screen() from ioctl(VT_RESIZE) returns 0 without checking whether
requested rows/columns fit the amount of memory reserved for the graphical
screen if current mode is KD_GRAPHICS.

----------
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <sys/ioctl.h>
  #include <linux/kd.h>
  #include <linux/vt.h>

  int main(int argc, char *argv[])
  {
        const int fd = open("/dev/char/4:1", O_RDWR);
        struct vt_sizes vt = { 0x4100, 2 };

        ioctl(fd, KDSETMODE, KD_GRAPHICS);
        ioctl(fd, VT_RESIZE, &vt);
        ioctl(fd, KDSETMODE, KD_TEXT);
        return 0;
  }
----------

Allow framebuffer drivers to return -EINVAL, by moving vc->vc_mode !=
KD_GRAPHICS check from resize_screen() to fbcon_resize().

Link: https://syzkaller.appspot.com/bug?extid=1f29e126cf461c4de3b3 [1]
Reported-by: syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c              |    2 +-
 drivers/video/fbdev/core/fbcon.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1172,7 +1172,7 @@ static inline int resize_screen(struct v
 	/* Resizes the resolution of the display adapater */
 	int err = 0;
 
-	if (vc->vc_mode != KD_GRAPHICS && vc->vc_sw->con_resize)
+	if (vc->vc_sw->con_resize)
 		err = vc->vc_sw->con_resize(vc, width, height, user);
 
 	return err;
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2031,7 +2031,7 @@ static int fbcon_resize(struct vc_data *
 			return -EINVAL;
 
 		DPRINTK("resize now %ix%i\n", var.xres, var.yres);
-		if (con_is_visible(vc)) {
+		if (con_is_visible(vc) && vc->vc_mode == KD_TEXT) {
 			var.activate = FB_ACTIVATE_NOW |
 				FB_ACTIVATE_FORCE;
 			fb_set_var(info, &var);


