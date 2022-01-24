Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9128499510
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392169AbiAXUue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44534 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389751AbiAXUm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280EAB810A8;
        Mon, 24 Jan 2022 20:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E5C340EA;
        Mon, 24 Jan 2022 20:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056972;
        bh=OXTutBZ56C4yn0cJKtTpgqY929mSXbUhpk4iRv6w/sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6HtfW2z4M9Bi4ikBp6RWA/icK72dSiR/le5LvmkKrbpRYhBuZb0YssC81cDoXPge
         09k0uN6qEikzjnW8L4dNHDYy10sveeicIZsOdSDzIGjav51IpD4YuEOMuc+1NNaub2
         8NWyrh/6x+WTC/rabxxxpl5zcWc+hOhW30nmu6uU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ohad Sharabi <osharabi@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 661/846] habanalabs: skip read fw errors if dynamic descriptor invalid
Date:   Mon, 24 Jan 2022 19:42:58 +0100
Message-Id: <20220124184123.865384707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 8d2568c63f19e..a8e683964ab03 100644
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
@@ -2239,6 +2248,9 @@ static int hl_fw_dynamic_init_cpu(struct hl_device *hdev,
 	dev_info(hdev->dev,
 		"Loading firmware to device, may take some time...\n");
 
+	/* initialize FW descriptor as invalid */
+	fw_loader->dynamic_loader.fw_desc_valid = false;
+
 	/*
 	 * In this stage, "cpu_dyn_regs" contains only LKD's hard coded values!
 	 * It will be updated from FW after hl_fw_dynamic_request_descriptor().
@@ -2325,7 +2337,8 @@ static int hl_fw_dynamic_init_cpu(struct hl_device *hdev,
 	return 0;
 
 protocol_err:
-	fw_read_errors(hdev, le32_to_cpu(dyn_regs->cpu_boot_err0),
+	if (fw_loader->dynamic_loader.fw_desc_valid)
+		fw_read_errors(hdev, le32_to_cpu(dyn_regs->cpu_boot_err0),
 				le32_to_cpu(dyn_regs->cpu_boot_err1),
 				le32_to_cpu(dyn_regs->cpu_boot_dev_sts0),
 				le32_to_cpu(dyn_regs->cpu_boot_dev_sts1));
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index bebebcb163ee8..dfcd87b98ca08 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -992,6 +992,7 @@ struct fw_response {
  * @image_region: region to copy the FW image to
  * @fw_image_size: size of FW image to load
  * @wait_for_bl_timeout: timeout for waiting for boot loader to respond
+ * @fw_desc_valid: true if FW descriptor has been validated and hence the data can be used
  */
 struct dynamic_fw_load_mgr {
 	struct fw_response response;
@@ -999,6 +1000,7 @@ struct dynamic_fw_load_mgr {
 	struct pci_mem_region *image_region;
 	size_t fw_image_size;
 	u32 wait_for_bl_timeout;
+	bool fw_desc_valid;
 };
 
 /**
-- 
2.34.1



