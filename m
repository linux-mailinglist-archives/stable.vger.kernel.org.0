Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FFADD33E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392840AbfJRWQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387662AbfJRWIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E3A7222D4;
        Fri, 18 Oct 2019 22:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436497;
        bh=H12XsaAVdOeeHzLMIlQdJrBU963KqbPjLFf+EN77ZTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQwi+LXRG/wOHZTyi4GXvezuQoXlgqhmwQqapGKgo21II7SxmDx5cZTu9DoKW3iQ8
         1hJzM+2EzGWvDq6pqq2KTn6LhGp5Eaz0ePD8k79YdH+HGuBEVsCuTVTpB7ZezX2GWI
         bzeQLjti8mA15jbLGTeLKkzJzE36RM/+4K/mRsLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan-Marek Glogowski <glogow@fbihome.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/56] usb: handle warm-reset port requests on hub resume
Date:   Fri, 18 Oct 2019 18:07:08 -0400
Message-Id: <20191018220753.10002-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
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
index b543a4730ef24..bb20aa433e984 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -104,6 +104,8 @@ EXPORT_SYMBOL_GPL(ehci_cf_port_reset_rwsem);
 static void hub_release(struct kref *kref);
 static int usb_reset_and_verify_device(struct usb_device *udev);
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state);
+static bool hub_port_warm_reset_required(struct usb_hub *hub, int port1,
+		u16 portstatus);
 
 static inline char *portspeed(struct usb_hub *hub, int portstatus)
 {
@@ -1110,6 +1112,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
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

