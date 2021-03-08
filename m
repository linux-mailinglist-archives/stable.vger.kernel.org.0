Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841A933109D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCHOSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhCHORs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:17:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E13956520A;
        Mon,  8 Mar 2021 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615213068;
        bh=5wbWB+8TbZEmIMZE1U70gtJxOH1Yfh2jIKRmH1LSm18=;
        h=Subject:To:From:Date:From;
        b=ssoUWlqnPw2w9zQnm6GVGw1OWmRVkB2fcXPOc+OkcJpB3Ypuq1KipD6g3dY4yfUTV
         iNO2SfiD6IPhnF2/0TqTKc+wIFPx3RaYkfpyS58kK/aidZoqpsybH/F9TjxftRePbd
         8MdQ5pOcp0WNcVElDwoQkIlnbam+L5GCcVnKf8pg=
Subject: patch "USB: gadget: udc: s3c2410_udc: fix return value check in" added to usb-linus
To:     weiyongjun1@huawei.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        hulkci@huawei.com, krzysztof.kozlowski@canonical.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 15:17:38 +0100
Message-ID: <161521305844172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: udc: s3c2410_udc: fix return value check in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6dac74b9a6ade89f0ee0166b7178b86fae27204f Mon Sep 17 00:00:00 2001
From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Fri, 5 Mar 2021 03:49:27 +0000
Subject: USB: gadget: udc: s3c2410_udc: fix return value check in
 s3c2410_udc_probe()

In case of error, the function devm_platform_ioremap_resource()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Fixes: 188db4435ac6 ("usb: gadget: s3c: use platform resources")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210305034927.3232386-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index f1ea51476add..1d3ebb07ccd4 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -1773,8 +1773,8 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	udc_info = dev_get_platdata(&pdev->dev);
 
 	base_addr = devm_platform_ioremap_resource(pdev, 0);
-	if (!base_addr) {
-		retval = -ENOMEM;
+	if (IS_ERR(base_addr)) {
+		retval = PTR_ERR(base_addr);
 		goto err_mem;
 	}
 
-- 
2.30.1


