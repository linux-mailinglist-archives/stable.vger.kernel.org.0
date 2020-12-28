Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094672E3FDF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506447AbgL1Op2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506455AbgL1Op2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:45:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00EC3208B6;
        Mon, 28 Dec 2020 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166687;
        bh=w0DIojGbE1hp/pG0hQ3sSlg3hzdeO92LpFb1eQ93VmU=;
        h=Subject:To:From:Date:From;
        b=xJBKB94k8QrGmBFgCD7tTNoIYH7s1tFueZX2/xTl/SWDl9tI+YYSzbb/MfgxfyWdP
         VeWHIMPNgZseu6Jd1BnmuCChUNTL+HyredxHEvjVqWbJ+c8Rt3XKi27Bc3xquo/H/R
         3ERWiSPBFbofHK4zStj4WdMVY62kejNloW2H1Uy8=
Subject: patch "USB: gadget: legacy: fix return error code in acm_ms_bind()" added to usb-linus
To:     yangyingliang@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:04 +0100
Message-ID: <1609166764185151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: legacy: fix return error code in acm_ms_bind()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c91d3a6bcaa031f551ba29a496a8027b31289464 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 17 Nov 2020 17:29:55 +0800
Subject: USB: gadget: legacy: fix return error code in acm_ms_bind()

If usb_otg_descriptor_alloc() failed, it need return ENOMEM.

Fixes: 578aa8a2b12c ("usb: gadget: acm_ms: allocate and init otg descriptor by otg capabilities")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201117092955.4102785-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/acm_ms.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/acm_ms.c b/drivers/usb/gadget/legacy/acm_ms.c
index 59be2d8417c9..e8033e5f0c18 100644
--- a/drivers/usb/gadget/legacy/acm_ms.c
+++ b/drivers/usb/gadget/legacy/acm_ms.c
@@ -200,8 +200,10 @@ static int acm_ms_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail_string_ids;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
-- 
2.29.2


