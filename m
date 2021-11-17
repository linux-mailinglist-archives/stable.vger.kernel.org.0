Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8150B45481B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhKQOHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKQOHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:07:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEFFD6187F;
        Wed, 17 Nov 2021 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157879;
        bh=vTf+sLx4h49jXeZfejM/jQosw540yJjkx0GtCgWflrA=;
        h=Subject:To:From:Date:From;
        b=MxNax4uJi13s9gmnunQPd76/EFGKM8auEAqcL0UpJEt076BBMQhnXGSBc2FiOnXR/
         99MySeLQU48lDXmHTVnHzkqa/hajJcaZHbN3ie8BbqG269uvdeo7FCUncTr/fMio95
         9ZWEtlJtJ84PV94jy36pc6h9ssamP/oYAMD1mCpc=
Subject: patch "usb: dwc3: leave default DMA for PCI devices" added to usb-linus
To:     fabioaiuto83@gmail.com, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:04:28 +0100
Message-ID: <16371578689164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: leave default DMA for PCI devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 47ce45906ca9870cf5267261f155fb7c70307cf0 Mon Sep 17 00:00:00 2001
From: Fabio Aiuto <fabioaiuto83@gmail.com>
Date: Sat, 13 Nov 2021 15:29:59 +0100
Subject: usb: dwc3: leave default DMA for PCI devices

in case of a PCI dwc3 controller, leave the default DMA
mask. Calling of a 64 bit DMA mask breaks the driver on
cherrytrail based tablets like Cyberbook T116.

Fixes: 45d39448b4d0 ("usb: dwc3: support 64 bit DMA in platform driver")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hans De Goede <hdegoede@redhat.com>
Tested-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/20211113142959.27191-1-fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 643239d7d370..f4c09951b517 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1594,9 +1594,11 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	dwc3_get_properties(dwc);
 
-	ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
-	if (ret)
-		return ret;
+	if (!dwc->sysdev_is_parent) {
+		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
+		if (ret)
+			return ret;
+	}
 
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset))
-- 
2.34.0


