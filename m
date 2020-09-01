Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFAD259B83
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbgIARCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbgIAPUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A5E20767;
        Tue,  1 Sep 2020 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973622;
        bh=FA1budK5XaQm58NU7RPqYGXBDEs+IHUx4xtayl9uj7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUnVKhnUzSFu4eXgelPz7lzvxFBJ3ZLGYm5uSsEPUBsfjLnNvgYMo4oS/51QtJbDq
         UGplTAv5MqjQkzzVi5S+V4L7JgrgszmCPo0m6Z+8p6LlvwNfe4Jsudl5kQfiuigjQz
         dNvJ5IJr7ftfCpEcZM+TNvJwXbG9mPdUxyAwk65c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 73/91] xhci: Do warm-reset when both CAS and XDEV_RESUME are set
Date:   Tue,  1 Sep 2020 17:10:47 +0200
Message-Id: <20200901150931.824947668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 904df64a5f4d5ebd670801d869ca0a6d6a6e8df6 upstream.

Sometimes re-plugging a USB device during system sleep renders the device
useless:
[  173.418345] xhci_hcd 0000:00:14.0: Get port status 2-4 read: 0x14203e2, return 0x10262
...
[  176.496485] usb 2-4: Waited 2000ms for CONNECT
[  176.496781] usb usb2-port4: status 0000.0262 after resume, -19
[  176.497103] usb 2-4: can't resume, status -19
[  176.497438] usb usb2-port4: logical disconnect

Because PLS equals to XDEV_RESUME, xHCI driver reports U3 to usbcore,
despite of CAS bit is flagged.

So proritize CAS over XDEV_RESUME to let usbcore handle warm-reset for
the port.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200821091549.20556-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -750,15 +750,6 @@ static void xhci_hub_report_usb3_link_st
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
-	/* resume state is a xHCI internal state.
-	 * Do not report it to usb core, instead, pretend to be U3,
-	 * thus usb core knows it's not ready for transfer
-	 */
-	if (pls == XDEV_RESUME) {
-		*status |= USB_SS_PORT_LS_U3;
-		return;
-	}
-
 	/* When the CAS bit is set then warm reset
 	 * should be performed on port
 	 */
@@ -781,6 +772,16 @@ static void xhci_hub_report_usb3_link_st
 		pls |= USB_PORT_STAT_CONNECTION;
 	} else {
 		/*
+		 * Resume state is an xHCI internal state.  Do not report it to
+		 * usb core, instead, pretend to be U3, thus usb core knows
+		 * it's not ready for transfer.
+		 */
+		if (pls == XDEV_RESUME) {
+			*status |= USB_SS_PORT_LS_U3;
+			return;
+		}
+
+		/*
 		 * If CAS bit isn't set but the Port is already at
 		 * Compliance Mode, fake a connection so the USB core
 		 * notices the Compliance state and resets the port.


