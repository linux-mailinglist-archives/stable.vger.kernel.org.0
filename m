Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F04411E77
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350911AbhITRbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350555AbhITR3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C72F61440;
        Mon, 20 Sep 2021 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157426;
        bh=T91Zgokphle+V0vjmg+UqKidMYlUGT5t5wylyld9/q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAl86oxALS27vaa22wEcpQQXJ5cCrGEGqdq2wwk7Oo3vY3ex/OFiJd3coWBoy5/mR
         TyqFsXdISkCfZi7qNJtoZTABrAyGn8Ix2/QvXsekyswiV/r0ER8bM/7QxwXd4+AcLX
         1tFrRRDtzTDZaqvFrtZ2MrHj7/uneMXQqEc3rE6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael <msbroadf@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/217] usbip:vhci_hcd USB port can get stuck in the disabled state
Date:   Mon, 20 Sep 2021 18:43:17 +0200
Message-Id: <20210920163930.598982217@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 709214df2c18..22e8cda7a137 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -469,8 +469,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
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



