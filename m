Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85D212C934
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733280AbfL2SB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfL2R4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF09206DB;
        Sun, 29 Dec 2019 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642160;
        bh=bVQlczJ7jMd5MYKQymi1wHv05MZrOyQmM6o85fr2iY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZy/0RKp1YUt7O5s5iKCBT7oXmTp9W+4q0gIt7nkZn2FUxPxSoNEmjcuTssabk/sX
         v9NyqgrwQicSm2B3DM7roytBADsz2xVE9r7ZfVrlYm5oNaKbgZENmwhL/nFfZ4SMn/
         ETHlMjSHvI8sxNsR9FiJj0fw5qwpwfR2C1r0HH6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 5.4 365/434] tpm_tis: reserve chip for duration of tpm_tis_core_init
Date:   Sun, 29 Dec 2019 18:26:58 +0100
Message-Id: <20191229172726.217301407@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit 21df4a8b6018b842d4db181a8b24166006bad3cd upstream.

Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
issuing commands to the tpm during initialization, just reserve the
chip after wait_startup, and release it when we are ready to call
tpm_chip_register.

Cc: Christian Bundy <christianbundy@fraction.io>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -899,13 +899,13 @@ int tpm_tis_core_init(struct device *dev
 
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
-		goto out_err;
+		goto err_start;
 	}
 
 	/* Take control of the TPM's interrupt hardware and shut it off */
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
-		goto out_err;
+		goto err_start;
 
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
@@ -914,21 +914,21 @@ int tpm_tis_core_init(struct device *dev
 
 	rc = tpm_chip_start(chip);
 	if (rc)
-		goto out_err;
+		goto err_start;
+
 	rc = tpm2_probe(chip);
-	tpm_chip_stop(chip);
 	if (rc)
-		goto out_err;
+		goto err_probe;
 
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
-		goto out_err;
+		goto err_probe;
 
 	priv->manufacturer_id = vendor;
 
 	rc = tpm_tis_read8(priv, TPM_RID(0), &rid);
 	if (rc < 0)
-		goto out_err;
+		goto err_probe;
 
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
@@ -937,13 +937,13 @@ int tpm_tis_core_init(struct device *dev
 	probe = probe_itpm(chip);
 	if (probe < 0) {
 		rc = -ENODEV;
-		goto out_err;
+		goto err_probe;
 	}
 
 	/* Figure out the capabilities */
 	rc = tpm_tis_read32(priv, TPM_INTF_CAPS(priv->locality), &intfcaps);
 	if (rc < 0)
-		goto out_err;
+		goto err_probe;
 
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
@@ -977,10 +977,9 @@ int tpm_tis_core_init(struct device *dev
 		if (tpm_get_timeouts(chip)) {
 			dev_err(dev, "Could not get TPM timeouts and durations\n");
 			rc = -ENODEV;
-			goto out_err;
+			goto err_probe;
 		}
 
-		tpm_chip_start(chip);
 		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
@@ -991,18 +990,20 @@ int tpm_tis_core_init(struct device *dev
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}
-		tpm_chip_stop(chip);
 	}
 
+	tpm_chip_stop(chip);
+
 	rc = tpm_chip_register(chip);
 	if (rc)
-		goto out_err;
-
-	if (chip->ops->clk_enable != NULL)
-		chip->ops->clk_enable(chip, false);
+		goto err_start;
 
 	return 0;
-out_err:
+
+err_probe:
+	tpm_chip_stop(chip);
+
+err_start:
 	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
 		chip->ops->clk_enable(chip, false);
 


