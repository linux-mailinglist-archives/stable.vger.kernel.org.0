Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564814122E9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbhITSS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359451AbhITSQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB0861A6D;
        Mon, 20 Sep 2021 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158516;
        bh=Pq+FWwKvLvXcJmC6zHClG84ExKNJqUV4WG9CYNPkQvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGtWDwNlj63ueRvwlXlQbWMkkkSe9VRfgQsG0GxRMyfA2XqISPYYTvpHozh8qzzG2
         bvZH1O7Z7NLxgw7IbotnnhMrNXwcJv1GoBCjeuCGNdYQcbRcz6tcSw5xMqUeH61qip
         v14c/ymbaiEsgMGjJns3Kl2+XaQV1O9FokSGON3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael <msbroadf@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/260] usbip:vhci_hcd USB port can get stuck in the disabled state
Date:   Mon, 20 Sep 2021 18:42:58 +0200
Message-Id: <20210920163936.539774623@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 46a46cde2070..170abb06a8a4 100644
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



