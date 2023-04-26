Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC256EF965
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbjDZR3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 13:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbjDZR3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 13:29:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617CF83FA;
        Wed, 26 Apr 2023 10:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F34BA63441;
        Wed, 26 Apr 2023 17:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EE7C433D2;
        Wed, 26 Apr 2023 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682530179;
        bh=4K/gOer+QGjqHMQJATlyIp1MBELParfSmv57SyLuFJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiE6OuWAUVo/BJELaCYkXpzLI5fIwkIjUNsI5JWP4YkDXwaw0vbheoPORQe/LagTY
         mydsXKJAo4YBMNqPHYuvAcytRwL9+/BxLg2x010umHTF3xIHtpcE+CnvpXPRYAKbMU
         FVlIRmrDyocQ+p6V22dj5XLnyNu+TtflM3d30Q/SYDcVPMxBn1sTwXu4eQn9AgpDM+
         m69nDO+ZqpzZ+2XNQmktq5wS2lG4pRsfOha7chFVSkrCeT7xh4kpUIdUGDiro7mnC5
         HDvThWf9vb5nzdODkNeBxAEWKDro4WC+4Y+d2v+pD7rnJS0DFLlu+AAiyjrL20LtGa
         CNmahOEFV4ISQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] tpm: Prevent hwrng from activating during resume
Date:   Wed, 26 Apr 2023 20:29:28 +0300
Message-Id: <20230426172928.3963287-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426172928.3963287-1-jarkko@kernel.org>
References: <20230426172928.3963287-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set TPM_CHIP_FLAG_SUSPENDED in tpm_pm_suspend() and reset in
tpm_pm_resume(). While the flag is set, tpm_hwrng() gives back zero bytes.
This prevents hwrng from racing during resume.

Cc: stable@vger.kernel.org
Fixes: 6e592a065d51 ("tpm: Move Linux RNG connection to hwrng")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm-chip.c      |  4 ++++
 drivers/char/tpm/tpm-interface.c | 10 ++++++++++
 include/linux/tpm.h              | 13 +++++++------
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 6fdfa65a00c3..6f5ee27aeda1 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -572,6 +572,10 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
 
+	/* Give back zero bytes, as TPM chip has not yet fully resumed: */
+	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED)
+		return 0;
+
 	return tpm_get_random(chip, data, max);
 }
 
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7e513b771832..0f941cb32eb1 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -412,6 +412,8 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 suspended:
+	chip->flags |= TPM_CHIP_FLAG_SUSPENDED;
+
 	if (rc)
 		dev_err(dev, "Ignoring error %d while suspending\n", rc);
 	return 0;
@@ -429,6 +431,14 @@ int tpm_pm_resume(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	chip->flags &= ~TPM_CHIP_FLAG_SUSPENDED;
+
+	/*
+	 * Guarantee that SUSPENDED is written last, so that hwrng does not
+	 * activate before the chip has been fully resumed.
+	 */
+	wmb();
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 4dc97b9f65fb..d7073dc45444 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -274,13 +274,14 @@ enum tpm2_cc_attrs {
 #define TPM_VID_ATML     0x1114
 
 enum tpm_chip_flags {
-	TPM_CHIP_FLAG_TPM2		= BIT(1),
-	TPM_CHIP_FLAG_IRQ		= BIT(2),
-	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
-	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
-	TPM_CHIP_FLAG_ALWAYS_POWERED	= BIT(5),
+	TPM_CHIP_FLAG_SUSPENDED			= BIT(0),
+	TPM_CHIP_FLAG_TPM2			= BIT(1),
+	TPM_CHIP_FLAG_IRQ			= BIT(2),
+	TPM_CHIP_FLAG_VIRTUAL			= BIT(3),
+	TPM_CHIP_FLAG_HAVE_TIMEOUTS		= BIT(4),
+	TPM_CHIP_FLAG_ALWAYS_POWERED		= BIT(5),
 	TPM_CHIP_FLAG_FIRMWARE_POWER_MANAGED	= BIT(6),
-	TPM_CHIP_FLAG_FIRMWARE_UPGRADE	= BIT(7),
+	TPM_CHIP_FLAG_FIRMWARE_UPGRADE		= BIT(7),
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
-- 
2.39.2

