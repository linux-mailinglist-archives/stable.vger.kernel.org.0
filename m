Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2995FD058
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiJMA0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiJMAY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA7EB769;
        Wed, 12 Oct 2022 17:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E77ABB81CD4;
        Thu, 13 Oct 2022 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD8DC433D6;
        Thu, 13 Oct 2022 00:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620388;
        bh=i/tyIrXc+85vJqgLz9At/S7sf9MFmgrR55j9ZPV02LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcvUEC5aNAAd1CQJyCRseEEMPAFyuJ8XtlaMR+kEtBLv96qwtPlTmZVApr/EPI67P
         VQNk+uTO6Qrp+0LsPYxjy7H1wBVZY64mCH1YQ2odRxoQF9jsb8/9LG1blqasriytTw
         VYl1lKdhzlMWiSiIr+jl3f7R1ihH9LC2ucjLDsKPIl1pBk/66Irv91/S9+axdzAu+Q
         5cq+VWR7/Q+Z4deylVPhobV5iAAuk3BIcoXQbfmjwariUa6yxUUICUsyOW1m2X/7o4
         mXWiT4mK22Pk7Odf7X2Q+zZONh6DZx2xSmsK1W6WIOddZL4ej4WtYeb7lIsEHR/IGw
         LxpUrhif8ly1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, ttayar@habana.ai, fkassabri@habana.ai,
        dliberman@habana.ai, rkatta@habana.ai
Subject: [PATCH AUTOSEL 5.19 25/63] habanalabs: ignore EEPROM errors during boot
Date:   Wed, 12 Oct 2022 20:17:59 -0400
Message-Id: <20221013001842.1893243-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
index 828a36af5b14..bb1b2d6213a5 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -521,6 +521,15 @@ static bool fw_report_boot_dev0(struct hl_device *hdev, u32 err_val,
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
index 15f91ae9de6e..d4858e636fa9 100644
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

