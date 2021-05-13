Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3E37FACD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhEMPfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhEMPff (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AA23613BF;
        Thu, 13 May 2021 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920064;
        bh=CSQrUvi3jZfeCG53KMU9eMclh4ukEfIGeewwpb5tWNA=;
        h=Subject:To:From:Date:From;
        b=WDE56rBbKfMmgNr5rOlryIApKXw55yZ7rJrgcPMdotnz1mnlFR4FS/p2Fzwo8oDO+
         FdxoE/ohLCjXA5GaPMi9UaorGhuC+l+wFTvzkrkE9ITpkEqVREegaDBtkdOcXh3eU8
         FeQ7QLKDCuOS8GsJmNK3tr2q1RYTrLUQjR9bKRNQ=
Subject: patch "cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom" added to char-misc-linus
To:     atulgopinathan@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, peda@axentia.se, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:14 +0200
Message-ID: <1620920054192223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d03d1021da6fe7f46efe9f2a7335564e7c9db5ab Mon Sep 17 00:00:00 2001
From: Atul Gopinathan <atulgopinathan@gmail.com>
Date: Mon, 3 May 2021 13:56:54 +0200
Subject: cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
deallocated in the "remove_gdrom()" function.

Also prevent double free of the field "gd.toc" by moving it from the
module's exit function to "remove_gdrom()". This is because, in
"probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
of any errors, so the exit function invoked later would again free
"gd.toc".

The patch also maintains consistency by deallocating the above mentioned
fields in "remove_gdrom()" along with another memory allocated field
"gd.disk".

Suggested-by: Jens Axboe <axboe@kernel.dk>
Cc: Peter Rosin <peda@axentia.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-28-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 7f681320c7d3..6c4f6139f853 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	unregister_cdrom(gd.cd_info);
+	kfree(gd.cd_info);
+	kfree(gd.toc);
 
 	return 0;
 }
@@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
 {
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
-	kfree(gd.toc);
 }
 
 module_init(init_gdrom);
-- 
2.31.1


