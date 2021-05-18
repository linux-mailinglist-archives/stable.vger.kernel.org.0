Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823E2386ECB
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 03:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345404AbhERBLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 21:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345413AbhERBLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 21:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C66461354;
        Tue, 18 May 2021 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621300188;
        bh=0zKjkGyEvQV2romi22O4oKlA9u2Zf+tpdLVoIqglSLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OweZpeDIZXqLP/xyVBRgeVY588O42UWbJ2mRdhcERaUblxrPuISqXyw3cwIIYCSvC
         d+oG7kQjZiXb90wlm9oMq5oT2UYnPfk2BM8ewiou5jK7OqUDWPGfaQp5PYVnCTnlvG
         f+suzg+GqLMhfqnFtJzRM9Z7QfUJs9sEmEJnshA+UCtpuOjHMe/aW5O8CgaO/VMKFA
         CA9qGc169fQkZf4C914MS2dVr6IbpVA66VeyVSRAfn9XqM+kVisFkhOh7IKD+IIzzj
         gvpOERVaq9kP2PilKRudaQw++PAU/aq5/w6dR54168FGYIV2y6BCkzJwuHydNGWJgK
         ozNGFZNfele+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 5/5] tty: vt: always invoke vc->vc_sw->con_resize callback
Date:   Mon, 17 May 2021 21:09:40 -0400
Message-Id: <20210518010940.1485417-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210518010940.1485417-1-sashal@kernel.org>
References: <20210518010940.1485417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ffb324e6f874121f7dce5bdae5e05d02baae7269 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c              | 2 +-
 drivers/video/fbdev/core/fbcon.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 0cc360da5426..53cbf2c3f033 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1171,7 +1171,7 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
 	/* Resizes the resolution of the display adapater */
 	int err = 0;
 
-	if (vc->vc_mode != KD_GRAPHICS && vc->vc_sw->con_resize)
+	if (vc->vc_sw->con_resize)
 		err = vc->vc_sw->con_resize(vc, width, height, user);
 
 	return err;
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 3406067985b1..22bb3892f6bd 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2019,7 +2019,7 @@ static int fbcon_resize(struct vc_data *vc, unsigned int width,
 			return -EINVAL;
 
 		pr_debug("resize now %ix%i\n", var.xres, var.yres);
-		if (con_is_visible(vc)) {
+		if (con_is_visible(vc) && vc->vc_mode == KD_TEXT) {
 			var.activate = FB_ACTIVATE_NOW |
 				FB_ACTIVATE_FORCE;
 			fb_set_var(info, &var);
-- 
2.30.2

