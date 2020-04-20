Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9BD1B0FF9
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 17:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDTP02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 11:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgDTP01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 11:26:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15B7F20575;
        Mon, 20 Apr 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587396387;
        bh=R/OjnI3AgLVX6PJCaOcKQd+4it4sSbLEk2jYrYRBHdM=;
        h=Subject:To:From:Date:From;
        b=t0WuQ/DzDVgw1qDSt3KzUmz5LIaeByazvVeOyCpxUuYuax+9stZStfJkwJJlIaXNU
         D30jEeTi71ikOTuKloo32jnWfGsmvo0gKxXx0vky8qu7O7oRw2dyAuVb0EYHRYlCg4
         BQplQ5FKbDbLTScrBplmBjiXDop523VoADwPg7do=
Subject: patch "mei: me: fix irq number stored in hw struct" added to char-misc-linus
To:     ben@b1c1l1.com, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 17:26:25 +0200
Message-ID: <158739638523989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: fix irq number stored in hw struct

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fec874a81b3ec280b91034d892a432fc71fd1522 Mon Sep 17 00:00:00 2001
From: Benjamin Lee <ben@b1c1l1.com>
Date: Fri, 17 Apr 2020 11:45:38 -0700
Subject: mei: me: fix irq number stored in hw struct

Commit 261b3e1f2a01 ("mei: me: store irq number in the hw struct.")
stores the irq number in the hw struct before MSI is enabled.  This
caused a regression for mei_me_synchronize_irq() waiting for the wrong
irq number.  On my laptop this causes a hang on shutdown.  Fix the issue
by storing the irq number after enabling MSI.

Fixes: 261b3e1f2a01 ("mei: me: store irq number in the hw struct.")
Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200417184538.349550-1-ben@b1c1l1.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/pci-me.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 3d21c38e2dbb..0c390fe421ad 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -203,11 +203,12 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	hw = to_me_hw(dev);
 	hw->mem_addr = pcim_iomap_table(pdev)[0];
-	hw->irq = pdev->irq;
 	hw->read_fws = mei_me_read_fws;
 
 	pci_enable_msi(pdev);
 
+	hw->irq = pdev->irq;
+
 	 /* request and enable interrupt */
 	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_ONESHOT : IRQF_SHARED;
 
-- 
2.26.1


