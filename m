Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A3C3ED6AB
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhHPNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239073AbhHPNUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD0763274;
        Mon, 16 Aug 2021 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119770;
        bh=eunlG11KxHgVjrAj/cRgOPvltDaU9STbSoCRUEWx4V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZIAB9ZuihnRG1/XrRmMh7ElU0W+iHOho5nHHusyneKJX39++x3ZgMlrJTXkriDwp
         Zcwvr0dmXj4ZDlCWYEK+AyBCF2oLxkfS20wR5lk1VxLK3KYBwQ+6emfH3gXQiKO789
         ei2dl0+lvkPuF/X8h1/3iyqt/DcsUfV3iW6AeC94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.13 134/151] PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
Date:   Mon, 16 Aug 2021 15:02:44 +0200
Message-Id: <20210816125448.471036661@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -961,7 +961,7 @@ static void pci_msi_shutdown(struct pci_
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	__pci_msi_desc_mask_irq(desc, mask, 0);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion IRQ */
 	dev->irq = desc->msi_attrib.default_irq;


