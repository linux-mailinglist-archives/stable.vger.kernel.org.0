Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5813E565E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhHJJI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238641AbhHJJIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE121C06179B;
        Tue, 10 Aug 2021 02:07:48 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:07:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586465;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBnbRB6ZqhttOwIP32a+aALmIVbZW9baNcVhJhWV10U=;
        b=mAW1LJwp/5E+H0v+i7Ov1cSq20eJBk/o5MN3Eg24mH32HBGWprQJMNh0BpO7pYM6FkitU0
        st3EXEiXMN96KxuGLr1chX92C5D2kTzN+icwNOwezVVU3Gi6cmG29KJ7OzAuzwKBGwkNMO
        N6CosaXATD5IjlVpdne68hWfPu8AFnAseOA2vSbBB4+3i/N8f+OytDPIXYBGmd5NODDO//
        mGYpq7UCKbbMTkcFkb2drFnu9ax/U/FrpgooysKCyuq6N2oCJRub+BerGb1hPsuwYagqIW
        qlgXU1siOXRzmc4cBboa2A/ugp5uvB2u8F5Queey0Qtz/9/qA6U567XlehPNRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586465;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBnbRB6ZqhttOwIP32a+aALmIVbZW9baNcVhJhWV10U=;
        b=qrFmVfvdox3btgGDdTtfz/LERTl2nhsh8kxEPyt52m56u+3DiSYqDUMl5rTmHOXyn0+cru
        BMGaQxQeBQ/pMiDQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.674391354@linutronix.de>
References: <20210729222542.674391354@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646442.395.12521943242895948959.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     d28d4ad2a1aef27458b3383725bb179beb8d015c
Gitweb:        https://git.kernel.org/tip/d28d4ad2a1aef27458b3383725bb179beb8d015c
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:46 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()

No point in using the raw write function from shutdown. Preparatory change
to introduce proper serialization for the msi_desc::masked cache.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.674391354@linutronix.de

---
 drivers/pci/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b3f5807..f0f7026 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -961,7 +961,7 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	__pci_msi_desc_mask_irq(desc, mask, 0);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion IRQ */
 	dev->irq = desc->msi_attrib.default_irq;
