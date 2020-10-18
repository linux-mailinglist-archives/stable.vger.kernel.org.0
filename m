Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0774A291C15
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbgJRTfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731560AbgJRT0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E999F222E7;
        Sun, 18 Oct 2020 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049167;
        bh=HSkTCzjmdJyA7OXQ8tGRRk3omSoEe9SMqbiUxADL9aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka3ACbbiZkTQj0AjwFkyDH04wDSQ2GHEsN+8LjdsI/DPvIYkda1+d/RdXcQ3f8zw5
         puJ69rgpt0LJbaSWS0z1aX6K958BcowwWP2b37LugcOIhM8xEg/vOu7E4qbJJ1RXb2
         F/L8dO16W6v8uriVX2K4Y6hbIO7DYgaDjLi3o0yw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/52] USB: cdc-acm: handle broken union descriptors
Date:   Sun, 18 Oct 2020 15:25:08 -0400
Message-Id: <20201018192530.4055730-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 960c7339de27c6d6fec13b54880501c3576bb08d ]

Handle broken union functional descriptors where the master-interface
doesn't exist or where its class is of neither Communication or Data
type (as required by the specification) by falling back to
"combined-interface" probing.

Note that this still allows for handling union descriptors with switched
interfaces.

This specifically makes the Whistler radio scanners TRX series devices
work with the driver without adding further quirks to the device-id
table.

Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200921135951.24045-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b3e4b014a1cc0..dff9860213624 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1287,9 +1287,21 @@ static int acm_probe(struct usb_interface *intf,
 			}
 		}
 	} else {
+		int class = -1;
+
 		data_intf_num = union_header->bSlaveInterface0;
 		control_interface = usb_ifnum_to_if(usb_dev, union_header->bMasterInterface0);
 		data_interface = usb_ifnum_to_if(usb_dev, data_intf_num);
+
+		if (control_interface)
+			class = control_interface->cur_altsetting->desc.bInterfaceClass;
+
+		if (class != USB_CLASS_COMM && class != USB_CLASS_CDC_DATA) {
+			dev_dbg(&intf->dev, "Broken union descriptor, assuming single interface\n");
+			combined_interfaces = 1;
+			control_interface = data_interface = intf;
+			goto look_for_collapsed_interface;
+		}
 	}
 
 	if (!control_interface || !data_interface) {
-- 
2.25.1

