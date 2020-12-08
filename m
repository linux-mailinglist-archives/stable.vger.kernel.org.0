Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62202D2675
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 09:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgLHIl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 03:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgLHIl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 03:41:57 -0500
Subject: patch "usb: mtu3: fix memory corruption in mtu3_debugfs_regset()" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607416876;
        bh=oXp/AmXQ3qM6J19Z6NeVQiUvqKqb+v6EFL9ObKuFztc=;
        h=To:From:Date:From;
        b=hCz2r46rVimiDorzNptVULR/hQcQP5ddFx79J3db3NvmwarlImVUlkaFfYI6fg8YM
         9B3kkwYTQv/NW7KiDpTOiyHWuXMKHj1h1hQX81vq+tm2HsaJzUh1D3y+KkwKe8KBDu
         n2JK5wmVETo7sz5DOXLG0lCiTDIZnWfRM6zbo4cQ=
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Dec 2020 09:42:14 +0100
Message-ID: <16074169345098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: mtu3: fix memory corruption in mtu3_debugfs_regset()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3f6f6343a29d9ea7429306b83b18e66dc1331d5c Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 3 Dec 2020 11:41:13 +0300
Subject: usb: mtu3: fix memory corruption in mtu3_debugfs_regset()

This code is using the wrong sizeof() so it does not allocate enough
memory.  It allocates 32 bytes but 72 are required.  That will lead to
memory corruption.

Fixes: ae07809255d3 ("usb: mtu3: add debugfs interface files")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8ikqc4Mo2/0G72j@mwanda
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_debugfs.c b/drivers/usb/mtu3/mtu3_debugfs.c
index fdeade6254ae..7537bfd651af 100644
--- a/drivers/usb/mtu3/mtu3_debugfs.c
+++ b/drivers/usb/mtu3/mtu3_debugfs.c
@@ -127,7 +127,7 @@ static void mtu3_debugfs_regset(struct mtu3 *mtu, void __iomem *base,
 	struct debugfs_regset32 *regset;
 	struct mtu3_regset *mregs;
 
-	mregs = devm_kzalloc(mtu->dev, sizeof(*regset), GFP_KERNEL);
+	mregs = devm_kzalloc(mtu->dev, sizeof(*mregs), GFP_KERNEL);
 	if (!mregs)
 		return;
 
-- 
2.29.2


