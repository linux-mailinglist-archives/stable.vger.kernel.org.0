Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0850D1ACCC6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgDPQH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:07:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:4097 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgDPQH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 12:07:56 -0400
IronPort-SDR: m7tWarmFe+1Mosl1bTmCMsboutHLJ+vjbRH3KsnnzvrVEr6HJ1jYNTJD2Dw4sicISrLRA+6CHg
 d7qcFhI6qmaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 09:07:55 -0700
IronPort-SDR: TNgaKRRtQ9LfEjhIISP0lM172r9WHdiZ+hjv6CM4z/xUS01YSx3wyOj+hmu4ZfPIhIrKvoGCNT
 g1+jK/L+8flw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="244436404"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by fmsmga007.fm.intel.com with ESMTP; 16 Apr 2020 09:07:53 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] tpm/tpm_tis: Free IRQ if probing fails
Date:   Thu, 16 Apr 2020 19:07:50 +0300
Message-Id: <20200416160751.180791-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call disable_interrupts() if we have to revert to polling in order not to
unnecessarily reserve the IRQ for the life-cycle of the driver.

Cc: stable@vger.kernel.org # 4.5.x
Reported-by: Hans de Goede <hdegoede@redhat.com>
Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 27c6ca031e23..2435216bd10a 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -433,6 +433,9 @@ static void disable_interrupts(struct tpm_chip *chip)
 	u32 intmask;
 	int rc;
 
+	if (priv->irq == 0)
+		return;
+
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
 		intmask = 0;
@@ -1062,9 +1065,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
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
-- 
2.25.1

