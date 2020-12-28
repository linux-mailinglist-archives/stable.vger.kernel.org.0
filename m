Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F102E4005
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502422AbgL1Oqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731602AbgL1Oqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:46:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D430A206DC;
        Mon, 28 Dec 2020 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166764;
        bh=4MrsAWwNn6fFbQBL37SYQe+VqFwbKvlhY51FVrXqE0M=;
        h=Subject:To:From:Date:From;
        b=QJIYU/7CNTHBxVLgpv5DTIdQf281k5Aha0unle+ZHNcrCeM/3LIjOg1kSB4+a7m7C
         Mrnss9Vow6CNrvw8Firgd3cwLN9r3hYhkegR6SNejcBVQIYjNOr/AcEubs7y1VJLLT
         hZ0ddSd61jHmjiIOcmXnSBHhTeyYSx3NS2NeRIu4=
Subject: patch "USB: yurex: fix control-URB timeout handling" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:47:26 +0100
Message-ID: <160916684652196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: yurex: fix control-URB timeout handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 372c93131998c0622304bed118322d2a04489e63 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 14 Dec 2020 11:30:53 +0100
Subject: USB: yurex: fix control-URB timeout handling

Make sure to always cancel the control URB in write() so that it can be
reused after a timeout or spurious CMD_ACK.

Currently any further write requests after a timeout would fail after
triggering a WARN() in usb_submit_urb() when attempting to submit the
already active URB.

Reported-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com
Fixes: 6bc235a2e24a ("USB: add driver for Meywa-Denki & Kayac YUREX")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 73ebfa6e9715..c640f98d20c5 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -496,6 +496,9 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);
 
+	/* make sure URB is idle after timeout or (spurious) CMD_ACK */
+	usb_kill_urb(dev->cntl_urb);
+
 	mutex_unlock(&dev->io_mutex);
 
 	if (retval < 0) {
-- 
2.29.2


