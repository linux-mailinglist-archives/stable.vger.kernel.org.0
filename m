Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3396D450C78
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhKORi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236585AbhKORhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C026460EE0;
        Mon, 15 Nov 2021 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997052;
        bh=zn+V9zvLUAQFJ1PZryUNmEyAjoqNfZiNBDd8fnudbfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtVrGjRlz72VHHPgF2xXYxXiJEVsRSg5u/9KDtF4juAnFxeewSBF6c7ZkK9RZVHTv
         M6BpwZlV7fWGBM7XbKGHZxbklaOHF4RVOQ2RsJuyIrYcLWRkiDzIiIcjb2m5MFNFGJ
         H/FelEQ7kMUgV0XcCN2u4pOQ56tuCOsv+FmB5c9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Walt Jr. Brake" <mr.yming81@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 001/575] xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay
Date:   Mon, 15 Nov 2021 17:55:26 +0100
Message-Id: <20211115165343.638752061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit e1959faf085b004e6c3afaaaa743381f00e7c015 upstream.

Some USB 3.1 enumeration issues were reported after the hub driver removed
the minimum 100ms limit for the power-on-good delay.

Since commit 90d28fb53d4a ("usb: core: reduce power-on-good delay time of
root hub") the hub driver sets the power-on-delay based on the
bPwrOn2PwrGood value in the hub descriptor.

xhci driver has a 20ms bPwrOn2PwrGood value for both roothubs based
on xhci spec section 5.4.8, but it's clearly not enough for the
USB 3.1 devices, causing enumeration issues.

Tests indicate full 100ms delay is needed.

Reported-by: Walt Jr. Brake <mr.yming81@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Fixes: 90d28fb53d4a ("usb: core: reduce power-on-good delay time of root hub")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211105160036.549516-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -171,7 +171,6 @@ static void xhci_common_hub_descriptor(s
 {
 	u16 temp;
 
-	desc->bPwrOn2PwrGood = 10;	/* xhci section 5.4.9 says 20ms max */
 	desc->bHubContrCurrent = 0;
 
 	desc->bNbrPorts = ports;
@@ -206,6 +205,7 @@ static void xhci_usb2_hub_descriptor(str
 	desc->bDescriptorType = USB_DT_HUB;
 	temp = 1 + (ports / 8);
 	desc->bDescLength = USB_DT_HUB_NONVAR_SIZE + 2 * temp;
+	desc->bPwrOn2PwrGood = 10;	/* xhci section 5.4.8 says 20ms */
 
 	/* The Device Removable bits are reported on a byte granularity.
 	 * If the port doesn't exist within that byte, the bit is set to 0.
@@ -258,6 +258,7 @@ static void xhci_usb3_hub_descriptor(str
 	xhci_common_hub_descriptor(xhci, desc, ports);
 	desc->bDescriptorType = USB_DT_SS_HUB;
 	desc->bDescLength = USB_DT_SS_HUB_SIZE;
+	desc->bPwrOn2PwrGood = 50;	/* usb 3.1 may fail if less than 100ms */
 
 	/* header decode latency should be zero for roothubs,
 	 * see section 4.23.5.2.


