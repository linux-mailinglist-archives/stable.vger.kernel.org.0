Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16017FC07
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgCJNSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbgCJNLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BCAF24693;
        Tue, 10 Mar 2020 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845863;
        bh=aQyOo51tJXpfdWYbk8rtLOh1ur5fSsFP40lAEGRT9CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWxRblNqFYbY1mJbpdGFAgBYoAvet9VHj/d8nY+RMKdBob0MqABgItVQn1rqDxaEr
         BB6NlnRsLfgMf/ynya33AE446X9zPBDV/tqyMgt3+fa26b1AD/StjLCIP1F2AuGTVj
         Isona61LxW6+fJ86kuyE/S15fkzXW6qQIsWrPK8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 4.14 096/126] usb: core: port: do error out if usb_autopm_get_interface() fails
Date:   Tue, 10 Mar 2020 13:41:57 +0100
Message-Id: <20200310124209.859014837@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit 1f8b39bc99a31759e97a0428a5c3f64802c1e61d upstream.

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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200226175036.14946-3-erosca@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/port.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -179,7 +179,10 @@ static int usb_port_runtime_resume(struc
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
@@ -232,7 +235,10 @@ static int usb_port_runtime_suspend(stru
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


