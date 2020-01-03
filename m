Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D681412FF1F
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 00:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgACX3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 18:29:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:56694 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgACX3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 18:29:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 15:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,392,1571727600"; 
   d="scan'208";a="216899761"
Received: from hkarray-mobl.ger.corp.intel.com (HELO localhost) ([10.252.22.101])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jan 2020 15:29:47 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoping Zhou <xiaoping.zhou@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH for-linus-v5.5-rc6 1/3] tpm: Revert "tpm_tis: reserve chip for duration of tpm_tis_core_init"
Date:   Sat,  4 Jan 2020 01:29:32 +0200
Message-Id: <20200103232935.11314-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200103232935.11314-1-jarkko.sakkinen@linux.intel.com>
References: <20200103232935.11314-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Revert a commit, which was included in Linux v5.5-rc3 because it did not
properly fix the issues it was supposed to fix.

Fixes: 21df4a8b6018 ("tpm_tis: reserve chip for duration of tpm_tis_core_init")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205935
Cc: stable@vger.kernel.org
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 35 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index bb0343ffd235..8af2cee1a762 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -978,13 +978,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
-		goto err_start;
+		goto out_err;
 	}
 
 	/* Take control of the TPM's interrupt hardware and shut it off */
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
-		goto err_start;
+		goto out_err;
 
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
@@ -993,21 +993,21 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 
 	rc = tpm_chip_start(chip);
 	if (rc)
-		goto err_start;
-
+		goto out_err;
 	rc = tpm2_probe(chip);
+	tpm_chip_stop(chip);
 	if (rc)
-		goto err_probe;
+		goto out_err;
 
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
-		goto err_probe;
+		goto out_err;
 
 	priv->manufacturer_id = vendor;
 
 	rc = tpm_tis_read8(priv, TPM_RID(0), &rid);
 	if (rc < 0)
-		goto err_probe;
+		goto out_err;
 
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
@@ -1016,13 +1016,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	probe = probe_itpm(chip);
 	if (probe < 0) {
 		rc = -ENODEV;
-		goto err_probe;
+		goto out_err;
 	}
 
 	/* Figure out the capabilities */
 	rc = tpm_tis_read32(priv, TPM_INTF_CAPS(priv->locality), &intfcaps);
 	if (rc < 0)
-		goto err_probe;
+		goto out_err;
 
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
@@ -1056,9 +1056,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		if (tpm_get_timeouts(chip)) {
 			dev_err(dev, "Could not get TPM timeouts and durations\n");
 			rc = -ENODEV;
-			goto err_probe;
+			goto out_err;
 		}
 
+		tpm_chip_start(chip);
 		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
@@ -1069,20 +1070,18 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}
+		tpm_chip_stop(chip);
 	}
 
-	tpm_chip_stop(chip);
-
 	rc = tpm_chip_register(chip);
 	if (rc)
-		goto err_start;
-
-	return 0;
+		goto out_err;
 
-err_probe:
-	tpm_chip_stop(chip);
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
 
-err_start:
+	return 0;
+out_err:
 	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
 		chip->ops->clk_enable(chip, false);
 
-- 
2.20.1

