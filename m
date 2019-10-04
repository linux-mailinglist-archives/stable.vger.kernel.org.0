Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8059BCB6FE
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfJDJEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDJEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62B02207FF;
        Fri,  4 Oct 2019 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179854;
        bh=CDgDOwbD2W2yBdjXgtMdV9IrlDQoA8q1c43xaM/2syw=;
        h=Subject:To:From:Date:From;
        b=MpSoPjWUIFy/Ojn1gx5bA1/NV80/g3BjqFcuzJe4utKxwmsDmG/yII0Z+qzB0fFyl
         FZ0HodwfHgbxycwTZBD4wlbw1l9wtyXTnYgf02/SswyGsHcq/SpPSavnImZ/b7HLdp
         +ebr/DLoQsmWe9EzHRddTL0XG6hASjH0uRbt9ZQc=
Subject: patch "USB: microtek: fix info-leak at probe" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:04:09 +0200
Message-ID: <15701798491535@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: microtek: fix info-leak at probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 177238c3d47d54b2ed8f0da7a4290db492f4a057 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 3 Oct 2019 09:09:31 +0200
Subject: USB: microtek: fix info-leak at probe

Add missing bulk-in endpoint sanity check to prevent uninitialised stack
data from being reported to the system log and used as endpoint
addresses.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20191003070931.17009-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/microtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 0a57c2cc8e5a..7a6b122c833f 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -716,6 +716,10 @@ static int mts_usb_probe(struct usb_interface *intf,
 
 	}
 
+	if (ep_in_current != &ep_in_set[2]) {
+		MTS_WARNING("couldn't find two input bulk endpoints. Bailing out.\n");
+		return -ENODEV;
+	}
 
 	if ( ep_out == -1 ) {
 		MTS_WARNING( "couldn't find an output bulk endpoint. Bailing out.\n" );
-- 
2.23.0


