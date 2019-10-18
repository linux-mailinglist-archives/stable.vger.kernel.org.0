Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080F0DD3E8
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404666AbfJRWVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbfJRWGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC6FC222D2;
        Fri, 18 Oct 2019 22:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436382;
        bh=w72zSyvqC/ZsLccUu1t1p4GzejqibTaKWFcIEuyG+0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqxA9Z8dohohd5+vYXtnkfgi7z7DEIP+U1n9Vqs0vJxYjKeGBiqSi/yg3Yh/ARGJd
         ae1boHI9R40yxWJGZ/5khSUbmfhmpktDoQ2wp7W3e/Q4CmncRNmyg/aTfIUleDIlsx
         8rWzcfgReLUi5bOqePygx6B2xDsPioCtwpkUtpOY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan-Marek Glogowski <glogow@fbihome.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 035/100] usb: handle warm-reset port requests on hub resume
Date:   Fri, 18 Oct 2019 18:04:20 -0400
Message-Id: <20191018220525.9042-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan-Marek Glogowski <glogow@fbihome.de>

[ Upstream commit 4fdc1790e6a9ef22399c6bc6e63b80f4609f3b7e ]

On plug-in of my USB-C device, its USB_SS_PORT_LS_SS_INACTIVE
link state bit is set. Greping all the kernel for this bit shows
that the port status requests a warm-reset this way.

This just happens, if its the only device on the root hub, the hub
therefore resumes and the HCDs status_urb isn't yet available.
If a warm-reset request is detected, this sets the hubs event_bits,
which will prevent any auto-suspend and allows the hubs workqueue
to warm-reset the port later in port_event.

Signed-off-by: Jan-Marek Glogowski <glogow@fbihome.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8018f813972e0..d5fbd36cf4624 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -107,6 +107,8 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rwsem);
 static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state);
+static bool hub_port_warm_reset_required(struct usb_hub *hub, int port1,
+		u16 portstatus);
 
 static inline char *portspeed(struct usb_hub *hub, int portstatus)
 {
@@ -1111,6 +1113,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 						   USB_PORT_FEAT_ENABLE);
 		}
 
+		/* Make sure a warm-reset request is handled by port_event */
+		if (type == HUB_RESUME &&
+		    hub_port_warm_reset_required(hub, port1, portstatus))
+			set_bit(port1, hub->event_bits);
+
 		/*
 		 * Add debounce if USB3 link is in polling/link training state.
 		 * Link will automatically transition to Enabled state after
-- 
2.20.1

