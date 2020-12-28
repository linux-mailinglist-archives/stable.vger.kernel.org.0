Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD0A2E6971
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgL1MxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgL1MxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 238B0208B6;
        Mon, 28 Dec 2020 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159929;
        bh=0Mgz45b/m6wkk2VL5RG5jTqPpg0ff7aJZjix0UxXSjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNDaNZ4vOVRCTvqHl+lbbChlZw70a6sy3bEjvvCWmNk/4rQZh8BtR/chycvviZC03
         fwLqYDza3QajosXDukDR0ylIy+bSFBh/keLCvNbUOUiI1/r+Exs3ke6i/EVXZqqhVe
         pI2lJpWEqEOJLCwpQW2tx+GkQQc6UVqDvt9kO+KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+150f793ac5bc18eee150@syzkaller.appspotmail.com
Subject: [PATCH 4.4 005/132] Input: cm109 - do not stomp on control URB
Date:   Mon, 28 Dec 2020 13:48:09 +0100
Message-Id: <20201228124846.682341600@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 82e06090473289ce63e23fdeb8737aad59b10645 upstream.

We need to make sure we are not stomping on the control URB that was
issued when opening the device when attempting to toggle buzzer.
To do that we need to mark it as pending in cm109_open().

Reported-and-tested-by: syzbot+150f793ac5bc18eee150@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/cm109.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -546,12 +546,15 @@ static int cm109_input_open(struct input
 	dev->ctl_data->byte[HID_OR2] = dev->keybit;
 	dev->ctl_data->byte[HID_OR3] = 0x00;
 
+	dev->ctl_urb_pending = 1;
 	error = usb_submit_urb(dev->urb_ctl, GFP_KERNEL);
-	if (error)
+	if (error) {
+		dev->ctl_urb_pending = 0;
 		dev_err(&dev->intf->dev, "%s: usb_submit_urb (urb_ctl) failed %d\n",
 			__func__, error);
-	else
+	} else {
 		dev->open = 1;
+	}
 
 	mutex_unlock(&dev->pm_mutex);
 


