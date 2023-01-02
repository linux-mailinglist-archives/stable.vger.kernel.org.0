Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2D65B12F
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbjABLbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjABLaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:30:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6391D257
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21D31B80D1C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88127C433D2;
        Mon,  2 Jan 2023 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658995;
        bh=c3VF0qu2U6pgL0vMGGsUgEruu4nCzsA2Fbd0aMKbZcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwj/96zIN7QlA1x38/eyRvgVFgvxb9fQ1OBFn1Q33Hs92hB1L0UXoWNFZq1EMSbLH
         TXWp35zR7IH7L/a//tJrkILNSn9aVAFDkK7g3Vfb1JVkMhuEhZLi6W6/cdOrAmth43
         EYFc0m3dlX011AvQ9Ffk/H0uM7aOMILwSgWnJC2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.0 71/74] tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
Date:   Mon,  2 Jan 2023 12:22:44 +0100
Message-Id: <20230102110555.119133771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

commit 37e90c374dd11cf4919c51e847c6d6ced0abc555 upstream.

In crb_acpi_add(), we get the TPM2 table to retrieve information
like start method, and then assign them to the priv data, so the
TPM2 table is not used after the init, should be freed, call
acpi_put_table() to fix the memory leak.

Fixes: 30fc8d138e91 ("tpm: TPM 2.0 CRB Interface")
Cc: stable@vger.kernel.org
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_crb.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -676,12 +676,16 @@ static int crb_acpi_add(struct acpi_devi
 
 	/* Should the FIFO driver handle this? */
 	sm = buf->start_method;
-	if (sm == ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+	if (sm == ACPI_TPM2_MEMORY_MAPPED) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC) {
 		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
@@ -689,7 +693,8 @@ static int crb_acpi_add(struct acpi_devi
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
 		priv->smc_func_id = crb_smc->smc_func_id;
@@ -700,17 +705,23 @@ static int crb_acpi_add(struct acpi_devi
 
 	rc = crb_map_io(device, priv, buf);
 	if (rc)
-		return rc;
+		goto out;
 
 	chip = tpmm_chip_alloc(dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
+		goto out;
+	}
 
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	return tpm_chip_register(chip);
+	rc = tpm_chip_register(chip);
+
+out:
+	acpi_put_table((struct acpi_table_header *)buf);
+	return rc;
 }
 
 static int crb_acpi_remove(struct acpi_device *device)


