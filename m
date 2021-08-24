Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FAB3F67A4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbhHXRgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239512AbhHXRd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0586C61BA3;
        Tue, 24 Aug 2021 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824790;
        bh=ElZTbyKQCVzHhYltIz5Tp0a6wPDVCbM4AUuCHbnO7i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAo+ECWH3BQcr1OG5DXTHVXavsI1BbmYUTQp65BfnJbLjt+whhAcNBvWiOY2cpiPa
         RNZfSWSiK5yjmkG5DYAtUDA8K99FEDuDfD95OblbXZyYd1++GX7LdEN5Rz3Ukkil+J
         8mTmDNs/RdRvMUwpduxNgurmOlavwnChMRViX3DCmXBMNlRWNIvBPJrW36E4pczfNH
         Aw5S3wEuvvqJ1XAZDz+vNz6hwyET2v2dagC1OJSpPlEs1MI3v2p46mJHxPrm+zxKPB
         vS9OPKCITZlN8Gg16yKIQtmE+p8eB7RzbkrXhyKMDDU84y6yxSoJhDwSHqPYHf7aXO
         QxdOl9XG/09Ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 14/43] PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
Date:   Tue, 24 Aug 2021 13:05:45 -0400
Message-Id: <20210824170614.710813-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit d28d4ad2a1aef27458b3383725bb179beb8d015c upstream.

No point in using the raw write function from shutdown. Preparatory change
to introduce proper serialization for the msi_desc::masked cache.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.674391354@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 481f1a1884e6..b3977b4c51b6 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -919,7 +919,7 @@ void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	__pci_msi_desc_mask_irq(desc, mask, 0);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
-- 
2.30.2

