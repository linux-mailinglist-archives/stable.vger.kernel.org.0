Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6896914EA1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfEFOjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbfEFOjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8024620449;
        Mon,  6 May 2019 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153564;
        bh=7ZemQmt0cOHyrYretRO4V8+S59a+oJa/34ZCLJ348R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8SHdiaGs4luT3zZ8lj79CjyyswutJcN+o0iW9eDcElZMHp1ps61tR5EyLyFHtbk8
         j9pIZLvH88LT2C9Tf+G/6VSqpOr1tZzkf7m1JuLS3T9LHlD6n9cf9QAdZcXpA31SGS
         BGtdD5uk8qOefLhmkgquUIMfDB9OYAcTXTNb6Bw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+d65f673b847a1a96cdba@syzkaller.appspotmail.com
Subject: [PATCH 4.19 14/99] USB: w1 ds2490: Fix bug caused by improper use of altsetting array
Date:   Mon,  6 May 2019 16:31:47 +0200
Message-Id: <20190506143055.162493902@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit c114944d7d67f24e71562fcfc18d550ab787e4d4 upstream.

The syzkaller USB fuzzer spotted a slab-out-of-bounds bug in the
ds2490 driver.  This bug is caused by improper use of the altsetting
array in the usb_interface structure (the array's entries are not
always stored in numerical order), combined with a naive assumption
that all interfaces probed by the driver will have the expected number
of altsettings.

The bug can be fixed by replacing references to the possibly
non-existent intf->altsetting[alt] entry with the guaranteed-to-exist
intf->cur_altsetting entry.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+d65f673b847a1a96cdba@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/masters/ds2490.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -1016,15 +1016,15 @@ static int ds_probe(struct usb_interface
 	/* alternative 3, 1ms interrupt (greatly speeds search), 64 byte bulk */
 	alt = 3;
 	err = usb_set_interface(dev->udev,
-		intf->altsetting[alt].desc.bInterfaceNumber, alt);
+		intf->cur_altsetting->desc.bInterfaceNumber, alt);
 	if (err) {
 		dev_err(&dev->udev->dev, "Failed to set alternative setting %d "
 			"for %d interface: err=%d.\n", alt,
-			intf->altsetting[alt].desc.bInterfaceNumber, err);
+			intf->cur_altsetting->desc.bInterfaceNumber, err);
 		goto err_out_clear;
 	}
 
-	iface_desc = &intf->altsetting[alt];
+	iface_desc = intf->cur_altsetting;
 	if (iface_desc->desc.bNumEndpoints != NUM_EP-1) {
 		pr_info("Num endpoints=%d. It is not DS9490R.\n",
 			iface_desc->desc.bNumEndpoints);


