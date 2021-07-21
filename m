Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4F3D0A04
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhGUHKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235784AbhGUHIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 03:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED02060FE9;
        Wed, 21 Jul 2021 07:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626853760;
        bh=6Asl3QT+PRrpOilNBawp0VvYVPf09OmnHP54p6lim2s=;
        h=Subject:To:From:Date:From;
        b=zCFGgvYy8bV0cwQmagJkE4/N/J2wBvk/J0icdraHFD/bvUbkgFHmH81+pEvLsH2aq
         5TZNElV5DcEHrat0qAxtylQXb/azBpBRUr53Rb1NCUbaxGsfL/X3/oTJqS7XAkq0Vp
         QGEX9dl1TQwARON7QL1Pumpy5hQgvWbDdglIISq4=
Subject: patch "usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe" added to usb-linus
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:49:12 +0200
Message-ID: <16268537526150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5b01248156bd75303e66985c351dee648c149979 Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Fri, 18 Jun 2021 22:14:41 +0800
Subject: usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe

Add missing pm_runtime_disable() when probe error out. It could
avoid pm_runtime implementation complains when removing and probing
again the driver.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210618141441.107817-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index a54d1cef17db..c0ca7144e512 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3853,6 +3853,7 @@ static int tegra_xudc_probe(struct platform_device *pdev)
 	return 0;
 
 free_eps:
+	pm_runtime_disable(&pdev->dev);
 	tegra_xudc_free_eps(xudc);
 free_event_ring:
 	tegra_xudc_free_event_ring(xudc);
-- 
2.32.0


