Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F0458CAF
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 11:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhKVKvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 05:51:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:24134 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239373AbhKVKvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 05:51:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10175"; a="233484295"
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="233484295"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 02:48:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="606372923"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2021 02:48:37 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     m.szyprowski@samsung.com, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [RFT PATCH] usb: hub: Fix locking issues with address0_mutex
Date:   Mon, 22 Nov 2021 12:50:03 +0200
Message-Id: <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
References: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the circular lock dependency and unbalanced unlock of addess0_mutex
introduced when fixing an address0_mutex enumeration retry race in commit
ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")

Make sure locking order between port_dev->status_lock and address0_mutex
is correct, and that address0_mutex is not unlocked in hub_port_connect
"done:" codepath which may be reached without locking address0_mutex

Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/hub.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 00c3506324e4..00070a8a6507 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5188,6 +5188,7 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 	struct usb_port *port_dev = hub->ports[port1 - 1];
 	struct usb_device *udev = port_dev->child;
 	static int unreliable_port = -1;
+	bool retry_locked;
 
 	/* Disconnect any existing devices under this port */
 	if (udev) {
@@ -5244,10 +5245,10 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 
 	status = 0;
 
-	mutex_lock(hcd->address0_mutex);
-
 	for (i = 0; i < PORT_INIT_TRIES; i++) {
-
+		usb_lock_port(port_dev);
+		mutex_lock(hcd->address0_mutex);
+		retry_locked = true;
 		/* reallocate for each attempt, since references
 		 * to the previous one can escape in various ways
 		 */
@@ -5255,6 +5256,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 		if (!udev) {
 			dev_err(&port_dev->dev,
 					"couldn't allocate usb_device\n");
+			mutex_unlock(hcd->address0_mutex);
+			usb_unlock_port(port_dev);
 			goto done;
 		}
 
@@ -5276,13 +5279,13 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 		}
 
 		/* reset (non-USB 3.0 devices) and get descriptor */
-		usb_lock_port(port_dev);
 		status = hub_port_init(hub, udev, port1, i);
-		usb_unlock_port(port_dev);
 		if (status < 0)
 			goto loop;
 
 		mutex_unlock(hcd->address0_mutex);
+		usb_unlock_port(port_dev);
+		retry_locked = false;
 
 		if (udev->quirks & USB_QUIRK_DELAY_INIT)
 			msleep(2000);
@@ -5372,11 +5375,14 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 
 loop_disable:
 		hub_port_disable(hub, port1, 1);
-		mutex_lock(hcd->address0_mutex);
 loop:
 		usb_ep0_reinit(udev);
 		release_devnum(udev);
 		hub_free_dev(udev);
+		if (retry_locked) {
+			mutex_unlock(hcd->address0_mutex);
+			usb_unlock_port(port_dev);
+		}
 		usb_put_dev(udev);
 		if ((status == -ENOTCONN) || (status == -ENOTSUPP))
 			break;
@@ -5399,8 +5405,6 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 	}
 
 done:
-	mutex_unlock(hcd->address0_mutex);
-
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
 		if (status != -ENOTCONN && status != -ENODEV)
-- 
2.25.1

