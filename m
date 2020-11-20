Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055D02BAEFE
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 16:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgKTPcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 10:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgKTPcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 10:32:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B640524073;
        Fri, 20 Nov 2020 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605886352;
        bh=Ws6DEEOHYhaXytN/LlUCM+hEFIruWj2ywW/1n3twASE=;
        h=Subject:To:From:Date:From;
        b=bhuB6Uue/z+mPrdIiLyF4UCg0i1TwmXHS7C7GF62Q0uhEsOiPSgjmklSVbaVF6AfK
         eXwqJvovzzzaEW24PH8QO7PCXQkyzSxmn6l5nYySKFIaAvK0sRaLalbhX9u25sVd49
         pM6GqlX0U0pE5RV7iwHpnnXVRROTUNYkedr4KY78=
Subject: patch "usb: gadget: Fix memleak in gadgetfs_fill_super" added to usb-linus
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 16:33:04 +0100
Message-ID: <160588638415666@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: Fix memleak in gadgetfs_fill_super

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 87bed3d7d26c974948a3d6e7176f304b2d41272b Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Tue, 17 Nov 2020 10:16:29 +0800
Subject: usb: gadget: Fix memleak in gadgetfs_fill_super

usb_get_gadget_udc_name will alloc memory for CHIP
in "Enomem" branch. we should free it before error
returns to prevent memleak.

Fixes: 175f712119c57 ("usb: gadget: provide interface for legacy gadgets to get UDC name")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201117021629.1470544-3-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 1b430b36d0a6..71e7d10dd76b 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -2039,6 +2039,9 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 	return 0;
 
 Enomem:
+	kfree(CHIP);
+	CHIP = NULL;
+
 	return -ENOMEM;
 }
 
-- 
2.29.2


