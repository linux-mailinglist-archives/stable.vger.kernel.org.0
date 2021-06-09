Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F13A0F42
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 11:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbhFIJGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237085AbhFIJGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C7261185;
        Wed,  9 Jun 2021 09:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623229478;
        bh=tl3YVmwKO5ccJ+CB1ua78L+84qsb0Ri5KkiShtAX/iI=;
        h=Subject:To:From:Date:From;
        b=Idhc61+5GB9EQADBEDvqcvZVRUbkJ3M/cxs4Wr5pwHXkbzFW6ToS1DFLEjs75BCWs
         rXUR1Xi/Rasese9pXUfxctzNUJTuv2WL3SDD/J1agulam1+5KtXcQHIfBkCavTKWHN
         AyRrVU1/BPoTOyv1T0PQcZZMrOKXuPDW2ZX6NA08=
Subject: patch "usb: misc: brcmstb-usb-pinmap: check return value after calling" added to usb-linus
To:     yangyingliang@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 11:04:36 +0200
Message-ID: <162322947610829@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: misc: brcmstb-usb-pinmap: check return value after calling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fbf649cd6d64d40c03c5397ecd6b1ae922ba7afc Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Sat, 5 Jun 2021 16:09:14 +0800
Subject: usb: misc: brcmstb-usb-pinmap: check return value after calling
 platform_get_resource()

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Fixes: 517c4c44b323 ("usb: Add driver to allow any GPIO to be used for 7211 USB signals")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210605080914.2057758-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/brcmstb-usb-pinmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/misc/brcmstb-usb-pinmap.c b/drivers/usb/misc/brcmstb-usb-pinmap.c
index b3cfe8666ea7..336653091e3b 100644
--- a/drivers/usb/misc/brcmstb-usb-pinmap.c
+++ b/drivers/usb/misc/brcmstb-usb-pinmap.c
@@ -263,6 +263,8 @@ static int __init brcmstb_usb_pinmap_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
 
 	pdata = devm_kzalloc(&pdev->dev,
 			     sizeof(*pdata) +
-- 
2.32.0


