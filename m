Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D82E98084
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfHUQqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 12:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbfHUQqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 12:46:46 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7482E2339E;
        Wed, 21 Aug 2019 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566406005;
        bh=Q+DRdngM1CFE9krpJMkM7ZzsetjFFqN7bm/GeuK74sQ=;
        h=Subject:To:From:Date:From;
        b=GDGhGBjGaWqa1CovHTTwU3JrilvT6qiVqh7nT5D0Z3w8smnnWGqWkdTqHdqAuCY08
         U83T/zMtENrEls+6j2DX7TynGGijW64FJg/nuMsIxMJL8t2w2s12lEAcYIpfcfo5jP
         fqxRuU3aa4ky266apsfdTgX7v5Gdxq7V8dqrLwNo=
Subject: patch "usbtmc: more sanity checking for packet size" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Aug 2019 09:46:43 -0700
Message-ID: <1566406003141168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbtmc: more sanity checking for packet size

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From de7b9aa633b693e77942e12f1769506efae6917b Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 20 Aug 2019 11:28:25 +0200
Subject: usbtmc: more sanity checking for packet size

A malicious device can make the driver divide ny zero
with a nonsense maximum packet size.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190820092826.17694-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 4942122b2346..36858ddd8d9b 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2362,8 +2362,11 @@ static int usbtmc_probe(struct usb_interface *intf,
 		goto err_put;
 	}
 
+	retcode = -EINVAL;
 	data->bulk_in = bulk_in->bEndpointAddress;
 	data->wMaxPacketSize = usb_endpoint_maxp(bulk_in);
+	if (!data->wMaxPacketSize)
+		goto err_put;
 	dev_dbg(&intf->dev, "Found bulk in endpoint at %u\n", data->bulk_in);
 
 	data->bulk_out = bulk_out->bEndpointAddress;
-- 
2.23.0


