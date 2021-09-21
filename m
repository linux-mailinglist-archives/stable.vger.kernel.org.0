Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD683413581
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhIUOkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233606AbhIUOkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 10:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55603611C5;
        Tue, 21 Sep 2021 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632235122;
        bh=e7Xq/jOzv23dVN0G+Hl60gtN8vZshw2BkdC0q7EkcoI=;
        h=Subject:To:From:Date:From;
        b=HN1rhEB0FfBMPXFPTFuN9fs3u3ENlak303pbkT9BubzeO8HuKaCup5ZqPj8LUpX0N
         aWIgrbQuCg9v0NMj7uT9VwthIXKkl1pm671mQud9QcoS+RgiMWDwzD4FZ+sYBzlm1l
         9s2UJuvTSgeVXj5Ub5FsJH8fL/Uy6eUkV4OXsakk=
Subject: patch "usb: musb: tusb6010: uninitialized data in" added to usb-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 16:38:31 +0200
Message-ID: <1632235111146244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: musb: tusb6010: uninitialized data in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 517c7bf99bad3d6b9360558414aae634b7472d80 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 16 Sep 2021 16:57:37 +0300
Subject: usb: musb: tusb6010: uninitialized data in
 tusb_fifo_write_unaligned()

This is writing to the first 1 - 3 bytes of "val" and then writing all
four bytes to musb_writel().  The last byte is always going to be
garbage.  Zero out the last bytes instead.

Fixes: 550a7375fe72 ("USB: Add MUSB and TUSB support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210916135737.GI25094@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/tusb6010.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index c42937692207..c968ecda42aa 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -190,6 +190,7 @@ tusb_fifo_write_unaligned(void __iomem *fifo, const u8 *buf, u16 len)
 	}
 	if (len > 0) {
 		/* Write the rest 1 - 3 bytes to FIFO */
+		val = 0;
 		memcpy(&val, buf, len);
 		musb_writel(fifo, 0, val);
 	}
-- 
2.33.0


