Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5712534A904
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhCZNwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhCZNvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:51:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFDE461A18;
        Fri, 26 Mar 2021 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616766706;
        bh=4ImJb7cuZTHS3H3tdDHD1gOBVoR0hMRzqPujBeTLelk=;
        h=Subject:To:From:Date:From;
        b=TdEgKuWjdOiVc7HtE3T999Ks7dn9an+99Ow70pT0dp+IDf9/N9D39hsX+S5cchLPm
         57awxF6C4lcVqTgG70GPD7Lzy4UdFFbNFjx1kXbH6GQBB0uDU8E+LTLKNKJ1OLUcJd
         fJQt+mYbTANOAFL1NkRzgklAtAGGzzc1rIEAOCa8=
Subject: patch "usb: xhci-mtk: fix broken streams issue on 0.96 xHCI" added to usb-linus
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 14:51:43 +0100
Message-ID: <161676670318692@kroah.com>
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
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6f978a30c9bb12dab1302d0f06951ee290f5e600 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Tue, 23 Mar 2021 15:02:46 +0800
Subject: usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

The MediaTek 0.96 xHCI controller on some platforms does not
support bulk stream even HCCPARAMS says supporting, due to MaxPSASize
is set a default value 1 by mistake, here use XHCI_BROKEN_STREAMS
quirk to fix it.

Fixes: 94a631d91ad3 ("usb: xhci-mtk: check hcc_params after adding primary hcd")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1616482975-17841-4-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index fe010cc61f19..2f27dc0d9c6b 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -397,6 +397,13 @@ static void xhci_mtk_quirks(struct device *dev, struct xhci_hcd *xhci)
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
@@ -548,7 +555,8 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
-- 
2.31.0


