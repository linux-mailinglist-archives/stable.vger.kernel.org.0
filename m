Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E767941207A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347182AbhITRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354996AbhITRwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B367D61BF6;
        Mon, 20 Sep 2021 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157966;
        bh=FngqzABBT8TusKp7m4MIHwTsRByJmIkVCnlVsYw/pL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2O46enNvWvrNJEl1cJ9Lh6d/3WY+CJK9sUFjW4pCG0+5j8qbS0On5V95vDmHK8d1
         3YQi/Y4Y9gHsgaPbLVv+fT84GsQG2om9STr+ILY+PAOQN6o0vEfJabKLZ63tTXyscN
         9N+2xYStTDPGfr8WSw98N52/Vc1oDu59SY+7th8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael <msbroadf@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/293] usbip:vhci_hcd USB port can get stuck in the disabled state
Date:   Mon, 20 Sep 2021 18:43:15 +0200
Message-Id: <20210920163941.372934125@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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



