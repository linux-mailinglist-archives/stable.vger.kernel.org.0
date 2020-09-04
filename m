Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355CD25DD95
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 17:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgIDP04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 11:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgIDP0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 11:26:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF822074D;
        Fri,  4 Sep 2020 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599233213;
        bh=xwC4qj/cRCrgwCtFgc/JWaUeb0xiAShnqQwbFlEc+5k=;
        h=Subject:To:From:Date:From;
        b=TvLZ9ZRUDnIYI0s3TeSBC0g2WnVVm7K2acPfL5V92h6pwd07oxK7iWMD3uWzh//wG
         VA/tpK5VDgrTKJ9VeuSGcTIjc3ESq+DaRsirM2uY0QeRs+6Kq5TrZJhUEff2IuK1gN
         o7+EBYvWqUPZeq8LyDoNB6Baaz0eRNdhHc1ze/a8=
Subject: patch "video: fbdev: fix OOB read in vga_8planes_imageblit()" added to char-misc-linus
To:     penguin-kernel@i-love.sakura.ne.jp, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        syzbot+69fbd3e01470f169c8c4@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 17:27:14 +0200
Message-ID: <159923323411392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    video: fbdev: fix OOB read in vga_8planes_imageblit()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bd018a6a75cebb511bb55a0e7690024be975fe93 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Mon, 31 Aug 2020 19:37:00 +0900
Subject: video: fbdev: fix OOB read in vga_8planes_imageblit()

syzbot is reporting OOB read at vga_8planes_imageblit() [1], for
"cdat[y] >> 4" can become a negative value due to "const char *cdat".

[1] https://syzkaller.appspot.com/bug?id=0d7a0da1557dcd1989e00cb3692b26d4173b4132

Reported-by: syzbot <syzbot+69fbd3e01470f169c8c4@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/90b55ec3-d5b0-3307-9f7c-7ff5c5fd6ad3@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vga16fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vga16fb.c b/drivers/video/fbdev/vga16fb.c
index a20eeb8308ff..578d3541e3d6 100644
--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -1121,7 +1121,7 @@ static void vga_8planes_imageblit(struct fb_info *info, const struct fb_image *i
         char oldop = setop(0);
         char oldsr = setsr(0);
         char oldmask = selectmask();
-        const char *cdat = image->data;
+	const unsigned char *cdat = image->data;
 	u32 dx = image->dx;
         char __iomem *where;
         int y;
-- 
2.28.0


