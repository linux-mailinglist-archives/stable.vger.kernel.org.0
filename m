Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75973592187
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiHNPhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241187AbiHNPg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9AF1EC7B;
        Sun, 14 Aug 2022 08:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFD660C8C;
        Sun, 14 Aug 2022 15:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41226C43144;
        Sun, 14 Aug 2022 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491108;
        bh=mhHmj7mUNqBlkY3zt+9evoaMWx3Yb08kfz20bxtaHbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Klf0Hbgf0g8cRv34EVmJF6cmZYwTO2tBuyeLdk17OdzrEep08/CDoaniLPMjCEGfe
         2kupRUZo0nUHooG0on4NCMBJct2nu5+hlEdQraBBk1gVLRUh0mRzLJOaC+ZVMSTy8W
         EnJZw430LtOPXRQGTzNAg5yYga/w+xdzII1M8cGTX2Yf+74boJX0GIAb+kyP5KWmz7
         7E+x41SM9Z0woWQuIDUwA9R8woeBJHVilim3MAdaSUT+1ww5Vo8g83HnxlMHZhafDg
         mlzkspkZTkDK9ZpqBMyd2DKHB5/kwOaVLR9/W8FXNIxfVAeTicG3XV1e6h1dCg5IJ0
         0ARPu5UHDkRtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tal Cohen <talcohen@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, obitton@habana.ai, ttayar@habana.ai,
        ynudelman@habana.ai, dliberman@habana.ai, fkassabri@habana.ai,
        dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 5.18 30/56] habanalabs/gaudi: invoke device reset from one code block
Date:   Sun, 14 Aug 2022 11:30:00 -0400
Message-Id: <20220814153026.2377377-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tal Cohen <talcohen@habana.ai>

[ Upstream commit be572e67dafbf8004d46a2c9d97338c107efb60e ]

In order to prepare the driver code for device reset event
notification, change the event handler function flow to call
device reset from one code block.

In addition, the commit fixes an issue that reset was performed
w/o checking the 'hard_reset_on_fw_event' state and w/o setting
the HL_DRV_RESET_DELAY flag.

Signed-off-by: Tal Cohen <talcohen@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 1c271edb9297..90b769114fea 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7942,10 +7942,10 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	struct gaudi_device *gaudi = hdev->asic_specific;
 	u64 data = le64_to_cpu(eq_entry->data[0]);
 	u32 ctl = le32_to_cpu(eq_entry->hdr.ctl);
-	u32 fw_fatal_err_flag = 0;
+	u32 fw_fatal_err_flag = 0, flags = 0;
 	u16 event_type = ((ctl & EQ_CTL_EVENT_TYPE_MASK)
 			>> EQ_CTL_EVENT_TYPE_SHIFT);
-	bool reset_required;
+	bool reset_required, reset_direct = false;
 	u8 cause;
 	int rc;
 
@@ -8033,7 +8033,8 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 			dev_err(hdev->dev, "reset required due to %s\n",
 				gaudi_irq_map_table[event_type].name);
 
-			hl_device_reset(hdev, 0);
+			reset_direct = true;
+			goto reset_device;
 		} else {
 			hl_fw_unmask_irq(hdev, event_type);
 		}
@@ -8055,7 +8056,8 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 			dev_err(hdev->dev, "reset required due to %s\n",
 				gaudi_irq_map_table[event_type].name);
 
-			hl_device_reset(hdev, 0);
+			reset_direct = true;
+			goto reset_device;
 		} else {
 			hl_fw_unmask_irq(hdev, event_type);
 		}
@@ -8194,12 +8196,17 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	return;
 
 reset_device:
-	if (hdev->asic_prop.fw_security_enabled)
-		hl_device_reset(hdev, HL_DRV_RESET_HARD
-					| HL_DRV_RESET_BYPASS_REQ_TO_FW
-					| fw_fatal_err_flag);
+	reset_required = true;
+
+	if (hdev->asic_prop.fw_security_enabled && !reset_direct)
+		flags = HL_DRV_RESET_HARD | HL_DRV_RESET_BYPASS_REQ_TO_FW | fw_fatal_err_flag;
 	else if (hdev->hard_reset_on_fw_events)
-		hl_device_reset(hdev, HL_DRV_RESET_HARD | HL_DRV_RESET_DELAY | fw_fatal_err_flag);
+		flags = HL_DRV_RESET_HARD | HL_DRV_RESET_DELAY | fw_fatal_err_flag;
+	else
+		reset_required = false;
+
+	if (reset_required)
+		hl_device_reset(hdev, flags);
 	else
 		hl_fw_unmask_irq(hdev, event_type);
 }
-- 
2.35.1

