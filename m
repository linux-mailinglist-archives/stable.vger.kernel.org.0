Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2F29AFAC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756235AbgJ0OMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754761AbgJ0OG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8570A22258;
        Tue, 27 Oct 2020 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807618;
        bh=Jg8VYre6EXuZXTV3oHLDBy04t8AZqpUOPB3jyiDGBEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG/y+JXRezpWa7hwyscSIZCiJfa6NOsJrRxnoqKbaXIPiif6qJq8mpYYs32OgMecC
         edU1OqNtwR67z9ETrMCP8gZOtiky40CMCT/K+eEIHvve1F+LGgpZH8uxw9+yGFMjd0
         P7BvrjBb/YScDWmBjNrVZi/eSs1Qv70p/w/dNv84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/139] USB: cdc-acm: handle broken union descriptors
Date:   Tue, 27 Oct 2020 14:50:12 +0100
Message-Id: <20201027134907.745287735@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2dc563b61b88a..d46f683beccdd 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1178,9 +1178,21 @@ static int acm_probe(struct usb_interface *intf,
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



