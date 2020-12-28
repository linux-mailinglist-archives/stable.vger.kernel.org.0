Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E02E3FEB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbgL1OqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408081AbgL1OqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:46:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F4C3208D5;
        Mon, 28 Dec 2020 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166696;
        bh=EaflN3Zddkr/XZyi54ceDo58s+Hxi75ADkf3nc+llr8=;
        h=Subject:To:From:Date:From;
        b=xXWMGNydFxpG1v8n/k4pp8SGTU9FSaoxhoaraOgghKo+ZMNF6tVz+qas72CMMTrsX
         lTqH6qqJp7gyj6+XIjsvdpaZvQ3PFCQ54SzfS+61JtakgzXW9D0i5K0kHt1AIXO/E1
         SYPme2YTPbHPAxNRsffTySqPPzxFwsKyiW+sGwyA=
Subject: patch "usb: chipidea: ci_hdrc_imx: add missing put_device() call in" added to usb-linus
To:     yukuai3@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:05 +0100
Message-ID: <16091667658336@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: ci_hdrc_imx: add missing put_device() call in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 83a43ff80a566de8718dfc6565545a0080ec1fb5 Mon Sep 17 00:00:00 2001
From: Yu Kuai <yukuai3@huawei.com>
Date: Tue, 17 Nov 2020 09:14:30 +0800
Subject: usb: chipidea: ci_hdrc_imx: add missing put_device() call in
 usbmisc_get_init_data()

if of_find_device_by_node() succeed, usbmisc_get_init_data() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: ef12da914ed6 ("usb: chipidea: imx: properly check for usbmisc")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201117011430.642589-1-yukuai3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 9e12152ea46b..8b7bc10b6e8b 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -139,9 +139,13 @@ static struct imx_usbmisc_data *usbmisc_get_init_data(struct device *dev)
 	misc_pdev = of_find_device_by_node(args.np);
 	of_node_put(args.np);
 
-	if (!misc_pdev || !platform_get_drvdata(misc_pdev))
+	if (!misc_pdev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	if (!platform_get_drvdata(misc_pdev)) {
+		put_device(&misc_pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
 	data->dev = &misc_pdev->dev;
 
 	/*
-- 
2.29.2


