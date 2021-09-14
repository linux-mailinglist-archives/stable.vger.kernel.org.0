Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C53C40A98B
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhINIrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhINIrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFFC260F5B;
        Tue, 14 Sep 2021 08:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631609168;
        bh=ucuX2rPzdhzobeImFqhAR9VL8TrafGRrqoDV2tEO7Hk=;
        h=Subject:To:From:Date:From;
        b=vwv0+vE149h2Lzo0s5mp8Is2STkx17UwxGNmtF6qbs0j+2qUvuCGMssZzicHkpwGz
         qZ45V/tt1c9yjCE8EnxEv13+y7Q8jbh4LYVimBwn/GjWlJ2pRX2/IgmWnrqjJg8VSI
         bSBOPO7waG+Gh4YehuZziIrYXoVG20ipp25b4Ess=
Subject: patch "misc: genwqe: Fixes DMA mask setting" added to char-misc-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:46:06 +0200
Message-ID: <163160916666180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: genwqe: Fixes DMA mask setting

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8d753db5c227d1f403c4bc9cae4ae02c862413cd Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 8 Sep 2021 21:55:56 +0200
Subject: misc: genwqe: Fixes DMA mask setting

Commit 505b08777d78 ("misc: genwqe: Use dma_set_mask_and_coherent to simplify code")
changed the logic in the code.

Instead of a ||, a && should have been used to keep the code the same.

Fixes: 505b08777d78 ("misc: genwqe: Use dma_set_mask_and_coherent to simplify code")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/be49835baa8ba6daba5813b399edf6300f7fdbda.1631130862.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/genwqe/card_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index 2e1befbd1ad9..693981891870 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -1090,7 +1090,7 @@ static int genwqe_pci_setup(struct genwqe_dev *cd)
 
 	/* check for 64-bit DMA address supported (DAC) */
 	/* check for 32-bit DMA address supported (SAC) */
-	if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64)) ||
+	if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64)) &&
 	    dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		dev_err(&pci_dev->dev,
 			"err: neither DMA32 nor DMA64 supported\n");
-- 
2.33.0


