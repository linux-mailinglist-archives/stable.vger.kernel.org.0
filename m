Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DB47F14F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbfHBJhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391655AbfHBJfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8589721773;
        Fri,  2 Aug 2019 09:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738530;
        bh=XF3cZDZu8ntzmwnHaerHD19bEpcYettuh5fuOk8PilQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxnQ/q2o7FbRYoVA/3bcpHAMBn2wP70d+TYxxxPb3z7i8Qp204U/BHq98yLkb73Lc
         wXjFuBOJgoVwtFtlYfZ2ttkIebnfWl99bhO1tAjncbyEkLx52vLOJtfIm6S9IEgI2I
         V/dVCgU1PAQgbQR+sZmDElTRQxEVSnV3Eb9s+uUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Kennedy <ryan5544@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.4 140/158] usb: pci-quirks: Correct AMD PLL quirk detection
Date:   Fri,  2 Aug 2019 11:29:21 +0200
Message-Id: <20190802092231.315745804@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
@@ -178,7 +178,7 @@ int usb_amd_find_chipset_info(void)
 {
 	unsigned long flags;
 	struct amd_chipset_info info;
-	int ret;
+	int need_pll_quirk = 0;
 
 	spin_lock_irqsave(&amd_lock, flags);
 
@@ -192,21 +192,28 @@ int usb_amd_find_chipset_info(void)
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
 
@@ -225,7 +232,7 @@ int usb_amd_find_chipset_info(void)
 		}
 	}
 
-	ret = info.probe_result = 1;
+	need_pll_quirk = info.probe_result = 1;
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
 
 commit:
@@ -236,7 +243,7 @@ commit:
 
 		/* Mark that we where here */
 		amd_chipset.probe_count++;
-		ret = amd_chipset.probe_result;
+		need_pll_quirk = amd_chipset.probe_result;
 
 		spin_unlock_irqrestore(&amd_lock, flags);
 
@@ -250,7 +257,7 @@ commit:
 		spin_unlock_irqrestore(&amd_lock, flags);
 	}
 
-	return ret;
+	return need_pll_quirk;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
 


