Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1021BC91B
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgD1Sim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729936AbgD1Sij (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:38:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5E920575;
        Tue, 28 Apr 2020 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099119;
        bh=aLkelBpeaUGa3Ws4vfD7/WVsuk/HkvmPey6pJ3eLsJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAChhUM6utFDBRW3fT9jUOhttJVLCZNV0wc0Uf+6N5T/KjUU+Y/e/YnIRafVLo+vK
         +Zu+PHT4X3Ozn37ra511qjRJPNLqS3wbLbTYo25lLU1tTq8uQnf+ZdbtaKnOLqUygZ
         TWfxQzy+pZysq8j15JfnSUCStExVjjUx3XQDC1pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.19 099/131] tpm/tpm_tis: Free IRQ if probing fails
Date:   Tue, 28 Apr 2020 20:25:11 +0200
Message-Id: <20200428182237.557113757@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
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
@@ -437,6 +437,9 @@ static void disable_interrupts(struct tp
 	u32 intmask;
 	int rc;
 
+	if (priv->irq == 0)
+		return;
+
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
 		intmask = 0;
@@ -984,9 +987,12 @@ int tpm_tis_core_init(struct device *dev
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


