Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81811220A1
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfLQA4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:56:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35048 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0003M9-UL; Tue, 17 Dec 2019 00:51:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005ax-E3; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>,
        syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com
Date:   Tue, 17 Dec 2019 00:47:13 +0000
Message-ID: <lsq.1576543535.625711273@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 099/136] USB: ldusb: fix control-message timeout
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 52403cfbc635d28195167618690595013776ebde upstream.

USB control-message timeouts are specified in milliseconds, not jiffies.
Waiting 83 minutes for a transfer to complete is a bit excessive.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Reported-by: syzbot+a4fbb3bb76cda0ea4e58@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191022153127.22295-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/ldusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -594,7 +594,7 @@ static ssize_t ld_usb_write(struct file
 					 1 << 8, 0,
 					 dev->interrupt_out_buffer,
 					 bytes_to_write,
-					 USB_CTRL_SET_TIMEOUT * HZ);
+					 USB_CTRL_SET_TIMEOUT);
 		if (retval < 0)
 			dev_err(&dev->intf->dev,
 				"Couldn't submit HID_REQ_SET_REPORT %d\n",

