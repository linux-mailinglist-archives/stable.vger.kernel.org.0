Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8110B1BCAC0
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgD1Sf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgD1Sf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7655B208E0;
        Tue, 28 Apr 2020 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098956;
        bh=Lyfl/MOteIG0m0E5CqO/jTwVMM3cqUchcghye7D9lCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQsGWtxZwIxG2ja9jK4Fvr3DXP5ox2JrpLVoy0AIxYdOMDg5dJK9RJcErIL/U6EdK
         NZ32L46omcGxluXffS589yGqKal0Pfpzy9rTOkZfjNC3LviWs9DanJo0TtPp0Q9yki
         xqiUhCK+6/d+WwNJd9sG9jkocVvuLg0BMPGVONqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.6 109/167] tpm/tpm_tis: Free IRQ if probing fails
Date:   Tue, 28 Apr 2020 20:24:45 +0200
Message-Id: <20200428182238.950853009@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -433,6 +433,9 @@ static void disable_interrupts(struct tp
 	u32 intmask;
 	int rc;
 
+	if (priv->irq == 0)
+		return;
+
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
 		intmask = 0;
@@ -1062,9 +1065,12 @@ int tpm_tis_core_init(struct device *dev
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


