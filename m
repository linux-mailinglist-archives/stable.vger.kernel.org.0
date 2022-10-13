Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD125FCF8D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJMAT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJMATD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C64E6F59;
        Wed, 12 Oct 2022 17:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB2C616B3;
        Thu, 13 Oct 2022 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404CFC433C1;
        Thu, 13 Oct 2022 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620231;
        bh=77z0dg3HSS+jMHLzl2YCjYnzzrWG2IAxMF4R7Ybb7JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvEeSnKPLg+GfVcc+FZvhS5LCyGBkLvdNOXCV1rskni7v1ToLV2eOZCdNebvU5c6i
         TmqTY+7Nqcx6OGM8J2W5qZAlpA3INKQ81Xbz7r0XdFkFqR8ntvq067LGFOHYyidwWm
         EknwcnmVDZXwDQrNBb1WwSVVgJgaiaYLYyr7v9XnEbG5uyz/ycRRHHJkCThPNm+n0Y
         bBtfx4UYEjG63dmsr/ytArf8e6FTt4wZ6LL/ksihZIDxqvxF7paBG8+w8HztegArPT
         SzhsWXaRHi65TqdJODr2iVElrFhbNvUK2t+4QoPk5518grTAtvqJcTfwwZHRqw9PVr
         YUMX0RjkGaD8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     farah kassabri <fkassabri@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        obitton@habana.ai, osharabi@habana.ai, ttayar@habana.ai,
        dliberman@habana.ai
Subject: [PATCH AUTOSEL 6.0 31/67] habanalabs: remove some f/w descriptor validations
Date:   Wed, 12 Oct 2022 20:15:12 -0400
Message-Id: <20221013001554.1892206-31-sashal@kernel.org>
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 6b9b9e244fdd0d6c5ee21b7b9d74282d9e43733a ]

To be forward-backward compatible with the firmware in the initial
communication during preboot, we need to remove the validation of the
header size. This will allow us to add more fields to the
lkd_fw_comms_desc structure.

Instead of the validation of the header size, we just print warning
when some mismatch in descriptor has been revealed, and we calculate
the CRC base on descriptor size reported by the firmware instead of
calculating it ourselves.

Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c | 43 +++++++-------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 4a3350ee87d3..b89a1e2c19d4 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -1863,50 +1863,36 @@ static int hl_fw_dynamic_validate_descriptor(struct hl_device *hdev,
 	u64 addr;
 	int rc;
 
-	if (le32_to_cpu(fw_desc->header.magic) != HL_COMMS_DESC_MAGIC) {
-		dev_err(hdev->dev, "Invalid magic for dynamic FW descriptor (%x)\n",
+	if (le32_to_cpu(fw_desc->header.magic) != HL_COMMS_DESC_MAGIC)
+		dev_warn(hdev->dev, "Invalid magic for dynamic FW descriptor (%x)\n",
 				fw_desc->header.magic);
-		return -EIO;
-	}
 
-	if (fw_desc->header.version != HL_COMMS_DESC_VER) {
-		dev_err(hdev->dev, "Invalid version for dynamic FW descriptor (%x)\n",
+	if (fw_desc->header.version != HL_COMMS_DESC_VER)
+		dev_warn(hdev->dev, "Invalid version for dynamic FW descriptor (%x)\n",
 				fw_desc->header.version);
-		return -EIO;
-	}
 
 	/*
-	 * calc CRC32 of data without header.
+	 * Calc CRC32 of data without header. use the size of the descriptor
+	 * reported by firmware, without calculating it ourself, to allow adding
+	 * more fields to the lkd_fw_comms_desc structure.
 	 * note that no alignment/stride address issues here as all structures
-	 * are 64 bit padded
+	 * are 64 bit padded.
 	 */
-	data_size = sizeof(struct lkd_fw_comms_desc) -
-					sizeof(struct comms_desc_header);
 	data_ptr = (u8 *)fw_desc + sizeof(struct comms_desc_header);
-
-	if (le16_to_cpu(fw_desc->header.size) != data_size) {
-		dev_err(hdev->dev,
-			"Invalid descriptor size 0x%x, expected size 0x%zx\n",
-				le16_to_cpu(fw_desc->header.size), data_size);
-		return -EIO;
-	}
+	data_size = le16_to_cpu(fw_desc->header.size);
 
 	data_crc32 = hl_fw_compat_crc32(data_ptr, data_size);
-
 	if (data_crc32 != le32_to_cpu(fw_desc->header.crc32)) {
-		dev_err(hdev->dev,
-			"CRC32 mismatch for dynamic FW descriptor (%x:%x)\n",
-					data_crc32, fw_desc->header.crc32);
+		dev_err(hdev->dev, "CRC32 mismatch for dynamic FW descriptor (%x:%x)\n",
+			data_crc32, fw_desc->header.crc32);
 		return -EIO;
 	}
 
 	/* find memory region to which to copy the image */
 	addr = le64_to_cpu(fw_desc->img_addr);
 	region_id = hl_get_pci_memory_region(hdev, addr);
-	if ((region_id != PCI_REGION_SRAM) &&
-			((region_id != PCI_REGION_DRAM))) {
-		dev_err(hdev->dev,
-			"Invalid region to copy FW image address=%llx\n", addr);
+	if ((region_id != PCI_REGION_SRAM) && ((region_id != PCI_REGION_DRAM))) {
+		dev_err(hdev->dev, "Invalid region to copy FW image address=%llx\n", addr);
 		return -EIO;
 	}
 
@@ -1923,8 +1909,7 @@ static int hl_fw_dynamic_validate_descriptor(struct hl_device *hdev,
 					fw_loader->dynamic_loader.fw_image_size,
 					region);
 	if (rc) {
-		dev_err(hdev->dev,
-			"invalid mem transfer request for FW image\n");
+		dev_err(hdev->dev, "invalid mem transfer request for FW image\n");
 		return rc;
 	}
 
-- 
2.35.1

