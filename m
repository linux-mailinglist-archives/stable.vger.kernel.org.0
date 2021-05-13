Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28937FAC9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhEMPf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234906AbhEMPfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64C761420;
        Thu, 13 May 2021 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920055;
        bh=eL04HIlMDswVMlxHZBPDqLXegfVf6iFCq654wPq6Wgg=;
        h=Subject:To:From:Date:From;
        b=b+myeXDf0etgdcJ3aJd5UkJMB7BCpZAn21KazLsY70MaiEJ3Fxr71MWVjXLX6ftzG
         7Dbh8e66eANIKyU4ln1knCNoCeQGOsjOGPx/e3vuVut1fZ0hBPIbMCgnTVqVoxegHR
         wmmH47nkM5QNIf3jvtJhIeZbVr6Jt9FJRBEafrTk=
Subject: patch "Revert "niu: fix missing checks of niu_pci_eeprom_read"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, davem@davemloft.net, kjlu@umn.edu,
        shannon.lee.nelson@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:11 +0200
Message-ID: <1620920051126161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "niu: fix missing checks of niu_pci_eeprom_read"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7930742d6a0ff091c85b92ef4e076432d8d8cb79 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:49 +0200
Subject: Revert "niu: fix missing checks of niu_pci_eeprom_read"

This reverts commit 26fd962bde0b15e54234fe762d86bc0349df1de4.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The change here was incorrect.  While it is nice to check if
niu_pci_eeprom_read() succeeded or not when using the data, any error
that might have happened was not propagated upwards properly, causing
the kernel to assume that these reads were successful, which results in
invalid data in the buffer that was to contain the successfully read
data.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Fixes: 26fd962bde0b ("niu: fix missing checks of niu_pci_eeprom_read")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-23-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 707ccdd03b19..d70cdea756d1 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8097,8 +8097,6 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 		start += 3;
 
 		prop_len = niu_pci_eeprom_read(np, start + 4);
-		if (prop_len < 0)
-			return prop_len;
 		err = niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);
 		if (err < 0)
 			return err;
@@ -8143,12 +8141,8 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 			netif_printk(np, probe, KERN_DEBUG, np->dev,
 				     "VPD_SCAN: Reading in property [%s] len[%d]\n",
 				     namebuf, prop_len);
-			for (i = 0; i < prop_len; i++) {
-				err = niu_pci_eeprom_read(np, off + i);
-				if (err >= 0)
-					*prop_buf = err;
-				++prop_buf;
-			}
+			for (i = 0; i < prop_len; i++)
+				*prop_buf++ = niu_pci_eeprom_read(np, off + i);
 		}
 
 		start += len;
-- 
2.31.1


