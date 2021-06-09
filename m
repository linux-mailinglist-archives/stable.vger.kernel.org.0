Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE34E3A1592
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 15:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhFIN2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 09:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232946AbhFIN2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 09:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB31613AE;
        Wed,  9 Jun 2021 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623245185;
        bh=szkmgf2zz14SCvlEGt46o1NLfvJbSEwtD4TkOmAowYU=;
        h=From:To:Cc:Subject:Date:From;
        b=se8StkjQwiJAZBzBDDeMVE7E3x1Y6MHeX44ztPnGN52jxo5vWIMYXGmapgxymaYxL
         FIavw3NvoHvAXfFj/S96ZuFO+woO+heY5rsLJDd/1jCDXSRSNnC7sxnLsOYxHHMX+g
         H8YXxReoPlq4ot8AVWh1o3u85FRhKsegtVm/V+LPbT4zXIm5/66OMm02x9ldFK0AoR
         RJVUu1C+/f8JH822joi156XN1hJKbLKFTWRjg5W/w9trfNz1Jg/+0cZ7tk61lpMP9x
         4rLPglT+BcbzQ2UYc4ZJDh0h7w5rhY8nYrV9sKvh9Vxhud3soJ5XmNg3wkI6T7KXVF
         f19kjbjZFjuMw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3] tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()
Date:   Wed,  9 Jun 2021 16:26:19 +0300
Message-Id: <20210609132619.45017-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do not tear down the system when getting invalid status from a TPM chip.
This can happen when panic-on-warn is used.

Instead, introduce TPM_TIS_INVALID_STATUS bitflag and use it to trigger
once the error reporting per chip. In addition, print out the value of
TPM_STS for improved forensics.

Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v3:
* torn -> tear
* A per chip flag TPM_TIS_INVALID_STATUS.

v2:
Dump also stack only once.

 drivers/char/tpm/tpm_tis_core.c | 25 ++++++++++++++++++-------
 drivers/char/tpm/tpm_tis_core.h |  3 ++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 55b9d3965ae1..69579efb247b 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -196,13 +196,24 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 		return 0;
 
 	if (unlikely((status & TPM_STS_READ_ZERO) != 0)) {
-		/*
-		 * If this trips, the chances are the read is
-		 * returning 0xff because the locality hasn't been
-		 * acquired.  Usually because tpm_try_get_ops() hasn't
-		 * been called before doing a TPM operation.
-		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		if  (!test_and_set_bit(TPM_TIS_INVALID_STATUS, &priv->flags)) {
+			/*
+			 * If this trips, the chances are the read is
+			 * returning 0xff because the locality hasn't been
+			 * acquired.  Usually because tpm_try_get_ops() hasn't
+			 * been called before doing a TPM operation.
+			 */
+			dev_err(&chip->dev, "invalid TPM_STS.x 0x%02x, dumping stack for forensics\n",
+				status);
+
+			/*
+			 * Dump stack for forensics, as invalid TPM_STS.x could be
+			 * potentially triggered by impaired tpm_try_get_ops() or
+			 * tpm_find_get_ops().
+			 */
+			dump_stack();
+		}
+
 		return 0;
 	}
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9b2d32a59f67..b2a3c6c72882 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -83,6 +83,7 @@ enum tis_defaults {
 
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
+	TPM_TIS_INVALID_STATUS		= BIT(1),
 };
 
 struct tpm_tis_data {
@@ -90,7 +91,7 @@ struct tpm_tis_data {
 	int locality;
 	int irq;
 	bool irq_tested;
-	unsigned int flags;
+	unsigned long flags;
 	void __iomem *ilb_base_addr;
 	u16 clkrun_enabled;
 	wait_queue_head_t int_queue;
-- 
2.31.1

