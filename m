Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C32A8E8D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbfIDR6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388088AbfIDR6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A179B208E4;
        Wed,  4 Sep 2019 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619919;
        bh=lYKGDhZHrSAdetGgKg2/X9fiFpLIw2ZUBO+sUBzkB1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fp/Ua+p362TngDOu+Rzj1Udt4jzgo81A7bKd6TYjM7xmncxkDZ/8EqOm6EHtcWS4e
         lerF+pG3+DiztG5P6toxucqGqKgMhwYEYUzYtD2Cuw3Ycz4/o3z4n/0tNrYq0V31bQ
         yC388S8kZbDmgPfvsjSHIgHObSy0XeORWGbFYBrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d232cca6ec42c2edb3fc@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.4 65/77] USB: cdc-wdm: fix race between write and disconnect due to flag abuse
Date:   Wed,  4 Sep 2019 19:53:52 +0200
Message-Id: <20190904175309.458046474@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
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
@@ -577,10 +577,20 @@ static int wdm_flush(struct file *file,
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
 
@@ -968,8 +978,6 @@ static void wdm_disconnect(struct usb_in
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
 	set_bit(WDM_READ, &desc->flags);
-	/* to terminate pending flushes */
-	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);


