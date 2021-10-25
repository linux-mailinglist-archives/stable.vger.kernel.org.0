Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E284395E0
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhJYMTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhJYMTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5C0460555;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164239;
        bh=UB12+Dycc6GEIdWE3BW/yQ4o2454bP5RnbmKCx2jaAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o14BBX8D0y4R5IVly34dWIXF7bWeZrdPavDEd/uGhfq/F4QY7aDHf6G4VTgud4/al
         wE1uOU4B+V5/pdT69qEWbwXQnlhBt4yKO4DI7HZkWLx01Iu3NSMO7hHptq9ol58YkO
         A9fiByuivwuIZyATw3Fev5vl85uaK6BIVcl4tf17iyam4RV5W1nA+jWIkfR9JwqRAq
         ml8Ohnm3NCEtKrv360kHOKsJLgNB0SUh/1WvTpuHOWuhO/IqAXcKsE6AusRpqFIajx
         vUjjd8n4rmVVk3kBxZYzzka6z6hktGZhb47rrZSjH2Ikpjhj2qVDdUFM4vAfWwMEZJ
         h39WoUhIuqLNQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuU-0001mS-R8; Mon, 25 Oct 2021 14:17:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 6/8] media: pvrusb2: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:39 +0200
Message-Id: <20211025121641.6759-7-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121641.6759-1-johan@kernel.org>
References: <20211025121641.6759-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org      # 2.6.18
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.32.0

