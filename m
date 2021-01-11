Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEEA2F168D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387710AbhAKNxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731048AbhAKNIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05AEE2255F;
        Mon, 11 Jan 2021 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370489;
        bh=RMD2vaXVrjkPvjcRICMHAwtmJRNH0mjnsLDPtwWFHYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WODxA2yU3q1MfMZJmwtIm6YpQPROdhJu1UOGnw9qLpCALQijc7ntuhrSdyFOExtob
         dR6xNdhEXQ5MloLEDojWiHMMyCJl1yApm3InXuAzUIQDQ7Pl0bXQl51ka1M+lj4eTe
         D0RA/FnzhAWlo66MjHQIUbgob6dqaeRZLiFNojo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+9e04e2df4a32fb661daf@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.19 45/77] USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().
Date:   Mon, 11 Jan 2021 14:01:54 +0100
Message-Id: <20210111130038.572212124@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 5e5ff0b4b6bcb4d17b7a26ec8bcfc7dd4651684f upstream.

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
 drivers/usb/class/cdc-wdm.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -465,13 +465,23 @@ static int service_outstanding_interrupt
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
@@ -1026,9 +1036,9 @@ static void wdm_disconnect(struct usb_in
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
-	kill_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
+	kill_urbs(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
 


