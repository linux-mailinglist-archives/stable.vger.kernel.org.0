Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8A329A9D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbfEXPJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389125AbfEXPJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 11:09:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FCB20862;
        Fri, 24 May 2019 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558710539;
        bh=GUIssrjQdO+dAiduUA4ZqpJbMyQYJQNnQQiS0VwFo6g=;
        h=Subject:To:From:Date:From;
        b=dhHtZJTY4bvpMPQ7Yt0aZ3UnkE4nzsolWQFOkcyxFB3xeEdEtqDFBy+A7qiVNNagg
         NhcPKVs/to4euVcXP6sxKU6A9YBGxobtZwqO31qSbipEELZro0+oohzN/hGgWFQAA9
         /w0Iuby2SL5zfSArfZZKhjMEKF5Lkk45axF1prDY=
Subject: patch "vt/fbcon: deinitialize resources in visual_init() after failed memory" added to tty-linus
To:     ghalat@redhat.com, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org, oleksandr@redhat.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 May 2019 17:08:57 +0200
Message-ID: <1558710537231239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt/fbcon: deinitialize resources in visual_init() after failed memory

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a1ad1cc9704f64c169261a76e1aee1cf1ae51832 Mon Sep 17 00:00:00 2001
From: Grzegorz Halat <ghalat@redhat.com>
Date: Fri, 26 Apr 2019 16:59:46 +0200
Subject: vt/fbcon: deinitialize resources in visual_init() after failed memory
 allocation

After memory allocation failure vc_allocate() doesn't clean up data
which has been initialized in visual_init(). In case of fbcon this
leads to divide-by-0 in fbcon_init() on next open of the same tty.

memory allocation in vc_allocate() may fail here:
1097:     vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_KERNEL);

on next open() fbcon_init() skips vc_font.data initialization:
1088:     if (!p->fontdata) {

division by zero in fbcon_init() happens here:
1149:     new_cols /= vc->vc_font.width;

Additional check is needed in fbcon_deinit() to prevent
usage of uninitialized vc_screenbuf:

1251:        if (vc->vc_hi_font_mask && vc->vc_screenbuf)
1252:                set_vc_hi_font(vc, false);

Crash:

 #6 [ffffc90001eafa60] divide_error at ffffffff81a00be4
    [exception RIP: fbcon_init+463]
    RIP: ffffffff814b860f  RSP: ffffc90001eafb18  RFLAGS: 00010246
...
 #7 [ffffc90001eafb60] visual_init at ffffffff8154c36e
 #8 [ffffc90001eafb80] vc_allocate at ffffffff8154f53c
 #9 [ffffc90001eafbc8] con_install at ffffffff8154f624
...

Signed-off-by: Grzegorz Halat <ghalat@redhat.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c              | 11 +++++++++--
 drivers/video/fbdev/core/fbcon.c |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index fdd12f8c3deb..5c0ca1c24b6f 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1056,6 +1056,13 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }
 
+
+static void visual_deinit(struct vc_data *vc)
+{
+	vc->vc_sw->con_deinit(vc);
+	module_put(vc->vc_sw->owner);
+}
+
 int vc_allocate(unsigned int currcons)	/* return 0 on success */
 {
 	struct vt_notifier_param param;
@@ -1103,6 +1110,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 
 	return 0;
 err_free:
+	visual_deinit(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return -ENOMEM;
@@ -1331,9 +1339,8 @@ struct vc_data *vc_deallocate(unsigned int currcons)
 		param.vc = vc = vc_cons[currcons].d;
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vcs_remove_sysfs(currcons);
-		vc->vc_sw->con_deinit(vc);
+		visual_deinit(vc);
 		put_pid(vc->vt_pid);
-		module_put(vc->vc_sw->owner);
 		vc_uniscr_set(vc, NULL);
 		kfree(vc->vc_screenbuf);
 		vc_cons[currcons].d = NULL;
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 786f9aab55df..a9c69ae30878 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1248,7 +1248,7 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (free_font)
 		vc->vc_font.data = NULL;
 
-	if (vc->vc_hi_font_mask)
+	if (vc->vc_hi_font_mask && vc->vc_screenbuf)
 		set_vc_hi_font(vc, false);
 
 	if (!con_is_bound(&fb_con))
-- 
2.21.0


