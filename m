Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8368C48E550
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiANIRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58222 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbiANIRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5B8B823E6;
        Fri, 14 Jan 2022 08:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C78C36AFF;
        Fri, 14 Jan 2022 08:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148232;
        bh=y8uN/yGs2smiHpOWeUJUot42enqTFxI/H8QaxQqmhCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Le+Q84fVwSecXn5096pvggWkFzrcyUXAbb9TfLQkpv2wFKCohfx2zOEnPnIG+tbWf
         K4+lVYNnAjnNvkZJUoo5BJMV96hmcGdgbBLR+hGiOsAfC+K6mShIFo8PsnkPR/8hXb
         q0AdUsN3Rf79MYVpHjJJwfbYpPnZ3cQj/nl8YwLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 04/18] USB: core: Fix bug in resuming hubs handling of wakeup requests
Date:   Fri, 14 Jan 2022 09:16:11 +0100
Message-Id: <20220114081541.615679749@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 0f663729bb4afc92a9986b66131ebd5b8a9254d1 upstream.

Bugzilla #213839 reports a 7-port hub that doesn't work properly when
devices are plugged into some of the ports; the kernel goes into an
unending disconnect/reinitialize loop as shown in the bug report.

This "7-port hub" comprises two four-port hubs with one plugged into
the other; the failures occur when a device is plugged into one of the
downstream hub's ports.  (These hubs have other problems too.  For
example, they bill themselves as USB-2.0 compliant but they only run
at full speed.)

It turns out that the failures are caused by bugs in both the kernel
and the hub.  The hub's bug is that it reports a different
bmAttributes value in its configuration descriptor following a remote
wakeup (0xe0 before, 0xc0 after -- the wakeup-support bit has
changed).

The kernel's bug is inside the hub driver's resume handler.  When
hub_activate() sees that one of the hub's downstream ports got a
wakeup request from a child device, it notes this fact by setting the
corresponding bit in the hub->change_bits variable.  But this variable
is meant for connection changes, not wakeup events; setting it causes
the driver to believe the downstream port has been disconnected and
then connected again (in addition to having received a wakeup
request).

Because of this, the hub driver then tries to check whether the device
currently plugged into the downstream port is the same as the device
that had been attached there before.  Normally this check succeeds and
wakeup handling continues with no harm done (which is why the bug
remained undetected until now).  But with these dodgy hubs, the check
fails because the config descriptor has changed.  This causes the hub
driver to reinitialize the child device, leading to the
disconnect/reinitialize loop described in the bug report.

The proper way to note reception of a downstream wakeup request is
to set a bit in the hub->event_bits variable instead of
hub->change_bits.  That way the hub driver will realize that something
has happened to the port but will not think the port and child device
have been disconnected.  This patch makes that change.

Cc: <stable@vger.kernel.org>
Tested-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YdCw7nSfWYPKWQoD@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1223,7 +1223,7 @@ static void hub_activate(struct usb_hub
 			 */
 			if (portchange || (hub_is_superspeed(hub->hdev) &&
 						port_resumed))
-				set_bit(port1, hub->change_bits);
+				set_bit(port1, hub->event_bits);
 
 		} else if (udev->persist_enabled) {
 #ifdef CONFIG_PM


