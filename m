Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1135F82017
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 17:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfHEP2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 11:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbfHEP2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 11:28:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C81320B1F;
        Mon,  5 Aug 2019 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565018893;
        bh=nRTkTXWmApPid5w/BqBDJDiHqDx/9VH0wqd43aCGNr8=;
        h=Subject:To:From:Date:From;
        b=aTuNSQnShOKi26T4+06Bp+GBYMyn71qTCUAKBkicOQjWXejuszRLurQ3HKbDM94OK
         afWbuqQzggSsqYFP95F4Ma/EyQuSNAKsM2d3avUT/C7FjGWZJvpnwErx60erGvIhD6
         GEj/U4nLbVG12Y0Wv3ysXPsmRWQf8xgCfzorclvQ=
Subject: patch "usb: usbfs: fix double-free of usb memory upon submiturb error" added to usb-linus
To:     git@thegavinli.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 17:28:02 +0200
Message-ID: <156501888220269@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: usbfs: fix double-free of usb memory upon submiturb error

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c43f28dfdc4654e738aa6d3fd08a105b2bee758d Mon Sep 17 00:00:00 2001
From: Gavin Li <git@thegavinli.com>
Date: Sun, 4 Aug 2019 16:50:44 -0700
Subject: usb: usbfs: fix double-free of usb memory upon submiturb error

Upon an error within proc_do_submiturb(), dec_usb_memory_use_count()
gets called once by the error handling tail and again by free_async().
Remove the first call.

Signed-off-by: Gavin Li <git@thegavinli.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190804235044.22327-1-gavinli@thegavinli.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index b265ab5405f9..9063ede411ae 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1812,8 +1812,6 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 	return 0;
 
  error:
-	if (as && as->usbm)
-		dec_usb_memory_use_count(as->usbm, &as->usbm->urb_use_count);
 	kfree(isopkt);
 	kfree(dr);
 	if (as)
-- 
2.22.0


