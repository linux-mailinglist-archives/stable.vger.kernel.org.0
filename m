Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB83634BC4B
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhC1MRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 08:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhC1MRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 08:17:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3477361969;
        Sun, 28 Mar 2021 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616933829;
        bh=QUTR1JNbJF24QReAwRqgvCYOM01AOr5L0QeRIglDDQE=;
        h=Subject:To:From:Date:From;
        b=OIXX1P9Hq+zvQTjqJ2qBpvvPd6cHttHeMW7liSjdRATl6Om5DR9CJ3LMJosU5yV4H
         I8pSbjUKVhmjg0DP2Uv3wlDcQrtLpjsJ8deadq2BiQLOwfCRzrxo3y53kR8r1LW8vY
         uJfixjZvXdZE6IWszGOlT/dl5U+4Ij4/g8aFVPVE=
Subject: patch "tty: fix memory leak in vc_deallocate" added to tty-testing
To:     paskripkin@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Mar 2021 14:17:06 +0200
Message-ID: <16169338269440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: fix memory leak in vc_deallocate

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 211b4d42b70f1c1660feaa968dac0efc2a96ac4d Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Sun, 28 Mar 2021 00:44:43 +0300
Subject: tty: fix memory leak in vc_deallocate

syzbot reported memory leak in tty/vt.
The problem was in VT_DISALLOCATE ioctl cmd.
After allocating unimap with PIO_UNIMAP it wasn't
freed via VT_DISALLOCATE, but vc_cons[currcons].d was
zeroed.

Reported-by: syzbot+bcc922b19ccc64240b42@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210327214443.21548-1-paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index d9366da51e06..01645e87b3d5 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1381,6 +1381,7 @@ struct vc_data *vc_deallocate(unsigned int currcons)
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vcs_remove_sysfs(currcons);
 		visual_deinit(vc);
+		con_free_unimap(vc);
 		put_pid(vc->vt_pid);
 		vc_uniscr_set(vc, NULL);
 		kfree(vc->vc_screenbuf);
-- 
2.31.1


