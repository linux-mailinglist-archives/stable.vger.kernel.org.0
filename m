Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC88D490D55
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiAQRCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbiAQRBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DD9B81147;
        Mon, 17 Jan 2022 17:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2320AC36AE7;
        Mon, 17 Jan 2022 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438872;
        bh=79AneH/7hOkzkO4EM8/ZunoSg5Rcp9kmkH4jvoJ25uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtzOrBjW+w2LZtAbwJevsfW2ZEmGiwNNEqEBWcZKdiEynpI+waHdIg0DWhQAd9GVq
         k/fULtADmerAFzOAKtromJUYVhGcuDBWz1Fr4v4KOJd2hnwPRsB3kyzCn1VFvO2EYX
         XZGKYmwIgTSQgvtqVchbt+Jxg2HqDyfHePgikcwzpX4xNAb1jymDx9QVACeZZ6WrLt
         cxFdOwfJCKJVDoL/6AbMDPl96hfvcZnm9hrMPZiroTU7P20tDECLYIeItUipDMUbXX
         XEHMfDnt0uOFlI6B0lmTb2HfDsbxxgsi1Gz+68HC6+Ql3RGsD+R/Hm2Pn7/5It7rnN
         Aff1l8jF7ptpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        obitton@habana.ai, kelbaz@habana.ai, ynudelman@habana.ai,
        fkassabri@habana.ai
Subject: [PATCH AUTOSEL 5.16 48/52] habanalabs: skip read fw errors if dynamic descriptor invalid
Date:   Mon, 17 Jan 2022 11:58:49 -0500
Message-Id: <20220117165853.1470420-48-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ohad Sharabi <osharabi@habana.ai>

[ Upstream commit 4fac990f604e6c10538026835a8a30f3c1b6fcf5 ]

Reporting FW errors involves reading of the error registers.

In case we have a corrupted FW descriptor we cannot do that since the
dynamic scratchpad is potentially corrupted as well and may cause kernel
crush when attempting access to a corrupted register offset.

Signed-off-by: Ohad Sharabi <osharabi@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c | 17 +++++++++++++++--
 drivers/misc/habanalabs/common/habanalabs.h  |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 4e68fb9d2a6bd..67a0be4573710 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -1703,6 +1703,9 @@ static int hl_fw_dynamic_validate_descriptor(struct hl_device *hdev,
 		return rc;
 	}
 
+	/* here we can mark the descriptor as valid as the content has been validated */
+	fw_loader->dynamic_loader.fw_desc_valid = true;
+
 	return 0;
 }
 
@@ -1759,7 +1762,13 @@ static int hl_fw_dynamic_read_and_validate_descriptor(struct hl_device *hdev,
 		return rc;
 	}
 
-	/* extract address copy the descriptor from */
+	/*
+	 * extract address to copy the descriptor from
+	 * in addition, as the descriptor value is going to be over-ridden by new data- we mark it
+	 * as invalid.
+	 * it will be marked again as valid once validated
+	 */
+	fw_loader->dynamic_loader.fw_desc_valid = false;
 	src = hdev->pcie_bar[region->bar_id] + region->offset_in_bar +
 							response->ram_offset;
 	memcpy_fromio(fw_desc, src, sizeof(struct lkd_fw_comms_desc));
@@ -2247,6 +2256,9 @@ static int hl_fw_dynamic_init_cpu(struct hl_device *hdev,
 	dev_info(hdev->dev,
 		"Loading firmware to device, may take some time...\n");
 
+	/* initialize FW descriptor as invalid */
+	fw_loader->dynamic_loader.fw_desc_valid = false;
+
 	/*
 	 * In this stage, "cpu_dyn_regs" contains only LKD's hard coded values!
 	 * It will be updated from FW after hl_fw_dynamic_request_descriptor().
@@ -2333,7 +2345,8 @@ static int hl_fw_dynamic_init_cpu(struct hl_device *hdev,
 	return 0;
 
 protocol_err:
-	fw_read_errors(hdev, le32_to_cpu(dyn_regs->cpu_boot_err0),
+	if (fw_loader->dynamic_loader.fw_desc_valid)
+		fw_read_errors(hdev, le32_to_cpu(dyn_regs->cpu_boot_err0),
 				le32_to_cpu(dyn_regs->cpu_boot_err1),
 				le32_to_cpu(dyn_regs->cpu_boot_dev_sts0),
 				le32_to_cpu(dyn_regs->cpu_boot_dev_sts1));
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index a2002cbf794b5..ba0965667b182 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -1010,6 +1010,7 @@ struct fw_response {
  * @image_region: region to copy the FW image to
  * @fw_image_size: size of FW image to load
  * @wait_for_bl_timeout: timeout for waiting for boot loader to respond
+ * @fw_desc_valid: true if FW descriptor has been validated and hence the data can be used
  */
 struct dynamic_fw_load_mgr {
 	struct fw_response response;
@@ -1017,6 +1018,7 @@ struct dynamic_fw_load_mgr {
 	struct pci_mem_region *image_region;
 	size_t fw_image_size;
 	u32 wait_for_bl_timeout;
+	bool fw_desc_valid;
 };
 
 /**
-- 
2.34.1

