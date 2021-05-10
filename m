Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C28D378E73
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbhEJN3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344985AbhEJNA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 09:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 653C560FF2;
        Mon, 10 May 2021 12:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620651561;
        bh=YW0gp2j562g17FUJUir9sjnVdKqJ9kBGrJJTBX3qwtY=;
        h=Subject:To:From:Date:From;
        b=aLxj0Myyk1/jvwidHJRcn8BTO114w8WT1Xf5r/tcCQEhAJBsiUzsdZKE4RgwT3GuL
         V6/THnhsmmnzBcaLfOJCKxXCRtcxDvteevpZ8ewbw9E46gSKjvNFfGR6O+ej2Kce89
         R5VkrlWdmSGL0enxen05mKDKGVI22IZLwRguqjG8=
Subject: patch "usb: dwc3: imx8mp: fix error return code in dwc3_imx8mp_probe()" added to usb-linus
To:     thunder.leizhen@huawei.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, hulkci@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 14:59:11 +0200
Message-ID: <16206515515040@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: imx8mp: fix error return code in dwc3_imx8mp_probe()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0b2b149e918f6dddb4ea53615551bf7bc131f875 Mon Sep 17 00:00:00 2001
From: Zhen Lei <thunder.leizhen@huawei.com>
Date: Sat, 8 May 2021 09:53:10 +0800
Subject: usb: dwc3: imx8mp: fix error return code in dwc3_imx8mp_probe()

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210508015310.1627-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-imx8mp.c b/drivers/usb/dwc3/dwc3-imx8mp.c
index e9fced6f7a7c..756faa46d33a 100644
--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -167,6 +167,7 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 
 	dwc3_np = of_get_compatible_child(node, "snps,dwc3");
 	if (!dwc3_np) {
+		err = -ENODEV;
 		dev_err(dev, "failed to find dwc3 core child\n");
 		goto disable_rpm;
 	}
-- 
2.31.1


