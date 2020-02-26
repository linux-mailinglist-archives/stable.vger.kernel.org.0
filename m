Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3611706A4
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBZRvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 12:51:51 -0500
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:34657 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgBZRvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 12:51:50 -0500
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id AE5BE3C009D;
        Wed, 26 Feb 2020 18:51:48 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6vHIzGP5pHOv; Wed, 26 Feb 2020 18:51:43 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 9A9F03C005E;
        Wed, 26 Feb 2020 18:51:43 +0100 (CET)
Received: from lxhi-065.adit-jv.com (10.72.93.66) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 26 Feb
 2020 18:51:43 +0100
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
Subject: [PATCH v3 3/3] usb: core: port: do error out if usb_autopm_get_interface() fails
Date:   Wed, 26 Feb 2020 18:50:36 +0100
Message-ID: <20200226175036.14946-3-erosca@de.adit-jv.com>
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

Factor out the usb_port_runtime_{resume,suspend}() changes into a
standalone patch to allow conflict-free porting on top of stable v3.9+.

[1] https://lore.kernel.org/lkml/Pine.LNX.4.44L0.2002251419120.1485-100000@iolanthe.rowland.org

Fixes: 971fcd492cebf5 ("usb: add runtime pm support for usb port device")
Cc: stable@vger.kernel.org # v3.9+
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
v3:
 - Newly submitted
---
 drivers/usb/core/port.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/port.c b/drivers/usb/core/port.c
index bbbb35fa639f..235a7c645503 100644
--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -213,7 +213,10 @@ static int usb_port_runtime_resume(struct device *dev)
 	if (!port_dev->is_superspeed && peer)
 		pm_runtime_get_sync(&peer->dev);
 
-	usb_autopm_get_interface(intf);
+	retval = usb_autopm_get_interface(intf);
+	if (retval < 0)
+		return retval;
+
 	retval = usb_hub_set_port_power(hdev, hub, port1, true);
 	msleep(hub_power_on_good_delay(hub));
 	if (udev && !retval) {
@@ -266,7 +269,10 @@ static int usb_port_runtime_suspend(struct device *dev)
 	if (usb_port_block_power_off)
 		return -EBUSY;
 
-	usb_autopm_get_interface(intf);
+	retval = usb_autopm_get_interface(intf);
+	if (retval < 0)
+		return retval;
+
 	retval = usb_hub_set_port_power(hdev, hub, port1, false);
 	usb_clear_port_feature(hdev, port1, USB_PORT_FEAT_C_CONNECTION);
 	if (!port_dev->is_superspeed)
-- 
2.25.1

