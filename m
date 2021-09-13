Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3EF409059
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbhIMNwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhIMNsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:48:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C9E61507;
        Mon, 13 Sep 2021 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539973;
        bh=/g+trBMoQm5LAjyoHsSB+HdF4wGta3FusR7hgMEIbGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8XoPA9JHWv7mc1TfYWh+SWPibVeusauKQry9NijRIDFAnqoxWyIDVaN7bwldUI4I
         akQyDEprybbo9/RS1F1c4iAtrMxqFcXX47i7kTeawVQS9bhbqnhc3wmYS3oCbxX/Nn
         LTZIW12v7T2swyCPe4N974KVNNz5vCignhjOoaGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+04168c8063cfdde1db5e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.10 234/236] fbmem: dont allow too huge resolutions
Date:   Mon, 13 Sep 2021 15:15:39 +0200
Message-Id: <20210913131108.302535853@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 8c28051cdcbe9dfcec6bd0a4709d67a09df6edae upstream.

syzbot is reporting page fault at vga16fb_fillrect() [1], for
vga16fb_check_var() is failing to detect multiplication overflow.

  if (vxres * vyres > maxmem) {
    vyres = maxmem / vxres;
    if (vyres < yres)
      return -ENOMEM;
  }

Since no module would accept too huge resolutions where multiplication
overflow happens, let's reject in the common path.

Link: https://syzkaller.appspot.com/bug?extid=04168c8063cfdde1db5e [1]
Reported-by: syzbot <syzbot+04168c8063cfdde1db5e@syzkaller.appspotmail.com>
Debugged-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/185175d6-227a-7b55-433d-b070929b262c@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -962,6 +962,7 @@ fb_set_var(struct fb_info *info, struct
 	struct fb_var_screeninfo old_var;
 	struct fb_videomode mode;
 	struct fb_event event;
+	u32 unused;
 
 	if (var->activate & FB_ACTIVATE_INV_MODE) {
 		struct fb_videomode mode1, mode2;
@@ -1008,6 +1009,11 @@ fb_set_var(struct fb_info *info, struct
 	if (var->xres < 8 || var->yres < 8)
 		return -EINVAL;
 
+	/* Too huge resolution causes multiplication overflow. */
+	if (check_mul_overflow(var->xres, var->yres, &unused) ||
+	    check_mul_overflow(var->xres_virtual, var->yres_virtual, &unused))
+		return -EINVAL;
+
 	ret = info->fbops->fb_check_var(var, info);
 
 	if (ret)


