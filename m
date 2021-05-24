Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15EA38ED3B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhEXPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhEXPdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:33:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 427EE613F7;
        Mon, 24 May 2021 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870300;
        bh=VrVZ8Guok2XCiKcaAiYzrkzge76b4ZYUoA/h9DVqsG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrMVds7S6rcMFELyo/kdsFw4j6DzE5Tw6TJR2yg9gsRnyzZRpYe4UtddPx8EGaum0
         KmF3plumaVbbdDPHZ01mKRLAUR8TDPbiW1P+eDMd6vhdmZBfrSbr6lMa4H6gVUwqFX
         ucE/W4LnYWkVgXjzgcipd0Uc0dD/Fq2NF5ooQ3I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.4 31/31] tty: vt: always invoke vc->vc_sw->con_resize callback
Date:   Mon, 24 May 2021 17:25:14 +0200
Message-Id: <20210524152323.935039070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
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
 drivers/tty/vt/vt.c           |    2 +-
 drivers/video/console/fbcon.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -826,7 +826,7 @@ static inline int resize_screen(struct v
 	/* Resizes the resolution of the display adapater */
 	int err = 0;
 
-	if (vc->vc_mode != KD_GRAPHICS && vc->vc_sw->con_resize)
+	if (vc->vc_sw->con_resize)
 		err = vc->vc_sw->con_resize(vc, width, height, user);
 
 	return err;
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1986,7 +1986,7 @@ static int fbcon_resize(struct vc_data *
 			return -EINVAL;
 
 		DPRINTK("resize now %ix%i\n", var.xres, var.yres);
-		if (CON_IS_VISIBLE(vc)) {
+		if (CON_IS_VISIBLE(vc) && vc->vc_mode == KD_TEXT) {
 			var.activate = FB_ACTIVATE_NOW |
 				FB_ACTIVATE_FORCE;
 			fb_set_var(info, &var);


