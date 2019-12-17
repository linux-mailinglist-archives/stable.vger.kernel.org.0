Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881C51230AD
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfLQPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 10:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfLQPlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 10:41:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7EC2465E;
        Tue, 17 Dec 2019 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576597280;
        bh=qZo/J/2s6oOxn4Sa4goF369kuQzilDLNf1wxlAGROlY=;
        h=Subject:To:From:Date:From;
        b=QlPUYEkvf3xHKzG2HHnYuwMF55tiRWfJvY5DIvLzKMMIsao/Z1iHjdk10y6GbTDsI
         hipDFVEf0NaILxpD+OgLTub0B0ydeB24f249AoKdFFk6bFDl/s7f4Gb+CwunYyN5Xs
         aMKUn6QxRKKIRctDkrQJjAOUYdphmh36WneH5U7w=
Subject: patch "usbip: Fix receive error in vhci-hcd when using scatter-gather" added to usb-linus
To:     suwan.kim027@gmail.com, gregkh@linuxfoundation.org,
        marmarek@invisiblethingslab.com, skhan@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 16:41:17 +0100
Message-ID: <15765972778237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: Fix receive error in vhci-hcd when using scatter-gather

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d986294ee55d719562b20aabe15a39bf8f863415 Mon Sep 17 00:00:00 2001
From: Suwan Kim <suwan.kim027@gmail.com>
Date: Fri, 13 Dec 2019 11:30:54 +0900
Subject: usbip: Fix receive error in vhci-hcd when using scatter-gather
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When vhci uses SG and receives data whose size is smaller than SG
buffer size, it tries to receive more data even if it acutally
receives all the data from the server. If then, it erroneously adds
error event and triggers connection shutdown.

vhci-hcd should check if it received all the data even if there are
more SG entries left. So, check if it receivces all the data from
the server in for_each_sg() loop.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213023055.19933-2-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 6532d68e8808..e4b96674c405 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 
 			copy -= recv;
 			ret += recv;
+
+			if (!copy)
+				break;
 		}
 
 		if (ret != size)
-- 
2.24.1


