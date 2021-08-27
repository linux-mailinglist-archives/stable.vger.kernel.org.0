Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86123F959B
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhH0Hya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 03:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244561AbhH0Hya (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 03:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED4860F92;
        Fri, 27 Aug 2021 07:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630050822;
        bh=4vVKTEzO3FAWpjQllLSWAU8CXFPgM7IImM4L+bNbNj8=;
        h=Subject:To:From:Date:From;
        b=hcRs+X+BMvM0bsSMWW3IgXkeJWlZc4ZmJZS1AzNGHySBeLKeD6plK3LtHQpgK5EvH
         9b8so1V5Erw1dI3QBheN4j5NQViIyMsVom8KBxHZwS8DQYUKysvwcHYLmnOGBNL9+L
         99eV9u2dQRDyXvRIoWdq2y3A3ULE5FUrprrJMOsc=
Subject: patch "usb: xhci-mtk: fix issue of out-of-bounds array access" added to usb-next
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stan.lu@mediatek.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 09:41:29 +0200
Message-ID: <1630050089137253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: fix issue of out-of-bounds array access

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From de5107f473190538a65aac7edea85209cd5c1a8f Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Tue, 17 Aug 2021 16:36:25 +0800
Subject: usb: xhci-mtk: fix issue of out-of-bounds array access

Bus bandwidth array access is based on esit, increase one
will cause out-of-bounds issue; for example, when esit is
XHCI_MTK_MAX_ESIT, will overstep boundary.

Fixes: 7c986fbc16ae ("usb: xhci-mtk: get the microframe boundary for ESIT")
Cc: <stable@vger.kernel.org>
Reported-by: Stan Lu <stan.lu@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1629189389-18779-5-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index cffcaf4dfa9f..0bb1a6295d64 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -575,10 +575,12 @@ static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
 	u32 boundary = sch_ep->esit;
 
 	if (sch_ep->sch_tt) { /* LS/FS with TT */
-		/* tune for CS */
-		if (sch_ep->ep_type != ISOC_OUT_EP)
-			boundary++;
-		else if (boundary > 1) /* normally esit >= 8 for FS/LS */
+		/*
+		 * tune for CS, normally esit >= 8 for FS/LS,
+		 * not add one for other types to avoid access array
+		 * out of boundary
+		 */
+		if (sch_ep->ep_type == ISOC_OUT_EP && boundary > 1)
 			boundary--;
 	}
 
-- 
2.32.0


