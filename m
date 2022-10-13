Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344C25FCF80
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJMASj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJMAR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7B618C970;
        Wed, 12 Oct 2022 17:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA160616BC;
        Thu, 13 Oct 2022 00:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381D3C43143;
        Thu, 13 Oct 2022 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620219;
        bh=T7hqFLPNw77WgL9BSH5WpcQeDhmXrL3N8oRc5R7W9+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8sl+MpR5s70hIBobyi9KhqJN9YjGkUc97fZwtiCnKQFBrlRbNjPYoR4zIQrIsanK
         PCOLKA298KbJ160CNQh8iGJm0DCDlMXaPqLMpAIKcoFFHbMdjNb5Zrz0TUISFfJy+y
         Eilvxi56zbWEscqDCiZRpNT7WLTECX5eZGNFAKrofwYJr7Qbn8pHIgIeDN+y7tWwXH
         XkOK3/MGAUHauBp2/NgeMlMb0MsnO3QM9S2GKaomQQkivLj+T4POd4+uHjKf+ecUo5
         P0W/0+/OivW44y9hBTcY6V9b74ZIldF/h5Zrw7ty3rzo9U/jLdvc7T4PeUIEgGpDcg
         eN2LomMfjGx7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, ttayar@habana.ai, fkassabri@habana.ai,
        dliberman@habana.ai, rkatta@habana.ai
Subject: [PATCH AUTOSEL 6.0 25/67] habanalabs: ignore EEPROM errors during boot
Date:   Wed, 12 Oct 2022 20:15:06 -0400
Message-Id: <20221013001554.1892206-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit d155df4f628a5312a485235aa8cc5ba78e11ea65 ]

EEPROM errors reported by firmware are basically warnings and
should not fail the boot process.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c        | 9 +++++++++
 drivers/misc/habanalabs/include/common/hl_boot_if.h | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 608ca67527a5..4a3350ee87d3 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -581,6 +581,15 @@ static bool fw_report_boot_dev0(struct hl_device *hdev, u32 err_val,
 		dev_dbg(hdev->dev, "Device status0 %#x\n", sts_val);
 
 	/* All warnings should go here in order not to reach the unknown error validation */
+	if (err_val & CPU_BOOT_ERR0_EEPROM_FAIL) {
+		dev_warn(hdev->dev,
+			"Device boot warning - EEPROM failure detected, default settings applied\n");
+		/* This is a warning so we don't want it to disable the
+		 * device
+		 */
+		err_val &= ~CPU_BOOT_ERR0_EEPROM_FAIL;
+	}
+
 	if (err_val & CPU_BOOT_ERR0_DRAM_SKIPPED) {
 		dev_warn(hdev->dev,
 			"Device boot warning - Skipped DRAM initialization\n");
diff --git a/drivers/misc/habanalabs/include/common/hl_boot_if.h b/drivers/misc/habanalabs/include/common/hl_boot_if.h
index a3594119bc51..3e705355c9cc 100644
--- a/drivers/misc/habanalabs/include/common/hl_boot_if.h
+++ b/drivers/misc/habanalabs/include/common/hl_boot_if.h
@@ -34,6 +34,7 @@ enum cpu_boot_err {
 	CPU_BOOT_ERR_BINNING_FAIL = 19,
 	CPU_BOOT_ERR_TPM_FAIL = 20,
 	CPU_BOOT_ERR_TMP_THRESH_INIT_FAIL = 21,
+	CPU_BOOT_ERR_EEPROM_FAIL = 22,
 	CPU_BOOT_ERR_ENABLED = 31,
 	CPU_BOOT_ERR_SCND_EN = 63,
 	CPU_BOOT_ERR_LAST = 64 /* we have 2 registers of 32 bits */
@@ -115,6 +116,9 @@ enum cpu_boot_err {
  * CPU_BOOT_ERR0_TMP_THRESH_INIT_FAIL	Failed to set threshold for tmperature
  *					sensor.
  *
+ * CPU_BOOT_ERR_EEPROM_FAIL		Failed reading EEPROM data. Defaults
+ *					are used.
+ *
  * CPU_BOOT_ERR0_ENABLED		Error registers enabled.
  *					This is a main indication that the
  *					running FW populates the error
@@ -139,6 +143,7 @@ enum cpu_boot_err {
 #define CPU_BOOT_ERR0_BINNING_FAIL		(1 << CPU_BOOT_ERR_BINNING_FAIL)
 #define CPU_BOOT_ERR0_TPM_FAIL			(1 << CPU_BOOT_ERR_TPM_FAIL)
 #define CPU_BOOT_ERR0_TMP_THRESH_INIT_FAIL	(1 << CPU_BOOT_ERR_TMP_THRESH_INIT_FAIL)
+#define CPU_BOOT_ERR0_EEPROM_FAIL		(1 << CPU_BOOT_ERR_EEPROM_FAIL)
 #define CPU_BOOT_ERR0_ENABLED			(1 << CPU_BOOT_ERR_ENABLED)
 #define CPU_BOOT_ERR1_ENABLED			(1 << CPU_BOOT_ERR_ENABLED)
 
-- 
2.35.1

