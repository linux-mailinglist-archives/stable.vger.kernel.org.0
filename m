Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912944699AB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344855AbhLFPCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344691AbhLFPCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B5C061746;
        Mon,  6 Dec 2021 06:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFC961316;
        Mon,  6 Dec 2021 14:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE999C341C2;
        Mon,  6 Dec 2021 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802732;
        bh=443gRvMLZSWL3KJ3WFCM8ai7m1X7e4REkEGJlfN8t1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+lyiaoOJXqpLH9YG99viTg1nvcBoxSAg0qXUDlotbHJwIvG80lS0B58Rgc4eu8aB
         CMqeRocd/XnmxDpqhrsrnhGDPXZTXLUE4HdbqhG35qXhYTUx7ch27LIqYNxD0RtP8c
         X7wRRvovVdbevMPvuxJxKdeZzSSHqfaLUrJquTIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 05/52] usb: hub: Fix locking issues with address0_mutex
Date:   Mon,  6 Dec 2021 15:55:49 +0100
Message-Id: <20211206145548.071650573@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 6cca13de26eea6d32a98d96d916a048d16a12822 upstream.

Fix the circular lock dependency and unbalanced unlock of addess0_mutex
introduced when fixing an address0_mutex enumeration retry race in commit
ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")

Make sure locking order between port_dev->status_lock and address0_mutex
is correct, and that address0_mutex is not unlocked in hub_port_connect
"done:" codepath which may be reached without locking address0_mutex

Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
Cc: <stable@vger.kernel.org>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211123101656.1113518-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4768,6 +4768,7 @@ static void hub_port_connect(struct usb_
 	struct usb_port *port_dev = hub->ports[port1 - 1];
 	struct usb_device *udev = port_dev->child;
 	static int unreliable_port = -1;
+	bool retry_locked;
 
 	/* Disconnect any existing devices under this port */
 	if (udev) {
@@ -4824,9 +4825,10 @@ static void hub_port_connect(struct usb_
 
 	status = 0;
 
-	mutex_lock(hcd->address0_mutex);
-
 	for (i = 0; i < SET_CONFIG_TRIES; i++) {
+		usb_lock_port(port_dev);
+		mutex_lock(hcd->address0_mutex);
+		retry_locked = true;
 
 		/* reallocate for each attempt, since references
 		 * to the previous one can escape in various ways
@@ -4835,6 +4837,8 @@ static void hub_port_connect(struct usb_
 		if (!udev) {
 			dev_err(&port_dev->dev,
 					"couldn't allocate usb_device\n");
+			mutex_unlock(hcd->address0_mutex);
+			usb_unlock_port(port_dev);
 			goto done;
 		}
 
@@ -4856,13 +4860,13 @@ static void hub_port_connect(struct usb_
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
@@ -4952,11 +4956,14 @@ static void hub_port_connect(struct usb_
 
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
@@ -4979,8 +4986,6 @@ loop:
 	}
 
 done:
-	mutex_unlock(hcd->address0_mutex);
-
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
 		if (status != -ENOTCONN && status != -ENODEV)


