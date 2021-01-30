Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619AA3095A5
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhA3N5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhA3N5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:57:19 -0500
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F492C061573;
        Sat, 30 Jan 2021 05:56:39 -0800 (PST)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 548D9C6379; Sat, 30 Jan 2021 13:56:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1612014996; bh=o+v5JicLaYZiiRnM4H+3R6+OQDhXMGSY4o+W8jt2QpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=E9kzjPMtTcsHRb5FETTLtBs0e/ePeCmkTm8YX6wf/MkMb1qgMyMt8SzjUZopv800q
         kYRaObm25smCovOevAbxUK9YWmjHNo3z6xX7s0zZ3hN/wM8DSOly5Z+qxgWo3CtK/z
         nc8MSxZiVR+QGKmXFA4Q2RhyjE487QSCFxGK0jT3O3AMIula3LB9dSYn+5IgbTecjI
         yvPgnikU5AyruhKqTajlUNsBOzLJVEG9OGy43NXYWq4PbOGy5Ht22G66N9JqTwkp6s
         WqoDiMYojn/VElgxRzHWxd8PibMKQ3A8ZayhTtG8E4T/oU+j/VSDl90HAshBBYPQMy
         1dWeoGmKpugTw==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     Laz Lev <lazlev@web.de>, stable@vger.kernel.org
Subject: [PATCH] media: smipcie: fix interrupt handling and IR timeout
Date:   Sat, 30 Jan 2021 13:56:36 +0000
Message-Id: <20210130135636.20834-1-sean@mess.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the first IR message, interrupts are no longer received. In addition,
the code generates a timeout IR message of 10ms but sets the timeout value
to 100ms, so no timeout was ever generated.

Fixes: a49a7a4635de ("media: smipcie: add universal ir capability")

Tested-by: Laz Lev <lazlev@web.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204317
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/smipcie/smipcie-ir.c | 46 +++++++++++++++-----------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index e6b74e161a05..c0604d9c7011 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -60,38 +60,44 @@ static void smi_ir_decode(struct smi_rc *ir)
 {
 	struct smi_dev *dev = ir->dev;
 	struct rc_dev *rc_dev = ir->rc_dev;
-	u32 dwIRControl, dwIRData;
-	u8 index, ucIRCount, readLoop;
+	u32 control, data;
+	u8 index, ir_count, read_loop;
 
-	dwIRControl = smi_read(IR_Init_Reg);
+	control = smi_read(IR_Init_Reg);
 
-	if (dwIRControl & rbIRVld) {
-		ucIRCount = (u8) smi_read(IR_Data_Cnt);
+	dev_dbg(&rc_dev->dev, "ircontrol: 0x%08x\n", control);
 
-		readLoop = ucIRCount/4;
-		if (ucIRCount % 4)
-			readLoop += 1;
-		for (index = 0; index < readLoop; index++) {
-			dwIRData = smi_read(IR_DATA_BUFFER_BASE + (index * 4));
+	if (control & rbIRVld) {
+		ir_count = (u8)smi_read(IR_Data_Cnt);
 
-			ir->irData[index*4 + 0] = (u8)(dwIRData);
-			ir->irData[index*4 + 1] = (u8)(dwIRData >> 8);
-			ir->irData[index*4 + 2] = (u8)(dwIRData >> 16);
-			ir->irData[index*4 + 3] = (u8)(dwIRData >> 24);
+		dev_dbg(&rc_dev->dev, "ircount %d\n", ir_count);
+
+		read_loop = ir_count / 4;
+		if (ir_count % 4)
+			read_loop += 1;
+		for (index = 0; index < read_loop; index++) {
+			data = smi_read(IR_DATA_BUFFER_BASE + (index * 4));
+			dev_dbg(&rc_dev->dev, "IRData 0x%08x\n", data);
+
+			ir->irData[index * 4 + 0] = (u8)(data);
+			ir->irData[index * 4 + 1] = (u8)(data >> 8);
+			ir->irData[index * 4 + 2] = (u8)(data >> 16);
+			ir->irData[index * 4 + 3] = (u8)(data >> 24);
 		}
-		smi_raw_process(rc_dev, ir->irData, ucIRCount);
-		smi_set(IR_Init_Reg, rbIRVld);
+		smi_raw_process(rc_dev, ir->irData, ir_count);
 	}
 
-	if (dwIRControl & rbIRhighidle) {
+	if (control & rbIRhighidle) {
 		struct ir_raw_event rawir = {};
 
+		dev_dbg(&rc_dev->dev, "high idle\n");
+
 		rawir.pulse = 0;
 		rawir.duration = SMI_SAMPLE_PERIOD * SMI_SAMPLE_IDLEMIN;
 		ir_raw_event_store_with_filter(rc_dev, &rawir);
-		smi_set(IR_Init_Reg, rbIRhighidle);
 	}
 
+	smi_set(IR_Init_Reg, rbIRVld);
 	ir_raw_event_handle(rc_dev);
 }
 
@@ -150,7 +156,7 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
 	rc_dev->map_name = dev->info->rc_map;
-	rc_dev->timeout = MS_TO_US(100);
+	rc_dev->timeout = SMI_SAMPLE_PERIOD * SMI_SAMPLE_IDLEMIN;
 	rc_dev->rx_resolution = SMI_SAMPLE_PERIOD;
 
 	ir->rc_dev = rc_dev;
@@ -173,7 +179,7 @@ void smi_ir_exit(struct smi_dev *dev)
 	struct smi_rc *ir = &dev->ir;
 	struct rc_dev *rc_dev = ir->rc_dev;
 
-	smi_ir_stop(ir);
 	rc_unregister_device(rc_dev);
+	smi_ir_stop(ir);
 	ir->rc_dev = NULL;
 }
-- 
2.29.2

