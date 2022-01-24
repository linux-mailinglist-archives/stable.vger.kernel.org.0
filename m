Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7994999E6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456323AbiAXVik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454186AbiAXVb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82719B8123D;
        Mon, 24 Jan 2022 21:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BB1C340E4;
        Mon, 24 Jan 2022 21:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059915;
        bh=79AneH/7hOkzkO4EM8/ZunoSg5Rcp9kmkH4jvoJ25uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMOFjF6ckA/UcYmO5YQdwUq38yyfBd1is+M9TGWeq113CM29vRxi8aXLQLLyAqpH8
         y5mLdIthrWk8JC5D5FzGxoN3i7FhJnOkQsgy+UYTKF44Qh+1kqL4c+FzzAYO/SLzoY
         sJOJHv8BKblv6QGRtrqdRtyPDMX49AFTg5TZUdqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0778/1039] habanalabs: skip read fw errors if dynamic descriptor invalid
Date:   Mon, 24 Jan 2022 19:42:47 +0100
Message-Id: <20220124184151.444777961@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



