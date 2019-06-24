Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9A050769
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfFXKG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbfFXKGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:55 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB23208E3;
        Mon, 24 Jun 2019 10:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370814;
        bh=98xwHsstZrM34rlzeo3ta4SSHIeaWrCcpHnO3+wo7GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrJB6Zs9vtjxOKvbJKGkCAOv160Em1gV4Fwkrc625CktnvTaiBQnLS4Q1XKJMdX9k
         JnHKfca1USHXA7krissCYdaFLBoBgS1h/CCU4ENVppo+BJQai3UKUxctGX0aO0ZRvX
         Vgr/70N19N1BdpNiEFSRgL0No3wTuFzV3vZLUK8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.1 011/121] xhci: detect USB 3.2 capable host controllers correctly
Date:   Mon, 24 Jun 2019 17:55:43 +0800
Message-Id: <20190624092321.220227761@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit ddd57980a0fde30f7b5d14b888a2cc84d01610e8 upstream.

USB 3.2 capability in a host can be detected from the
xHCI Supported Protocol Capability major and minor revision fields.

If major is 0x3 and minor 0x20 then the host is USB 3.2 capable.

For USB 3.2 capable hosts set the root hub lane count to 2.

The Major Revision and Minor Revision fields contain a BCD version number.
The value of the Major Revision field is JJh and the value of the Minor
Revision field is MNh for version JJ.M.N, where JJ = major revision number,
M - minor version number, N = sub-minor version number,
e.g. version 3.1 is represented with a value of 0310h.

Also fix the extra whitespace printed out when announcing regular
SuperSpeed hosts.

Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5029,16 +5029,26 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	} else {
 		/*
 		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn
+		 * minor revision instead of sbrn. Minor revision is a two digit
+		 * BCD containing minor and sub-minor numbers, only show minor.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev;
-		if (minor_rev) {
+		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+
+		switch (minor_rev) {
+		case 2:
+			hcd->speed = HCD_USB32;
+			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			hcd->self.root_hub->rx_lanes = 2;
+			hcd->self.root_hub->tx_lanes = 2;
+			break;
+		case 1:
 			hcd->speed = HCD_USB31;
 			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			break;
 		}
-		xhci_info(xhci, "Host supports USB 3.%x %s SuperSpeed\n",
+		xhci_info(xhci, "Host supports USB 3.%x %sSuperSpeed\n",
 			  minor_rev,
-			  minor_rev ? "Enhanced" : "");
+			  minor_rev ? "Enhanced " : "");
 
 		xhci->usb3_rhub.hcd = hcd;
 		/* xHCI private pointer was set in xhci_pci_probe for the second


