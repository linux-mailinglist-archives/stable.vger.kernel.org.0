Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5808B66CB7D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbjAPROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234407AbjAPRNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58F44B75A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B0A61085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BB5C433EF;
        Mon, 16 Jan 2023 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888026;
        bh=94uJ3jRsrurtQ6mZKAJRf1XVxIMFT79cumgjZtyXg18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9VsJvQ5DRREXdgt5O8x4jHkKc5rLRstGiCVXxpb8PABDYWoUYIWiU/okPxWOVyIP
         EeZ59BlpcCknOAHyVrQWdEoFBhwUj4FWhrtNXgiVUI4Ue6dr5dPWpMf2YWIt/U/0+W
         AuO7goR22USMrrOa7qSylTJuTGM1WBdcEiXe1nAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.19 373/521] tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
Date:   Mon, 16 Jan 2023 16:50:35 +0100
Message-Id: <20230116154903.777399969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -680,12 +680,16 @@ static int crb_acpi_add(struct acpi_devi
 
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
@@ -693,7 +697,8 @@ static int crb_acpi_add(struct acpi_devi
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
 		priv->smc_func_id = crb_smc->smc_func_id;
@@ -704,17 +709,23 @@ static int crb_acpi_add(struct acpi_devi
 
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


