Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1A13A4ED
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgANKDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgANKDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22E224676;
        Tue, 14 Jan 2020 10:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996219;
        bh=8g2F3Zc9JgZ/H7HFIxGMego9Z+2EXBhh+2/JugzVMHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XyKsHHmgPOEIlGk+5i1ajiLg1Y52VEk8/XO0FDnVSxdA2tXT/qqiYKcaLsFq1XNN
         HUKnvP/2zeyZJNEotLATv7ka+/GLYr6l6V6ro1JLub7+46Zf8qL1HyN1snrJ9L6elW
         0VfF2lNYksWlKOVwz4cE9SfHdgQrH4qWNc0tBx4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoping Zhou <xiaoping.zhou@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 09/78] tpm: Revert "tpm_tis: reserve chip for duration of tpm_tis_core_init"
Date:   Tue, 14 Jan 2020 11:00:43 +0100
Message-Id: <20200114094353.846795149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 9550f210492c6f88415709002f42a9d15c0e6231 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -899,13 +899,13 @@ int tpm_tis_core_init(struct device *dev
 
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
@@ -914,21 +914,21 @@ int tpm_tis_core_init(struct device *dev
 
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
@@ -937,13 +937,13 @@ int tpm_tis_core_init(struct device *dev
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
@@ -977,9 +977,10 @@ int tpm_tis_core_init(struct device *dev
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
@@ -990,20 +991,18 @@ int tpm_tis_core_init(struct device *dev
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
+		goto out_err;
 
-	return 0;
-
-err_probe:
-	tpm_chip_stop(chip);
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
 
-err_start:
+	return 0;
+out_err:
 	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
 		chip->ops->clk_enable(chip, false);
 


