Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF9346138
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 15:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhCWOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 10:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232250AbhCWOPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 10:15:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B7F2619A9;
        Tue, 23 Mar 2021 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616508944;
        bh=nbw8YVp0mfdnhnsrQQAm6hbUUtKxcBIvx9TGIc2iiYk=;
        h=Subject:To:From:Date:From;
        b=EQMZjw2BJSYc8Mcu4LAdyMFL3jSwPi5UaBlSmEWS/xuGdCyMfz1f2hrbrJj6TRvEP
         dBgcULPVbVFY30/trMq7opp4udqlvxMLKghPuQDMtYAE3WVeuOFbzZTTdA7l/unSoe
         uYjJsJC4AH/cy/gcGTbebAlA/veCbU6yEQe9Mpog=
Subject: patch "drivers: video: fbcon: fix NULL dereference in fbcon_cursor()" added to char-misc-linus
To:     ducheng2@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 15:15:31 +0100
Message-ID: <161650893114214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 01faae5193d6190b7b3aa93dae43f514e866d652 Mon Sep 17 00:00:00 2001
From: Du Cheng <ducheng2@gmail.com>
Date: Fri, 12 Mar 2021 16:14:21 +0800
Subject: drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

add null-check on function pointer before dereference on ops->cursor

Reported-by: syzbot+b67aaae8d3a927f68d20@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210312081421.452405-1-ducheng2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 44a5cd2f54cc..3406067985b1 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1333,6 +1333,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 
+	if (!ops->cursor)
+		return;
+
 	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 }
-- 
2.31.0


