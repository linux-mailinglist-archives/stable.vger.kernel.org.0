Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867A012F6D9
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgACKsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:48:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A7F21835;
        Fri,  3 Jan 2020 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048519;
        bh=VmuJUYir18nWVLH6eiKToLdOmm43qErS77+sQvzRVVk=;
        h=Subject:To:From:Date:From;
        b=O6gWnKejFpUn6l6SvrKoWMiBQIZUz7NNgREffkLb4xHWBXcY2kBUIdGfKPZT/Q42O
         fSdSNeNkf25RlyZP8KHlXEpGqUDAWW6I47rS8o2Dv4YW1ekyniY5Zr3gnmGs56o+1L
         Ixxh9C26YclbbPAkTbTeoOgvk876IcBk4cvndEOI=
Subject: patch "staging: vt6656: Fix non zero logical return of, usb_control_msg" added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:37 +0100
Message-ID: <1578048517122214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: Fix non zero logical return of, usb_control_msg

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 58c3e681b04dd57c70d0dcb7b69fe52d043ff75a Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Fri, 20 Dec 2019 21:14:59 +0000
Subject: staging: vt6656: Fix non zero logical return of, usb_control_msg

Starting with commit 59608cb1de1856
("staging: vt6656: clean function's error path in usbpipe.c")
the usb control functions have returned errors throughout driver
with only logical variable checking.

However, usb_control_msg return the amount of bytes transferred
this means that normal operation causes errors.

Correct the return function so only return zero when transfer
is successful.

Cc: stable <stable@vger.kernel.org> # v5.3+
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/08e88842-6f78-a2e3-a7a0-139fec960b2b@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/usbpipe.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index d3304df6bd53..488ebd98773d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -59,7 +59,9 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 
 	kfree(usb_buffer);
 
-	if (ret >= 0 && ret < (int)length)
+	if (ret == (int)length)
+		ret = 0;
+	else
 		ret = -EIO;
 
 end_unlock:
@@ -103,7 +105,9 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 
 	kfree(usb_buffer);
 
-	if (ret >= 0 && ret < (int)length)
+	if (ret == (int)length)
+		ret = 0;
+	else
 		ret = -EIO;
 
 end_unlock:
-- 
2.24.1


