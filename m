Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E717FCBE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgCJNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgCJNAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:00:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07CD2253D;
        Tue, 10 Mar 2020 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845215;
        bh=EjNqq4Ctz4Zrpw1BWt1t9ekVbDfoR5ccplhyY852WnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdKkaQNP100uSTxZWW93l8ryzMCj6QQetKUuBnNKaACwMnNpE2yETYv1LTzLMcPTM
         Jg1pO5d8jQETl8P1mz2yj/s5RJWAOlL0loMr7j3k7in9o000t8yLOXnn8G4es3Vfj4
         hjGs4a+3qZ7Zun/pgeJW/mwME8tQVmZOGvLeYglQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 5.5 076/189] usb: core: hub: do error out if usb_autopm_get_interface() fails
Date:   Tue, 10 Mar 2020 13:38:33 +0100
Message-Id: <20200310123647.289613964@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit 60e3f6e4ac5b0fda43dad01c32e09409ec710045 upstream.

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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200226175036.14946-2-erosca@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -988,13 +988,17 @@ int usb_remove_device(struct usb_device
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


