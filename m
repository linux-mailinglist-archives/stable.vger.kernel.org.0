Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58541171A14
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgB0Num (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgB0Nul (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:50:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D8FF20578;
        Thu, 27 Feb 2020 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811440;
        bh=zlIvsWLiIu2vHHDXgrNOvGC1i/J5RK5KM6PJcVaUzck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcfnajvQIpH59qeXKZBxazREgxT49vz8k3ZRPAmD8bAYLSWQ9sgg7CUWAREhSrPdv
         oUhdzC4k3On55Kqijnft0zIYsYKvnxm25TAQ714rvwi+6lAh26DNezMDBJnDfNgJMh
         VUVXBbqfzrd00NjU/tphhtqr2Cu62nFARzL2IeDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        David Heinzelmann <heinzelmann.david@gmail.com>,
        Paul Zimmerman <pauldzim@gmail.com>
Subject: [PATCH 4.9 126/165] USB: hub: Dont record a connect-change event during reset-resume
Date:   Thu, 27 Feb 2020 14:36:40 +0100
Message-Id: <20200227132249.511133760@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 8099f58f1ecddf4f374f4828a3dff8397c7cbd74 upstream.

Paul Zimmerman reports that his USB Bluetooth adapter sometimes
crashes following system resume, when it receives a
Get-Device-Descriptor request while it is busy doing something else.

Such a request was added by commit a4f55d8b8c14 ("usb: hub: Check
device descriptor before resusciation").  It gets sent when the hub
driver's work thread checks whether a connect-change event on an
enabled port really indicates a new device has been connected, as
opposed to an old device momentarily disconnecting and then
reconnecting (which can happen with xHCI host controllers, since they
automatically enable connected ports).

The same kind of thing occurs when a port's power session is lost
during system suspend.  When the system wakes up it sees a
connect-change event on the port, and if the child device's
persist_enabled flag was set then hub_activate() sets the device's
reset_resume flag as well as the port's bit in hub->change_bits.  The
reset-resume code then takes responsibility for checking that the same
device is still attached to the port, and it does this as part of the
device's resume pathway.  By the time the hub driver's work thread
starts up again, the device has already been fully reinitialized and
is busy doing its own thing.  There's no need for the work thread to
do the same check a second time, and in fact this unnecessary check is
what caused the problem that Paul observed.

Note that performing the unnecessary check is not actually a bug.
Devices are supposed to be able to send descriptors back to the host
even when they are busy doing something else.  The underlying cause of
Paul's problem lies in his Bluetooth adapter.  Nevertheless, we
shouldn't perform the same check twice in a row -- and as a nice side
benefit, removing the extra check allows the Bluetooth adapter to work
more reliably.

The work thread performs its check when it sees that the port's bit is
set in hub->change_bits.  In this situation that bit is interpreted as
though a connect-change event had occurred on the port _after_ the
reset-resume, which is not what actually happened.

One possible fix would be to make the reset-resume code clear the
port's bit in hub->change_bits.  But it seems simpler to just avoid
setting the bit during hub_activate() in the first place.  That's what
this patch does.

(Proving that the patch is correct when CONFIG_PM is disabled requires
a little thought.  In that setting hub_activate() will be called only
for initialization and resets, since there won't be any resumes or
reset-resumes.  During initialization and hub resets the hub doesn't
have any child devices, and so this code path never gets executed.)

Reported-and-tested-by: Paul Zimmerman <pauldzim@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://marc.info/?t=157949360700001&r=1&w=2
CC: David Heinzelmann <heinzelmann.david@gmail.com>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2001311037460.1577-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1187,11 +1187,6 @@ static void hub_activate(struct usb_hub
 #ifdef CONFIG_PM
 			udev->reset_resume = 1;
 #endif
-			/* Don't set the change_bits when the device
-			 * was powered off.
-			 */
-			if (test_bit(port1, hub->power_bits))
-				set_bit(port1, hub->change_bits);
 
 		} else {
 			/* The power session is gone; tell hub_wq */


