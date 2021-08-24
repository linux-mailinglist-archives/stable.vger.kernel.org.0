Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8189D3F680A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhHXRkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242239AbhHXRhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7C361BE4;
        Tue, 24 Aug 2021 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824873;
        bh=hrzJHtncBHjYCm1rGLwP+i7dFSkfENE8KwX4XFkKCwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyOXCLVMhQ6QDl8ccc8fPmfWBk6eBdklcAjfj0jQSN6ugZMG3IB2y7ip3XvnsCeJB
         nQW5SITIslen05FmURnkwr81Y4utsChl3a8boOKkSNvbU1UqcW8v+FRIpkz46MCYft
         08JIFuUfRhahLsY50+2oqxCb6+oS7TGeSzrb0U15BUhAy443WyAw2k9IQOuWN05rH0
         ye4NvoCllWw32lJN7ojjMqdr8eSE6qgzIogQR6VcJrJUkYu6cjXy3V6dteQTba0y6Q
         SAh7Zpr+AGh81etKSE5F4t+16ZSeN01Wh6dzBl0wtJSz/g2jPib80ee8fSI/mgxF+L
         iREkmMUm7AErQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 09/31] PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
Date:   Tue, 24 Aug 2021 13:07:21 -0400
Message-Id: <20210824170743.710957-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index 84ccff0f4b1b..e3865e274389 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -890,7 +890,7 @@ void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	__pci_msi_desc_mask_irq(desc, mask, 0);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
-- 
2.30.2

