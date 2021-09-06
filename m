Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7057F401C02
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243145AbhIFNBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243003AbhIFNAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B3860238;
        Mon,  6 Sep 2021 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933136;
        bh=8HzuynrlLediHOAnbzpPlLufhxLkKsxquRGic0cMTEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glivFBFE7KLlmRT2FCIpmk8bgtoxMwUNXu4uWG+rN7LtPIIn01pQ3Z6TOpTLOo3gz
         MPlJFXdsCl6//FIhu7Q1WMvdky0O7ORcFUS4vrJtSldDUVt8f0sv7ndHVwGZZ9K/nx
         BUY6frr4/0V4gwqsBF7TrNdQpmTxVgILzCRPLOE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.14 07/14] HID: usbhid: Fix flood of "control queue full" messages
Date:   Mon,  6 Sep 2021 14:55:53 +0200
Message-Id: <20210906125448.426948067@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

commit 5049307d37a760e304ad191c5dc7c6851266d2f8 upstream.

[patch description by Alan Stern]

Commit 7652dd2c5cb7 ("USB: core: Check buffer length matches wLength
for control transfers") causes control URB submissions to fail if the
transfer_buffer_length value disagrees with the setup packet's wLength
valuel.  Unfortunately, it turns out that the usbhid can trigger this
failure mode when it submits a control request for an input report: It
pads the transfer buffer size to a multiple of the maxpacket value but
does not increase wLength correspondingly.

These failures have caused problems for people using an APS UPC, in
the form of a flood of log messages resembling:

	hid-generic 0003:051D:0002.0002: control queue full

This patch fixes the problem by setting the wLength value equal to the
padded transfer_buffer_length value in hid_submit_ctrl().  As a nice
bonus, the code which stores the transfer_buffer_length value is now
shared between the two branches of an "if" statement, so it can be
de-duplicated.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 7652dd2c5cb7 ("USB: core: Check buffer length matches wLength for control transfers")
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-core.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -377,27 +377,26 @@ static int hid_submit_ctrl(struct hid_de
 	len = hid_report_len(report);
 	if (dir == USB_DIR_OUT) {
 		usbhid->urbctrl->pipe = usb_sndctrlpipe(hid_to_usb_dev(hid), 0);
-		usbhid->urbctrl->transfer_buffer_length = len;
 		if (raw_report) {
 			memcpy(usbhid->ctrlbuf, raw_report, len);
 			kfree(raw_report);
 			usbhid->ctrl[usbhid->ctrltail].raw_report = NULL;
 		}
 	} else {
-		int maxpacket, padlen;
+		int maxpacket;
 
 		usbhid->urbctrl->pipe = usb_rcvctrlpipe(hid_to_usb_dev(hid), 0);
 		maxpacket = usb_maxpacket(hid_to_usb_dev(hid),
 					  usbhid->urbctrl->pipe, 0);
 		if (maxpacket > 0) {
-			padlen = DIV_ROUND_UP(len, maxpacket);
-			padlen *= maxpacket;
-			if (padlen > usbhid->bufsize)
-				padlen = usbhid->bufsize;
+			len = DIV_ROUND_UP(len, maxpacket);
+			len *= maxpacket;
+			if (len > usbhid->bufsize)
+				len = usbhid->bufsize;
 		} else
-			padlen = 0;
-		usbhid->urbctrl->transfer_buffer_length = padlen;
+			len = 0;
 	}
+	usbhid->urbctrl->transfer_buffer_length = len;
 	usbhid->urbctrl->dev = hid_to_usb_dev(hid);
 
 	usbhid->cr->bRequestType = USB_TYPE_CLASS | USB_RECIP_INTERFACE | dir;


