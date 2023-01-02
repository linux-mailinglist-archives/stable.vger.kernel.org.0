Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16C965B03D
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjABLDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjABLDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:03:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CCFC6A
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:03:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DCB160F30
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7CCC433D2;
        Mon,  2 Jan 2023 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672657423;
        bh=72if7TF+GiYvExmj9FC7911JtyLCWyCU1xlpTUKLg7w=;
        h=Subject:To:Cc:From:Date:From;
        b=ZTDPjPdUplD8D1BxyYQRApZkYR4gTV3xOqCWvNDSydKf33w/oNlQfbs0AaS7n+xxI
         7B+CCUqBImnpziYim1s9TFIqCJRkx00iVX9i+2We7h9qn5JeiT4XT2Lgbj9L/pZAmn
         AEaT2++yg+KACwOEgKFoVH6CtdYsNzG4gSHnvRf4=
Subject: FAILED: patch "[PATCH] tpm: tpm_crb: Add the missed acpi_put_table() to fix memory" failed to apply to 4.9-stable tree
To:     guohanjun@huawei.com, jarkko@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 12:03:40 +0100
Message-ID: <16726574202790@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

37e90c374dd1 ("tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak")
627448e85c76 ("tpm: separate cmd_ready/go_idle from runtime_pm")
e2fb992d82c6 ("tpm: add retry logic")
65520d46a4ad ("tpm: tpm-interface: fix tpm_transmit/_cmd kdoc")
888d867df441 ("tpm: cmd_ready command can be issued only after granting locality")
b3e958ce4c58 ("tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()")
c382babccba2 ("tpm_tis: Move ilb_base_addr to tpm_tis_data")
fd3ec3663718 ("tpm: move tpm_eventlog.h outside of drivers folder")
cf151a9a44d5 ("tpm: reduce tpm polling delay in tpm_tis_core")
87cdfdd19aef ("tpm: move wait_for_tpm_stat() to respective driver files")
f5357413dbaa ("tpm/tpm_crb: Use start method value from ACPI table directly")
9f3fc7bcddcb ("tpm: replace msleep() with  usleep_range() in TPM 1.2/2.0 generic drivers")
bc397085ca97 ("tpm_tis: make ilb_base_addr static")
5e572cab92f0 ("tpm: Enable CLKRUN protocol for Braswell systems")
f128480f3916 ("tpm/tpm_crb: fix priv->cmd_size initialisation")
e24dd9ee5399 ("Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 37e90c374dd11cf4919c51e847c6d6ced0abc555 Mon Sep 17 00:00:00 2001
From: Hanjun Guo <guohanjun@huawei.com>
Date: Thu, 17 Nov 2022 19:23:41 +0800
Subject: [PATCH] tpm: tpm_crb: Add the missed acpi_put_table() to fix memory
 leak

In crb_acpi_add(), we get the TPM2 table to retrieve information
like start method, and then assign them to the priv data, so the
TPM2 table is not used after the init, should be freed, call
acpi_put_table() to fix the memory leak.

Fixes: 30fc8d138e91 ("tpm: TPM 2.0 CRB Interface")
Cc: stable@vger.kernel.org
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 18606651d1aa..5bfb00fc19cf 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -676,12 +676,16 @@ static int crb_acpi_add(struct acpi_device *device)
 
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
@@ -689,7 +693,8 @@ static int crb_acpi_add(struct acpi_device *device)
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
 		priv->smc_func_id = crb_smc->smc_func_id;
@@ -700,17 +705,23 @@ static int crb_acpi_add(struct acpi_device *device)
 
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

