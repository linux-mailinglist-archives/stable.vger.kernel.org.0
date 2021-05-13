Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564F837FACE
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhEMPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhEMPfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 926DF611AC;
        Thu, 13 May 2021 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920067;
        bh=7ntc07Td8oeLuUQI1aJ7+FXGmYn+y4zRKCJPsecoUIY=;
        h=Subject:To:From:Date:From;
        b=xG3rLvHSa0iBJKVvlyFddP6i9VE16SnABOKNcMB5hzddcJkeCKh7J8iaqmtTw49ER
         QySG/s0mNOEKzKkhgER8JND4w4jkAVKt/cetmQpZz0zgozeXkpcCIf1GVfrr0JRgR8
         YAt2gKXyvD5POUB62Ek8eDe4ybw0DQY8MLud1n+Y=
Subject: patch "Revert "gdrom: fix a memory leak bug"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, axboe@kernel.dk, peda@axentia.se,
        stable@vger.kernel.org, wang6495@umn.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:14 +0200
Message-ID: <162092005416865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "gdrom: fix a memory leak bug"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 257343d3ed557f11d580d0b7c515dc154f64a42b Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:53 +0200
Subject: Revert "gdrom: fix a memory leak bug"

This reverts commit 093c48213ee37c3c3ff1cf5ac1aa2a9d8bc66017.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Wenwen Wang <wang6495@umn.edu>
Cc: Peter Rosin <peda@axentia.se>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 093c48213ee3 ("gdrom: fix a memory leak bug")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-27-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 742b4a0932e3..7f681320c7d3 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -862,7 +862,6 @@ static void __exit exit_gdrom(void)
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
 	kfree(gd.toc);
-	kfree(gd.cd_info);
 }
 
 module_init(init_gdrom);
-- 
2.31.1


