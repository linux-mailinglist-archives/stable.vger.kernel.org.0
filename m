Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD8B7496A
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 10:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfGYIyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 04:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfGYIyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 04:54:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC70222BED;
        Thu, 25 Jul 2019 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564044852;
        bh=FX6hbzDrsLzkqie8rosOcXKkXDjGwyOHmt5CxextNoY=;
        h=Subject:To:From:Date:From;
        b=lh3vRdCMgp53K5TCXlRZ0ih5pc0MwDEcHbhL3UuVYVW+eiGJNn5mub7NnCiOTsPTy
         i3vIc7nyLirfw6aLyb3Jx2minTUW5zsiEZOGcjclkAcxEiFH5ruX2UuRACcgSu0TYt
         4aCgKQ+mlNZ2mGlf15qv8x4ZCLuuw2z/graPKiv4=
Subject: patch "usb: pci-quirks: Correct AMD PLL quirk detection" added to usb-linus
To:     ryan5544@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 10:54:08 +0200
Message-ID: <156404484816104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: pci-quirks: Correct AMD PLL quirk detection

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f3dccdaade4118070a3a47bef6b18321431f9ac6 Mon Sep 17 00:00:00 2001
From: Ryan Kennedy <ryan5544@gmail.com>
Date: Thu, 4 Jul 2019 11:35:28 -0400
Subject: usb: pci-quirks: Correct AMD PLL quirk detection

The AMD PLL USB quirk is incorrectly enabled on newer Ryzen
chipsets. The logic in usb_amd_find_chipset_info currently checks
for unaffected chipsets rather than affected ones. This broke
once a new chipset was added in e788787ef. It makes more sense
to reverse the logic so it won't need to be updated as new
chipsets are added. Note that the core of the workaround in
usb_amd_quirk_pll does correctly check the chipset.

Signed-off-by: Ryan Kennedy <ryan5544@gmail.com>
Fixes: e788787ef4f9 ("usb:xhci:Add quirk for Certain failing HP keyboard on reset after resume")
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20190704153529.9429-2-ryan5544@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/pci-quirks.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 3ce71cbfbb58..ad05c27b3a7b 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -205,7 +205,7 @@ int usb_amd_find_chipset_info(void)
 {
 	unsigned long flags;
 	struct amd_chipset_info info;
-	int ret;
+	int need_pll_quirk = 0;
 
 	spin_lock_irqsave(&amd_lock, flags);
 
@@ -219,21 +219,28 @@ int usb_amd_find_chipset_info(void)
 	spin_unlock_irqrestore(&amd_lock, flags);
 
 	if (!amd_chipset_sb_type_init(&info)) {
-		ret = 0;
 		goto commit;
 	}
 
-	/* Below chipset generations needn't enable AMD PLL quirk */
-	if (info.sb_type.gen == AMD_CHIPSET_UNKNOWN ||
-			info.sb_type.gen == AMD_CHIPSET_SB600 ||
-			info.sb_type.gen == AMD_CHIPSET_YANGTZE ||
-			(info.sb_type.gen == AMD_CHIPSET_SB700 &&
-			info.sb_type.rev > 0x3b)) {
+	switch (info.sb_type.gen) {
+	case AMD_CHIPSET_SB700:
+		need_pll_quirk = info.sb_type.rev <= 0x3B;
+		break;
+	case AMD_CHIPSET_SB800:
+	case AMD_CHIPSET_HUDSON2:
+	case AMD_CHIPSET_BOLTON:
+		need_pll_quirk = 1;
+		break;
+	default:
+		need_pll_quirk = 0;
+		break;
+	}
+
+	if (!need_pll_quirk) {
 		if (info.smbus_dev) {
 			pci_dev_put(info.smbus_dev);
 			info.smbus_dev = NULL;
 		}
-		ret = 0;
 		goto commit;
 	}
 
@@ -252,7 +259,7 @@ int usb_amd_find_chipset_info(void)
 		}
 	}
 
-	ret = info.probe_result = 1;
+	need_pll_quirk = info.probe_result = 1;
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
 
 commit:
@@ -263,7 +270,7 @@ int usb_amd_find_chipset_info(void)
 
 		/* Mark that we where here */
 		amd_chipset.probe_count++;
-		ret = amd_chipset.probe_result;
+		need_pll_quirk = amd_chipset.probe_result;
 
 		spin_unlock_irqrestore(&amd_lock, flags);
 
@@ -277,7 +284,7 @@ int usb_amd_find_chipset_info(void)
 		spin_unlock_irqrestore(&amd_lock, flags);
 	}
 
-	return ret;
+	return need_pll_quirk;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
 
-- 
2.22.0


