Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21227311A13
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhBFD3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 22:29:30 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48684 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhBFDW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 22:22:27 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l89zc-00E4Z2-Tv; Fri, 05 Feb 2021 22:54:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 05 Feb 2021 22:41:25 +0000
Subject: [git:media_tree/master] media: smipcie: fix interrupt handling and IR timeout
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, Laz Lev <lazlev@web.de>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l89zc-00E4Z2-Tv@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: smipcie: fix interrupt handling and IR timeout
Author:  Sean Young <sean@mess.org>
Date:    Fri Jan 29 11:54:53 2021 +0100

After the first IR message, interrupts are no longer received. In addition,
the code generates a timeout IR message of 10ms but sets the timeout value
to 100ms, so no timeout was ever generated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204317

Fixes: a49a7a4635de ("media: smipcie: add universal ir capability")
Tested-by: Laz Lev <lazlev@web.de>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/pci/smipcie/smipcie-ir.c | 46 +++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 20 deletions(-)

---

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
