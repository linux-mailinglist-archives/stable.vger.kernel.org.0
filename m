Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA6CB9BA
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfJDMCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDMCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF4F20862;
        Fri,  4 Oct 2019 12:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570190556;
        bh=2Cv31ba9CfgrR/s/tQGdMvrw/aV7Oie3bEGLj/wnHsI=;
        h=Subject:To:From:Date:From;
        b=xq2pjzNG+9tmgLpBti7bTspg1/i61MTjs8RZB83FjCv1jBlppKwuZc1IDBNCnA9t6
         92on/Jm9089BdrA3x8x/XEyWkql3e9CcjsN92/5t+uu5U8SKgwYTVPdnAK1+FU6EgD
         vvz6AJEd0JP3fGQ3gZ8XH/2KEgObx02qM7BzE6rw=
Subject: patch "USB: legousbtower: fix slab info leak at probe" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:02:34 +0200
Message-ID: <1570190554125220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: legousbtower: fix slab info leak at probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1d427be4a39defadda6dd8f4659bc17f7591740f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 19 Sep 2019 10:30:36 +0200
Subject: USB: legousbtower: fix slab info leak at probe

Make sure to check for short transfers when retrieving the version
information at probe to avoid leaking uninitialised slab data when
logging it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/legousbtower.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 006cf13b2199..1db07d4dc738 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -891,8 +891,10 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 				  get_version_reply,
 				  sizeof(*get_version_reply),
 				  1000);
-	if (result < 0) {
-		dev_err(idev, "LEGO USB Tower get version control request failed\n");
+	if (result < sizeof(*get_version_reply)) {
+		if (result >= 0)
+			result = -EIO;
+		dev_err(idev, "get version request failed: %d\n", result);
 		retval = result;
 		goto error;
 	}
-- 
2.23.0


