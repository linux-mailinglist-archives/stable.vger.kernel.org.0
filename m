Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6311861A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfLJLVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9802220663;
        Tue, 10 Dec 2019 11:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575976900;
        bh=/fDlO/a66fizSf3gYrDXhacAZbyCHeNXtIKiVXFS78M=;
        h=Subject:To:From:Date:From;
        b=PEGGjnZi+ORNXJpGS/DY+r/6r4fZ3Lw7wOm/Pb0gNr3NjPXFr3GeKYbiSAB56XPBH
         xhsPlFmEGp7ABgG7CrTkNAl0MzwpqweS4NRXzzm1ygC1gXc44Jlo7bTG78BxS42rG6
         Tmg8GaZD1nRNEL8iuG35mr9wqba/GQuVe9e2TaHE=
Subject: patch "usb: common: usb-conn-gpio: Don't log an error on probe deferral" added to usb-linus
To:     bryan.odonoghue@linaro.org, chunfeng.yun@mediatek.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        nkristam@nvidia.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 12:21:22 +0100
Message-ID: <157597688271231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: common: usb-conn-gpio: Don't log an error on probe deferral

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 59120962e4be4f72be537adb17da6881c4b3797c Mon Sep 17 00:00:00 2001
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date: Thu, 28 Nov 2019 13:43:57 +0000
Subject: usb: common: usb-conn-gpio: Don't log an error on probe deferral

This patch makes the printout of the error message for failing to get a
VBUS regulator handle conditional on the error code being something other
than -EPROBE_DEFER.

Deferral is a normal thing, we don't need an error message for this.

Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Nagarjuna Kristam <nkristam@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191128134358.3880498-2-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/usb-conn-gpio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index 87338f9eb5be..ed204cbb63ea 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -156,7 +156,8 @@ static int usb_conn_probe(struct platform_device *pdev)
 
 	info->vbus = devm_regulator_get(dev, "vbus");
 	if (IS_ERR(info->vbus)) {
-		dev_err(dev, "failed to get vbus\n");
+		if (PTR_ERR(info->vbus) != -EPROBE_DEFER)
+			dev_err(dev, "failed to get vbus\n");
 		return PTR_ERR(info->vbus);
 	}
 
-- 
2.24.0


