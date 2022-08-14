Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03945920C7
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbiHNPax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240387AbiHNP3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0E7EE21;
        Sun, 14 Aug 2022 08:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 297C560C43;
        Sun, 14 Aug 2022 15:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F967C433B5;
        Sun, 14 Aug 2022 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490948;
        bh=sKiCDr2+rFLbZVPMxLPNCZjeW042ncbG+hqCMa4nj3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csYzj7lgatWcdz/C1jnW5sB8Vw7pOkWjbPuGqIElMnXAFXw/seqPU2mjiKnDjrbqd
         0G6CBPGO/xlJa1G+pGl6zYjGoDcJFwLrCqY/Yt4GBEsETjBS6ObBU1NI0ojCEv5dP4
         mnCaqcIKbQhyUSbVIRj8cjYtiByOlDC4taI86B9TFWd2kv6Vwx/X7SVo4NpGMzFmgt
         sNkVaLEq9EFM3Dlgccunh/6hk1hSRagkSQGF6dRUOg07i1YFjOFUr0mfhYY/U+Nt/X
         Ewaux8bHXCKphVLy6SUD+fwi46N3BThF3FHC2X1dHVjhg5YInGOcrM5Vdg6a0xNYhf
         wXeb/gyye2JzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tal Cohen <talcohen@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        osharabi@habana.ai, obitton@habana.ai, ttayar@habana.ai,
        ynudelman@habana.ai, dliberman@habana.ai, fkassabri@habana.ai,
        dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 5.19 34/64] habanalabs/gaudi: invoke device reset from one code block
Date:   Sun, 14 Aug 2022 11:24:07 -0400
Message-Id: <20220814152437.2374207-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
index 25d735aee6a3..e6bfaf55c6b6 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7717,10 +7717,10 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
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
 
@@ -7808,7 +7808,8 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 			dev_err(hdev->dev, "reset required due to %s\n",
 				gaudi_irq_map_table[event_type].name);
 
-			hl_device_reset(hdev, 0);
+			reset_direct = true;
+			goto reset_device;
 		} else {
 			hl_fw_unmask_irq(hdev, event_type);
 		}
@@ -7830,7 +7831,8 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 			dev_err(hdev->dev, "reset required due to %s\n",
 				gaudi_irq_map_table[event_type].name);
 
-			hl_device_reset(hdev, 0);
+			reset_direct = true;
+			goto reset_device;
 		} else {
 			hl_fw_unmask_irq(hdev, event_type);
 		}
@@ -7981,12 +7983,17 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
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

