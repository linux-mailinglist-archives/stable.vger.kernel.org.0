Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3C405743
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358358AbhIINdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356248AbhIIM7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D696324F;
        Thu,  9 Sep 2021 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188730;
        bh=FngqzABBT8TusKp7m4MIHwTsRByJmIkVCnlVsYw/pL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqBJW60yxd61+lftv4nlpcTLR83sh3+ozmjqtmHiv7iwgkKN+aPiedZHq/R6h8yQB
         8F/l+W1TGqdkBc6oD6oLV/n4GNUt1gFWOVJRSm7pbb2IBfq2e+EKIFCXmZ4ym6yJxp
         tWBe341ixe6L/W5hrVQiF05Y8ukRyxML0fvQUAR0Is9jEjFuv7W10MPod+NpXZRmyV
         z7QABP1X1kD8mAnACPPGvzYg2b5dO6h8HLRVSnePDyN7+tmm1LEDSoyNkp44Coj872
         eCGtsi4ZZgmRhjnVuYLquFXtdE2ErLwFgpWb+WSJHvwyDwTJ1ZpjOFd6e21pkSAlCT
         VeKC7K/i7A2Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Michael <msbroadf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 67/74] usbip:vhci_hcd USB port can get stuck in the disabled state
Date:   Thu,  9 Sep 2021 07:57:19 -0400
Message-Id: <20210909115726.149004-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 66cce9e73ec61967ed1f97f30cee79bd9a2bb7ee ]

When a remote usb device is attached to the local Virtual USB
Host Controller Root Hub port, the bound device driver may send
a port reset command.

vhci_hcd accepts port resets only when the device doesn't have
port address assigned to it. When reset happens device is in
assigned/used state and vhci_hcd rejects it leaving the port in
a stuck state.

This problem was found when a blue-tooth or xbox wireless dongle
was passed through using usbip.

A few drivers reset the port during probe including mt76 driver
specific to this bug report. Fix the problem with a change to
honor reset requests when device is in used state (VDEV_ST_USED).

Reported-and-tested-by: Michael <msbroadf@gmail.com>
Suggested-by: Michael <msbroadf@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210819225937.41037-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vhci_hcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index a4ead4099869..202dc76f7beb 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -455,8 +455,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			vhci_hcd->port_status[rhport] &= ~(1 << USB_PORT_FEAT_RESET);
 			vhci_hcd->re_timeout = 0;
 
+			/*
+			 * A few drivers do usb reset during probe when
+			 * the device could be in VDEV_ST_USED state
+			 */
 			if (vhci_hcd->vdev[rhport].ud.status ==
-			    VDEV_ST_NOTASSIGNED) {
+				VDEV_ST_NOTASSIGNED ||
+			    vhci_hcd->vdev[rhport].ud.status ==
+				VDEV_ST_USED) {
 				usbip_dbg_vhci_rh(
 					" enable rhport %d (status %u)\n",
 					rhport,
-- 
2.30.2

