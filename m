Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E3929B5AE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794948AbgJ0POd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794941AbgJ0POb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2DE120728;
        Tue, 27 Oct 2020 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811670;
        bh=qAnh+vrLGPL7KCrI1zAkhrziG/CFv+LUFxKOfyozpLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lzu0oF6YiPWKPhwyM7izkmC43/sEJNCUeQg0vj7KZYEbjNlKY94JYw7JWcqmWJb5Z
         9pHLheZD02Qw2P4ThWliJJ80ZpyMxkczBLuFSCuEdIWanH7RbUHkmdaAZxBgkkW3nj
         aEPqf+UCX+Neq+qraYLxQ69uw5CSMsdNnotyzpas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 575/633] USB: cdc-acm: handle broken union descriptors
Date:   Tue, 27 Oct 2020 14:55:18 +0100
Message-Id: <20201027135549.779268971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 7499ba118665a..c02488d469185 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1243,9 +1243,21 @@ static int acm_probe(struct usb_interface *intf,
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



