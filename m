Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56D67F3C2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406076AbfHBJw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406114AbfHBJw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:52:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46F82064A;
        Fri,  2 Aug 2019 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739578;
        bh=CvAtZ7/JRnG63T1pyC8Kx2yqW0V8Ya09m8JSUQl0kMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOpZGY6/I/33m2BnnN7wMmTviLPJcLVhgg1Tv/bQA8IktGIxD+rNOv11JIpgoykz7
         WSqRASYFqEe5Qlu1tYYPRiYdixRItV+H3pOQS8Ag4NxzQVXFYNJPh3wH8ivzbrrA3E
         PvHgoxU6ePQoVIJCB33LMr7+9ptidytUB9g7B494=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Kennedy <ryan5544@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.9 203/223] usb: pci-quirks: Correct AMD PLL quirk detection
Date:   Fri,  2 Aug 2019 11:37:08 +0200
Message-Id: <20190802092250.223779307@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Kennedy <ryan5544@gmail.com>

commit f3dccdaade4118070a3a47bef6b18321431f9ac6 upstream.

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
 drivers/usb/host/pci-quirks.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -187,7 +187,7 @@ int usb_amd_find_chipset_info(void)
 {
 	unsigned long flags;
 	struct amd_chipset_info info;
-	int ret;
+	int need_pll_quirk = 0;
 
 	spin_lock_irqsave(&amd_lock, flags);
 
@@ -201,21 +201,28 @@ int usb_amd_find_chipset_info(void)
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
 
@@ -234,7 +241,7 @@ int usb_amd_find_chipset_info(void)
 		}
 	}
 
-	ret = info.probe_result = 1;
+	need_pll_quirk = info.probe_result = 1;
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
 
 commit:
@@ -245,7 +252,7 @@ commit:
 
 		/* Mark that we where here */
 		amd_chipset.probe_count++;
-		ret = amd_chipset.probe_result;
+		need_pll_quirk = amd_chipset.probe_result;
 
 		spin_unlock_irqrestore(&amd_lock, flags);
 
@@ -259,7 +266,7 @@ commit:
 		spin_unlock_irqrestore(&amd_lock, flags);
 	}
 
-	return ret;
+	return need_pll_quirk;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
 


