Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A21A8F6F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387799AbfIDSDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388616AbfIDSDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C5322CF7;
        Wed,  4 Sep 2019 18:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620217;
        bh=7gcbk8Hb7qI3OcjR0IAhn3L83PVuy6OklDmA1HXSEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3LZwnQngEDo3qQ8rMe1ZXdalY/vIDWq4U9/uCC5R5/7HitalZhH8f8Z5/UQYuPbe
         AOasZOH3+OhTXh/9LLBXkhD9mh2mvD6jazfTwa/TvW8Y0ylPZYwJ7kLIl3ZAA5nzsj
         kgl+/SsdXMhxYwXagHumtGS1b3rcyM0ZPlNGFICs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d232cca6ec42c2edb3fc@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 32/57] USB: cdc-wdm: fix race between write and disconnect due to flag abuse
Date:   Wed,  4 Sep 2019 19:54:00 +0200
Message-Id: <20190904175305.131702083@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 1426bd2c9f7e3126e2678e7469dca9fd9fc6dd3e upstream.

In case of a disconnect an ongoing flush() has to be made fail.
Nevertheless we cannot be sure that any pending URB has already
finished, so although they will never succeed, they still must
not be touched.
The clean solution for this is to check for WDM_IN_USE
and WDM_DISCONNECTED in flush(). There is no point in ever
clearing WDM_IN_USE, as no further writes make sense.

The issue is as old as the driver.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Reported-by: syzbot+d232cca6ec42c2edb3fc@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190827103436.21143-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -584,10 +584,20 @@ static int wdm_flush(struct file *file,
 {
 	struct wdm_device *desc = file->private_data;
 
-	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
+	wait_event(desc->wait,
+			/*
+			 * needs both flags. We cannot do with one
+			 * because resetting it would cause a race
+			 * with write() yet we need to signal
+			 * a disconnect
+			 */
+			!test_bit(WDM_IN_USE, &desc->flags) ||
+			test_bit(WDM_DISCONNECTING, &desc->flags));
 
 	/* cannot dereference desc->intf if WDM_DISCONNECTING */
-	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
+	if (test_bit(WDM_DISCONNECTING, &desc->flags))
+		return -ENODEV;
+	if (desc->werr < 0)
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
@@ -955,8 +965,6 @@ static void wdm_disconnect(struct usb_in
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
 	set_bit(WDM_READ, &desc->flags);
-	/* to terminate pending flushes */
-	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);


