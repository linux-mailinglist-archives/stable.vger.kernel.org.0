Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41602F412E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 08:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfKHHSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 02:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfKHHSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 02:18:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817332085B;
        Fri,  8 Nov 2019 07:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573197511;
        bh=V0BHKUiRMHgKTkJyAFpHuw3X/fjzN2F/ystH0oBGEkA=;
        h=Subject:To:From:Date:From;
        b=BynJv3BTmikToMyPgobz7a+iV8ic+YUj/QnmsC6AmTwkaftEC2YBVom412pH5PX7c
         rcrujllUoj9AS9bDM81Eaj5nqXnyWOYGf0bGpxTCMAznpkOyuHWTEomog4aSVjmT/i
         bHcsGoew9DI0i7s5OksHTUF9M147QBC2T+rizdJE=
Subject: patch "usbip: tools: fix fd leakage in the function of" added to usb-next
To:     hewenliang4@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Nov 2019 08:17:37 +0100
Message-ID: <1573197457253132@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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
2.24.0


