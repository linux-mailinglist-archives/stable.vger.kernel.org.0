Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6442D9E8C
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440561AbgLNSH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408612AbgLNRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+150f793ac5bc18eee150@syzkaller.appspotmail.com
Subject: [PATCH 5.9 083/105] Input: cm109 - do not stomp on control URB
Date:   Mon, 14 Dec 2020 18:28:57 +0100
Message-Id: <20201214172559.274007785@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
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
@@ -568,12 +568,15 @@ static int cm109_input_open(struct input
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
 


