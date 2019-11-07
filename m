Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B7EF2C21
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfKGK23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfKGK23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 05:28:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE22214D8;
        Thu,  7 Nov 2019 10:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573122508;
        bh=yDeYLfXRw05FSW88OGBMWGHbDNvukZheDui6R90loYM=;
        h=Subject:To:From:Date:From;
        b=ED+dTiuaJJXj1l3mD+gNp9Ab0iddvHD0OXXV8mR/SKCcY4T9rouJqFVoBCe9Kuvg4
         6GbWBR5fOv7BTdU/Ew8xBDcezm+iAL+Yhvf0s0Jyc5RQIxZPnUTOMN3nD82HuJhORE
         WcsxpFCEIc/1J9oqyiUIumq3e8dO7ZJdY/6YYUfE=
Subject: patch "usbip: tools: fix fd leakage in the function of" added to usb-testing
To:     hewenliang4@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Nov 2019 11:28:25 +0100
Message-ID: <157312250533224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: tools: fix fd leakage in the function of

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 26a4d4c00f85cb844dd11dd35e848b079c2f5e8f Mon Sep 17 00:00:00 2001
From: Hewenliang <hewenliang4@huawei.com>
Date: Fri, 25 Oct 2019 00:35:15 -0400
Subject: usbip: tools: fix fd leakage in the function of
 read_attr_usbip_status

We should close the fd before the return of read_attr_usbip_status.

Fixes: 3391ba0e2792 ("usbip: tools: Extract generic code to be shared with vudc backend")
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191025043515.20053-1-hewenliang4@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/libsrc/usbip_host_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/usb/usbip/libsrc/usbip_host_common.c b/tools/usb/usbip/libsrc/usbip_host_common.c
index 2813aa821c82..d1d8ba2a4a40 100644
--- a/tools/usb/usbip/libsrc/usbip_host_common.c
+++ b/tools/usb/usbip/libsrc/usbip_host_common.c
@@ -57,7 +57,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	}
 
 	value = atoi(status);
-
+	close(fd);
 	return value;
 }
 
-- 
2.23.0


