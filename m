Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6586A14D91
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfEFOro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbfEFOrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4FE720578;
        Mon,  6 May 2019 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154062;
        bh=Nq5g+FcXcN8sgE2vPPqNBhPp7NQ0UqVZLrGtpsz1Z/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbPrj21wxJ8HhX0oG/ftApsmfkDlkU8Jgm4Y6DD4krHsQ57iKxbWI6ZFQmV3Qn0Ee
         Uf5gzhVlathHlAuTB2XNPl7ye7+ZwpW4jQ9+BhDs2Yk1oBiDg9vQD76gplievKUyHI
         oT3lV3vvUOianDX12LT8ZeMTi3OBY+PU+6tnFroA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+d65f673b847a1a96cdba@syzkaller.appspotmail.com
Subject: [PATCH 4.9 23/62] USB: w1 ds2490: Fix bug caused by improper use of altsetting array
Date:   Mon,  6 May 2019 16:32:54 +0200
Message-Id: <20190506143053.056065786@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
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
@@ -1039,15 +1039,15 @@ static int ds_probe(struct usb_interface
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


