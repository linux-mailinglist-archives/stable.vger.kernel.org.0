Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7170329194
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbhCAU2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243024AbhCAUVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94249653EA;
        Mon,  1 Mar 2021 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621858;
        bh=Ptg2P1wBUY7lTOmMuF6I6M1P+5OZgQIKIOZmTHAPdBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSEmSsGpckM82ufUVl97TbZBVp1wto/ZHoBxEYAF18vaxC+qgb6Mf/8MmSoSgTz/V
         BxOJrL5MeEQm5+PJ92jdTuTWjJsuwSbKlCd3sDUqqPBrreiZrQEW18aVnIzc9e9xsJ
         wIQ+ck+sxY7KktnEoNjUHJDtT3gu1YsZVhV3/JLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laz Lev <lazlev@web.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 670/775] media: smipcie: fix interrupt handling and IR timeout
Date:   Mon,  1 Mar 2021 17:13:58 +0100
Message-Id: <20210301161234.495623669@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 6532923237b427ed30cc7b4486f6f1ccdee3c647 upstream.

After the first IR message, interrupts are no longer received. In addition,
the code generates a timeout IR message of 10ms but sets the timeout value
to 100ms, so no timeout was ever generated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204317

Fixes: a49a7a4635de ("media: smipcie: add universal ir capability")
Tested-by: Laz Lev <lazlev@web.de>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/smipcie/smipcie-ir.c |   48 ++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -60,38 +60,44 @@ static void smi_ir_decode(struct smi_rc
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
-
-			ir->irData[index*4 + 0] = (u8)(dwIRData);
-			ir->irData[index*4 + 1] = (u8)(dwIRData >> 8);
-			ir->irData[index*4 + 2] = (u8)(dwIRData >> 16);
-			ir->irData[index*4 + 3] = (u8)(dwIRData >> 24);
+	if (control & rbIRVld) {
+		ir_count = (u8)smi_read(IR_Data_Cnt);
+
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


