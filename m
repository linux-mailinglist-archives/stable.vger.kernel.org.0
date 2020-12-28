Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128792E3FB9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505774AbgL1OoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:44:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503850AbgL1OoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:44:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9FA206DC;
        Mon, 28 Dec 2020 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166601;
        bh=2ep15V/g+pb6ORy2UI42XkCPTzjPAVeKT4mJbpSUJbc=;
        h=Subject:To:From:Date:From;
        b=EP0M426QiB2cu2z3BzhClcEzF1N9SjuH+knTAOG73okpGDnb/o0Yg/oD6CiOS6Fr7
         F1gxGONuPhi+6ES/BZyF2Ix/uf8N9DVbXXn3TYdm5iGYjzl4VzMYpH3Z8Xnemmj47v
         GRJyBqKRt3B2Cw6E7QLLWckH+QaANibwi4EmH+zk=
Subject: patch "USB: cdc-wdm: Fix use after free in service_outstanding_interrupt()." added to usb-linus
To:     penguin-kernel@i-love.sakura.ne.jp, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        syzbot+9e04e2df4a32fb661daf@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:44:43 +0100
Message-ID: <1609166683172194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e5ff0b4b6bcb4d17b7a26ec8bcfc7dd4651684f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sun, 20 Dec 2020 00:25:53 +0900
Subject: USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

syzbot is reporting UAF at usb_submit_urb() [1], for
service_outstanding_interrupt() is not checking WDM_DISCONNECTING
before calling usb_submit_urb(). Close the race by doing same checks
wdm_read() does upon retry.

Also, while wdm_read() checks WDM_DISCONNECTING with desc->rlock held,
service_interrupt_work() does not hold desc->rlock. Thus, it is possible
that usb_submit_urb() is called from service_outstanding_interrupt() from
service_interrupt_work() after WDM_DISCONNECTING was set and kill_urbs()
 from wdm_disconnect() completed. Thus, move kill_urbs() in
wdm_disconnect() to after cancel_work_sync() (which makes sure that
service_interrupt_work() is no longer running) completed.

Although it seems to be safe to dereference desc->intf->dev in
service_outstanding_interrupt() even if WDM_DISCONNECTING was already set
because desc->rlock or cancel_work_sync() prevents wdm_disconnect() from
reaching list_del() before service_outstanding_interrupt() completes,
let's not emit error message if WDM_DISCONNECTING is set by
wdm_disconnect() while usb_submit_urb() is in progress.

[1] https://syzkaller.appspot.com/bug?extid=9e04e2df4a32fb661daf

Reported-by: syzbot <syzbot+9e04e2df4a32fb661daf@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/620e2ee0-b9a3-dbda-a25b-a93e0ed03ec5@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 02d0cfd23bb2..508b1c3f8b73 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -465,13 +465,23 @@ static int service_outstanding_interrupt(struct wdm_device *desc)
 	if (!desc->resp_count || !--desc->resp_count)
 		goto out;
 
+	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
+		rv = -ENODEV;
+		goto out;
+	}
+	if (test_bit(WDM_RESETTING, &desc->flags)) {
+		rv = -EIO;
+		goto out;
+	}
+
 	set_bit(WDM_RESPONDING, &desc->flags);
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);
 	if (rv) {
-		dev_err(&desc->intf->dev,
-			"usb_submit_urb failed with result %d\n", rv);
+		if (!test_bit(WDM_DISCONNECTING, &desc->flags))
+			dev_err(&desc->intf->dev,
+				"usb_submit_urb failed with result %d\n", rv);
 
 		/* make sure the next notification trigger a submit */
 		clear_bit(WDM_RESPONDING, &desc->flags);
@@ -1027,9 +1037,9 @@ static void wdm_disconnect(struct usb_interface *intf)
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
-	kill_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
+	kill_urbs(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
 
-- 
2.29.2


