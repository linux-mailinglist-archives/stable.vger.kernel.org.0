Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC693532D3
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 08:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhDCGbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 02:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232157AbhDCGbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Apr 2021 02:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F106113E;
        Sat,  3 Apr 2021 06:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617431482;
        bh=tlgzJtti31IIut1fPNqeSnNHVbHs9HMKKx/zeZv27cY=;
        h=Subject:To:From:Date:From;
        b=qjlVwQTzBx6ISumQSKRayxMQJhZxIc2owekEoBubilOGyV8eImHz7Hd6lfcR5ZXPF
         rgjbS1oNOh9iGRGyvCcsXSZfflfF8vRe3r5+3Zbxp4XQWZOlEWh75DB43DJI39ootD
         HSN4j7u1SdQ9uigsoxRTmQHPKczW9gj3cwsZy5a4=
Subject: patch "usb: xhci-mtk: fix broken streams issue on 0.96 xHCI" added to usb-next
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Apr 2021 08:30:47 +0200
Message-ID: <161743144773165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1f743c8749eacd906dd3ce402b7cd540bb69ad3e Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Wed, 31 Mar 2021 17:05:52 +0800
Subject: usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

The MediaTek 0.96 xHCI controller on some platforms does not
support bulk stream even HCCPARAMS says supporting, due to MaxPSASize
is set a default value 1 by mistake, here use XHCI_BROKEN_STREAMS
quirk to fix it.

Fixes: 94a631d91ad3 ("usb: xhci-mtk: check hcc_params after adding primary hcd")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1617181553-3503-3-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index c1bc40289833..4e3d53cc24f4 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -411,6 +411,13 @@ static void xhci_mtk_quirks(struct device *dev, struct xhci_hcd *xhci)
 	xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 	if (mtk->lpm_support)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+
+	/*
+	 * MTK xHCI 0.96: PSA is 1 by default even if doesn't support stream,
+	 * and it's 3 when support it.
+	 */
+	if (xhci->hci_version < 0x100 && HCC_MAX_PSA(xhci->hcc_params) == 4)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
 }
 
 /* called during probe() after chip reset completes */
@@ -572,7 +579,8 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
-- 
2.31.1


