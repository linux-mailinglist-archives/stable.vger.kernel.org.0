Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9508D37FBEE
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhEMRAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhEMRA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 13:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A5BE6121E;
        Thu, 13 May 2021 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620925158;
        bh=AGP0qLQAvLn5bfTHvfYzreI8sOPpb8sZlM3kP7ue2q0=;
        h=Subject:To:From:Date:From;
        b=Iy4U2Rf+6+yf1TYVvXtkkxzgA8YNXMK3EST6SoFeSk3hnZPanvELNpSF+6hdWFIO7
         6UZSw7qz92UKNllyhVT9lGvisW/gbiJuPAiBff4jedWI+V71hgTyMeSkLVeYuCUtNq
         BPRmqvxdxMzszGO6ICCxh0ni7oM7bjgHmtnQhJJQ=
Subject: patch "Revert "video: imsttfb: fix potential NULL pointer dereferences"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, b.zolnierkie@samsung.com,
        fthain@telegraphics.com.au, kjlu@umn.edu, pakki001@umn.edu,
        robh@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 18:58:58 +0200
Message-ID: <16209251388625@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "video: imsttfb: fix potential NULL pointer dereferences"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ed04fe8a0e87d7b5ea17d47f4ac9ec962b24814a Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:57:33 +0200
Subject: Revert "video: imsttfb: fix potential NULL pointer dereferences"

This reverts commit 1d84353d205a953e2381044953b7fa31c8c9702d.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit here, while technically correct, did not fully
handle all of the reported issues that the commit stated it was fixing,
so revert it until it can be "fixed" fully.

Note, ioremap() probably will never fail for old hardware like this, and
if anyone actually used this hardware (a PowerMac era PCI display card),
they would not be using fbdev anymore.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Fixes: 1d84353d205a ("video: imsttfb: fix potential NULL pointer dereferences")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-67-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/imsttfb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 3ac053b88495..e04411701ec8 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1512,11 +1512,6 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
-	if (!info->screen_base) {
-		release_mem_region(addr, size);
-		framebuffer_release(info);
-		return -ENOMEM;
-	}
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
 	par->cmap_regs_phys = addr + 0x840000;
-- 
2.31.1


