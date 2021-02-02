Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6DC30CA79
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhBBSuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhBBSr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 13:47:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C3C64E11;
        Tue,  2 Feb 2021 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612291603;
        bh=ihdizbHbeWlHmUhQH5/JCu185esOrx4gXpKhw+fn3I8=;
        h=Subject:To:From:Date:From;
        b=EHnUFblVjzlhO+yRP+NUuwXwVgcvbNNFB+JDaZuVHGki7DEmMf4XmIkIgZZ3NHVCf
         Sg5KgaxQzGkU/U5nnCMaX7sTr08+nddaEchGrbZyfxNCjkHP5PvZeaFpqUk5XXJi7Q
         EXuo2DhftT+dyITR4f6fpwSZvXFeUnNc64T7+99w=
Subject: patch "usb: xhci-mtk: break loop when find the endpoint to drop" added to usb-linus
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        ikjn@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Feb 2021 19:46:41 +0100
Message-ID: <16122916014121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: break loop when find the endpoint to drop

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a50ea34d6dd00a12c9cd29cf7b0fa72816bffbcb Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Tue, 2 Feb 2021 16:38:24 +0800
Subject: usb: xhci-mtk: break loop when find the endpoint to drop

No need to check the following endpoints after finding the endpoint
wanted to drop.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Reported-by: Ikjoon Jang <ikjn@chromium.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1612255104-5363-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index dee8a329076d..b45e5bf08997 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -689,8 +689,10 @@ void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 	sch_bw = &sch_array[bw_index];
 
 	list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
-		if (sch_ep->ep == ep)
+		if (sch_ep->ep == ep) {
 			destroy_sch_ep(udev, sch_bw, sch_ep);
+			break;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_drop_ep_quirk);
-- 
2.30.0


