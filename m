Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF9D38086C
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhENL11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENL10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 07:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3E7613DE;
        Fri, 14 May 2021 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620991574;
        bh=7QtyVIDfoawf4qBOgX5SGptvpTEoU6JQvinvzeubx+w=;
        h=Subject:To:From:Date:From;
        b=lzB1k4yfQp8qtlPjYMWklCAGvK3TPwM0Nvpj6VOZzpNm3OnxqAfW3BsigWpS3l8kv
         H1sIbMkPb8evGiJfdCmanZ81tOKl4Jfk76gVCKuVKvxQM2d/6I+R+6Z0Gp+gE2ZA15
         XkQCi+LmhbJIKQjI0IUSx3IK+5vW1f+FiKd774Ys=
Subject: patch "uio/uio_pci_generic: fix return value changed in refactoring" added to char-misc-linus
To:     martin.agren@gmail.com, gregkh@linuxfoundation.org, mst@redhat.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 13:26:12 +0200
Message-ID: <1620991572249187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    uio/uio_pci_generic: fix return value changed in refactoring

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 156ed0215ef365604f2382d5164c36d3a1cfd98f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Martin=20=C3=85gren?= <martin.agren@gmail.com>
Date: Thu, 22 Apr 2021 21:22:40 +0200
Subject: uio/uio_pci_generic: fix return value changed in refactoring
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit ef84928cff58 ("uio/uio_pci_generic: use device-managed function
equivalents") was able to simplify various error paths thanks to no
longer having to clean up on the way out. Some error paths were dropped,
others were simplified. In one of those simplifications, the return
value was accidentally changed from -ENODEV to -ENOMEM. Restore the old
return value.

Fixes: ef84928cff58 ("uio/uio_pci_generic: use device-managed function equivalents")
Cc: stable <stable@vger.kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Martin Ågren <martin.agren@gmail.com>
Link: https://lore.kernel.org/r/20210422192240.1136373-1-martin.agren@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index c7d681fef198..3bb0b0075467 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -82,7 +82,7 @@ static int probe(struct pci_dev *pdev,
 	}
 
 	if (pdev->irq && !pci_intx_mask_supported(pdev))
-		return -ENOMEM;
+		return -ENODEV;
 
 	gdev = devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
 	if (!gdev)
-- 
2.31.1


