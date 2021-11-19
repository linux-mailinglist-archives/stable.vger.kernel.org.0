Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34484569F2
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 07:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhKSGOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 01:14:36 -0500
Received: from www.linuxtv.org ([130.149.80.248]:37494 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232627AbhKSGOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 01:14:36 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mnx7U-0020Bv-HJ; Fri, 19 Nov 2021 06:11:32 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 06:06:12 +0000
Subject: [git:media_stage/master] media: pvrusb2: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mnx7U-0020Bv-HJ@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: pvrusb2: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Oct 25 13:16:39 2021 +0100

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org      # 2.6.18
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index d38dee1792e4..3915d551d59e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1467,7 +1467,7 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
 	for (address = 0; address < fwsize; address += 0x800) {
 		memcpy(fw_ptr, fw_entry->data + address, 0x800);
 		ret += usb_control_msg(hdw->usb_dev, pipe, 0xa0, 0x40, address,
-				       0, fw_ptr, 0x800, HZ);
+				       0, fw_ptr, 0x800, 1000);
 	}
 
 	trace_firmware("Upload done, releasing device's CPU");
@@ -1605,7 +1605,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 			((u32 *)fw_ptr)[icnt] = swab32(((u32 *)fw_ptr)[icnt]);
 
 		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
-				    &actual_length, HZ);
+				    &actual_length, 1000);
 		ret |= (actual_length != bcnt);
 		if (ret) break;
 		fw_done += bcnt;
@@ -3438,7 +3438,7 @@ void pvr2_hdw_cpufw_set_enabled(struct pvr2_hdw *hdw,
 						      0xa0,0xc0,
 						      address,0,
 						      hdw->fw_buffer+address,
-						      0x800,HZ);
+						      0x800,1000);
 				if (ret < 0) break;
 			}
 
@@ -3977,7 +3977,7 @@ void pvr2_hdw_cpureset_assert(struct pvr2_hdw *hdw,int val)
 	/* Write the CPUCS register on the 8051.  The lsb of the register
 	   is the reset bit; a 1 asserts reset while a 0 clears it. */
 	pipe = usb_sndctrlpipe(hdw->usb_dev, 0);
-	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,HZ);
+	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,1000);
 	if (ret < 0) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "cpureset_assert(%d) error=%d",val,ret);
