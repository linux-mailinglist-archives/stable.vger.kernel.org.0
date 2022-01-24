Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8BA498ACA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343997AbiAXTGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33876 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344077AbiAXTDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0833E609EE;
        Mon, 24 Jan 2022 19:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8678C340E5;
        Mon, 24 Jan 2022 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051019;
        bh=S7Bor6nMftAccTraRKBR6ZDsxiNHuWT8eVG+H98iHlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0i6+GDM4WC8Y4yDiuB+acAlZzV1lxoZfdnS2QLSzwR4oJLIBgfKYkQe+lEVrm7NFI
         QbqMHUHvVa6+mSBlb1xPSY68bX8OHvmiBTaAfOyny/b3EM6RD4DdupHsgrqQnhOfnw
         CCdfjChvMSf7H4KH1G/jH89hnHozQd1hNwSUXGDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 028/186] media: pvrusb2: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:41:43 +0100
Message-Id: <20220124183938.025757876@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b82bf9b9dc305d7d3d93eab106d70dbf2171b43e upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org      # 2.6.18
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1476,7 +1476,7 @@ static int pvr2_upload_firmware1(struct
 	for (address = 0; address < fwsize; address += 0x800) {
 		memcpy(fw_ptr, fw_entry->data + address, 0x800);
 		ret += usb_control_msg(hdw->usb_dev, pipe, 0xa0, 0x40, address,
-				       0, fw_ptr, 0x800, HZ);
+				       0, fw_ptr, 0x800, 1000);
 	}
 
 	trace_firmware("Upload done, releasing device's CPU");
@@ -1614,7 +1614,7 @@ int pvr2_upload_firmware2(struct pvr2_hd
 			((u32 *)fw_ptr)[icnt] = swab32(((u32 *)fw_ptr)[icnt]);
 
 		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
-				    &actual_length, HZ);
+				    &actual_length, 1000);
 		ret |= (actual_length != bcnt);
 		if (ret) break;
 		fw_done += bcnt;
@@ -3433,7 +3433,7 @@ void pvr2_hdw_cpufw_set_enabled(struct p
 						      0xa0,0xc0,
 						      address,0,
 						      hdw->fw_buffer+address,
-						      0x800,HZ);
+						      0x800,1000);
 				if (ret < 0) break;
 			}
 
@@ -3961,7 +3961,7 @@ void pvr2_hdw_cpureset_assert(struct pvr
 	/* Write the CPUCS register on the 8051.  The lsb of the register
 	   is the reset bit; a 1 asserts reset while a 0 clears it. */
 	pipe = usb_sndctrlpipe(hdw->usb_dev, 0);
-	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,HZ);
+	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,1000);
 	if (ret < 0) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "cpureset_assert(%d) error=%d",val,ret);


