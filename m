Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF8A327EEF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhCANGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:06:46 -0500
Received: from gofer.mess.org ([88.97.38.141]:43711 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhCANGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 08:06:40 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 457D5C6367; Mon,  1 Mar 2021 13:05:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1614603958; bh=UAdR1QHHFkXak/TxVpdF6zLChjX5BjCxOO8OXn3E900=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aAkGCtyAgcdRmcP0NhmNHdYNh1x4B3UjhwxP34EOBGfPqWjVgE3tJJHJ3lIwK3wZ3
         CoXbKKho8JTMeloeu2wOB86NeZcDl03Q/W8KTFA9Pysz+ZeLIXIFYuiVbOQb6yotW6
         UVRprzU4TTwD+/lNrWuLgBAbHA1P0odhlh4kP/N87evx3Wcrhkcq4LQe36zozi9OeF
         b4dFARo582TjD/gccR8K0raCJM9RHrVYTaJnaP1Y2zfX5B7PkY/oZqyiCoMQUxYl8Z
         IllpXRO1TgpGLMENoAyo61wr/FHlz4OK7pOWPncttAQTPR56FtRcnJecrW0ZmUvQwb
         aDaBxw6aaxcPw==
Date:   Mon, 1 Mar 2021 13:05:58 +0000
From:   Sean Young <sean@mess.org>
To:     gregkh@linuxfoundation.org
Cc:     lazlev@web.de, mchehab+huawei@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: smipcie: fix interrupt handling
 and IR timeout" failed to apply to 5.4-stable tree
Message-ID: <20210301130558.GA27665@gofer.mess.org>
References: <161459748923477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161459748923477@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 12:18:09PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

commit 6532923237b427ed30cc7b4486f6f1ccdee3c647 backported to 5.4 follows.

Thanks

Sean
---
From a3951322842d0c55f540bfa6e973f8a45185da62 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Fri, 29 Jan 2021 11:54:53 +0100
Subject: [PATCH] media: smipcie: fix interrupt handling and IR timeout

After the first IR message, interrupts are no longer received. In addition,
the code generates a timeout IR message of 10ms but sets the timeout value
to 100ms, so no timeout was ever generated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204317

Fixes: a49a7a4635de ("media: smipcie: add universal ir capability")
Tested-by: Laz Lev <lazlev@web.de>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/media/pci/smipcie/smipcie-ir.c | 46 +++++++++++++++-----------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index 9445d792bfc9..731aa702e2b7 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -60,39 +60,45 @@ static void smi_ir_decode(struct smi_rc *ir)
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
 		rawir.duration = US_TO_NS(SMI_SAMPLE_PERIOD *
 					  SMI_SAMPLE_IDLEMIN);
 		ir_raw_event_store_with_filter(rc_dev, &rawir);
-		smi_set(IR_Init_Reg, rbIRhighidle);
 	}
 
+	smi_set(IR_Init_Reg, rbIRVld);
 	ir_raw_event_handle(rc_dev);
 }
 
@@ -151,7 +157,7 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
 	rc_dev->map_name = dev->info->rc_map;
-	rc_dev->timeout = MS_TO_NS(100);
+	rc_dev->timeout = US_TO_NS(SMI_SAMPLE_PERIOD * SMI_SAMPLE_IDLEMIN);
 	rc_dev->rx_resolution = US_TO_NS(SMI_SAMPLE_PERIOD);
 
 	ir->rc_dev = rc_dev;
@@ -174,7 +180,7 @@ void smi_ir_exit(struct smi_dev *dev)
 	struct smi_rc *ir = &dev->ir;
 	struct rc_dev *rc_dev = ir->rc_dev;
 
-	smi_ir_stop(ir);
 	rc_unregister_device(rc_dev);
+	smi_ir_stop(ir);
 	ir->rc_dev = NULL;
 }
-- 
2.29.2

