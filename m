Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C51C1583
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgEAN3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgEAN3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B99720757;
        Fri,  1 May 2020 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339775;
        bh=nOOC4/cmUf7KfBHIyGKi9ABo4BI3gmd1MGEwGx+wxJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVa9L0m7x9X0PVQA+VaryL5ZpEKIXG4I6vM5q+MkZpgPmNSIiUDJ3rjWzIdw0irEs
         Gg2nrocV9S7cOwyQyKUqyNFkzPEsR9FBdCtemyXXM2QJ49W4KVnTiopjv/tiVrSBrY
         ltPmikNViY1pkTscUyQFw5QV1s4T89KQ4DzM2iZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.9 43/80] tpm/tpm_tis: Free IRQ if probing fails
Date:   Fri,  1 May 2020 15:21:37 +0200
Message-Id: <20200501131527.056773144@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit b160c94be5d2816b62c8ac338605668304242959 upstream.

Call disable_interrupts() if we have to revert to polling in order not to
unnecessarily reserve the IRQ for the life-cycle of the driver.

Cc: stable@vger.kernel.org # 4.5.x
Reported-by: Hans de Goede <hdegoede@redhat.com>
Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -329,6 +329,9 @@ static void disable_interrupts(struct tp
 	u32 intmask;
 	int rc;
 
+	if (priv->irq == 0)
+		return;
+
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
 		intmask = 0;
@@ -786,9 +789,12 @@ int tpm_tis_core_init(struct device *dev
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
-			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
+			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
 				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
+
+				disable_interrupts(chip);
+			}
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}


