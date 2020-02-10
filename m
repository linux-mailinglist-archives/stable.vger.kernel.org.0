Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD0D15834D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBJTJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJTJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:09:22 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB15020838;
        Mon, 10 Feb 2020 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581361759;
        bh=PKMN6rRA/wy0OJhHRa9Z9dzhveSKYsd+bsDEG5xw800=;
        h=Subject:To:From:Date:From;
        b=D8vQdCikovHKP34ukCk1ve8qv0YbQI6L3Y4qNGODrkt8bZaGKAHWAN8YTBai5Otvc
         /3uy3iqnChYf8QPSoGzAwLEK65j7uiHFMCVASR//AV6jEZ2BxZ3DJdKZsbIm9I7e6u
         NtA+oY22/scsf0a6CmkJNV8CcyDQnIcPhz6Ia5Oo=
Subject: patch "USB: hub: Don't record a connect-change event during reset-resume" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        heinzelmann.david@gmail.com, pauldzim@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 11:09:18 -0800
Message-ID: <1581361758318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: hub: Don't record a connect-change event during reset-resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8099f58f1ecddf4f374f4828a3dff8397c7cbd74 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 31 Jan 2020 10:39:26 -0500
Subject: USB: hub: Don't record a connect-change event during reset-resume

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
 drivers/usb/core/hub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index de94fa4a4ca7..1d212f82c69b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1219,11 +1219,6 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
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
-- 
2.25.0


