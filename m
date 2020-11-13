Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1592B1BE8
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 14:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKMNcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 08:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgKMNcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 08:32:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46EB822201;
        Fri, 13 Nov 2020 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605274322;
        bh=L34msDVMH/UyICR8J7xK7ljkdv2pkUMpkqYL84TdUas=;
        h=Subject:To:From:Date:From;
        b=yFj31NuSJ80SR5C+WuWhZyhBYZ+x4rMSjQQDLerbZgASLjJhAMKT4iakatTc4S5UZ
         D5tISjINhcGNdKTzUADhQHXv2auZm/5l2U/DgZrgTTB7o/nD6arpHOv4KvxoUFgPb9
         mOMUAOIEkURuoez/CVfqIcuxwTyQr0ovxtROsOmk=
Subject: patch "xhci: hisilicon: fix refercence leak in xhci_histb_probe" added to usb-linus
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Nov 2020 14:32:59 +0100
Message-ID: <1605274379153157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: hisilicon: fix refercence leak in xhci_histb_probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 76255470ffa2795a44032e8b3c1ced11d81aa2db Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Fri, 6 Nov 2020 20:22:21 +0800
Subject: xhci: hisilicon: fix refercence leak in xhci_histb_probe

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. We should decrease the usage count
whetever it succeeded or failed(maybe runtime of the device has
error, or device is in inaccessible state, or other error state).
If we do not call put operation to decrease the reference, it will
result in reference leak in xhci_histb_probe. Moreover, this
device cannot enter the idle state and always stay busy or other
non-idle state later. So we fixed it by jumping to error handling
branch.

Fixes: c508f41da0788 ("xhci: hisilicon: support HiSilicon STB xHCI host controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201106122221.2304528-1-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-histb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-histb.c b/drivers/usb/host/xhci-histb.c
index 5546e7e013a8..08369857686e 100644
--- a/drivers/usb/host/xhci-histb.c
+++ b/drivers/usb/host/xhci-histb.c
@@ -240,7 +240,7 @@ static int xhci_histb_probe(struct platform_device *pdev)
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
-		return ret;
+		goto disable_pm;
 
 	hcd = usb_create_hcd(driver, dev, dev_name(dev));
 	if (!hcd) {
-- 
2.29.2


