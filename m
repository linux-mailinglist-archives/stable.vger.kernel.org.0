Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9721A5F7B
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 19:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgDLRKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 13:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgDLRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 13:10:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F17AC0A3BF9;
        Sun, 12 Apr 2020 10:04:22 -0700 (PDT)
IronPort-SDR: 7LuXZj+dZEiceUCK23Pi75vIRpBaYJzdgXmuW9+ZwiRqt7GXnucH6eKa+2gv0c4wUuo5AEzU65
 KyrtoDeCfcVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 10:04:22 -0700
IronPort-SDR: DTTdKPJHO0uXGagxqHZl2vgjFStjmywwfVSPECr7jUaNvuTE4PuiP7PhBzKK+tCJhqa2W1kmBw
 ICtY9IPRFwPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,375,1580803200"; 
   d="scan'208";a="298228946"
Received: from apresura-mobl.ger.corp.intel.com (HELO localhost) ([10.252.61.246])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2020 10:04:19 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm/tpm_tis: Free IRQ if probing fails
Date:   Sun, 12 Apr 2020 20:04:12 +0300
Message-Id: <20200412170412.324200-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call devm_free_irq() if we have to revert to polling in order not to
unnecessarily reserve the IRQ for the life-cycle of the driver.

Cc: stable@vger.kernel.org # 4.5.x
Reported-by: Hans de Goede <hdegoede@redhat.com>
Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 27c6ca031e23..ae6868e7b696 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1062,9 +1062,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
-			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
+			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
 				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
+				devm_free_irq(chip->dev.parent, priv->irq,
+					      chip);
+			}
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}
-- 
2.25.1

