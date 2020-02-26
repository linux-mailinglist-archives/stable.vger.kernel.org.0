Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425131706A0
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 18:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgBZRvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 12:51:41 -0500
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:34647 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgBZRvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 12:51:41 -0500
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id C7C2D3C0579;
        Wed, 26 Feb 2020 18:51:39 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 65-82Hnu9-xs; Wed, 26 Feb 2020 18:51:34 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id A53E73C005E;
        Wed, 26 Feb 2020 18:51:34 +0100 (CET)
Received: from lxhi-065.adit-jv.com (10.72.93.66) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 26 Feb
 2020 18:51:34 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathieu Malaterre <malat@debian.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>, <stable@vger.kernel.org>
Subject: [PATCH v3 2/3] usb: core: hub: do error out if usb_autopm_get_interface() fails
Date:   Wed, 26 Feb 2020 18:50:35 +0100
Message-ID: <20200226175036.14946-2-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226175036.14946-1-erosca@de.adit-jv.com>
References: <20200226175036.14946-1-erosca@de.adit-jv.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.93.66]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewing a fresh portion of coverity defects in USB core
(specifically CID 1458999), Alan Stern noted below in [1]:

On Tue, Feb 25, 2020 at 02:39:23PM -0500, Alan Stern wrote:
 > A revised search finds line 997 in drivers/usb/core/hub.c and lines
 > 216, 269 in drivers/usb/core/port.c.  (I didn't try looking in any
 > other directories.)  AFAICT all three of these should check the
 > return value, although a error message in the kernel log probably
 > isn't needed.

Factor out the usb_remove_device() change into a standalone patch to
allow conflict-free integration on top of the earliest stable branches.

[1] https://lore.kernel.org/lkml/Pine.LNX.4.44L0.2002251419120.1485-100000@iolanthe.rowland.org

Fixes: 253e05724f9230 ("USB: add a "remove hardware" sysfs attribute")
Cc: stable@vger.kernel.org # v2.6.33+
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
v3:
 - Newly submitted
---
 drivers/usb/core/hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 1105983b5c1c..54cd8ef795ec 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -988,13 +988,17 @@ int usb_remove_device(struct usb_device *udev)
 {
 	struct usb_hub *hub;
 	struct usb_interface *intf;
+	int ret;
 
 	if (!udev->parent)	/* Can't remove a root hub */
 		return -EINVAL;
 	hub = usb_hub_to_struct_hub(udev->parent);
 	intf = to_usb_interface(hub->intfdev);
 
-	usb_autopm_get_interface(intf);
+	ret = usb_autopm_get_interface(intf);
+	if (ret < 0)
+		return ret;
+
 	set_bit(udev->portnum, hub->removed_bits);
 	hub_port_logical_disconnect(hub, udev->portnum);
 	usb_autopm_put_interface(intf);
-- 
2.25.1

