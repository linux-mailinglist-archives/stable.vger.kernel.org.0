Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452ED13BC93
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 10:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgAOJlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 04:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgAOJlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 04:41:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0AB24671;
        Wed, 15 Jan 2020 09:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579081281;
        bh=3+axeOl4AOGs/piRx3+Y8Ckx101v7jsMa0EeAMr2YpI=;
        h=Subject:To:From:Date:From;
        b=g7rq3IWPo82kn3x9MdjhasmHPTIqrNMd+C2rd1xyTCSXTTzN+aRBhbDWlu4AFcHDE
         k89dX9vE8XlI7g+b4frdEqBTlGb7A36G9r6JGWuMigPd8dKJ7vP1AusTI/h3rpIliv
         kLt/NAhRP3GEhSVrBeBMFGOuGCqDMHJRxIuWnHkU=
Subject: patch "usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer" added to usb-testing
To:     peter.chen@nxp.com, balbi@kernel.org, gregkh@linuxfoundation.org,
        jun.li@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 10:40:58 +0100
Message-ID: <15790812583324@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From d2450c6937018d40d4111fe830fa48d4ddceb8d0 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Thu, 12 Dec 2019 16:35:03 +0800
Subject: usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer

The UDC core uses req->num_sgs to judge if scatter buffer list is used.
Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
is re-used for each request, so if the 1st request->length > PAGE_SIZE,
and the 2nd request->length is <= PAGE_SIZE, the f_fs uses the 1st
req->num_sgs for the 2nd request, it causes the UDC core get the wrong
req->num_sgs value (The 2nd request doesn't use sg). For f_fs async
io mode, it is not harm to initialize req->num_sgs as 0 either, in case,
the UDC driver doesn't zeroed request structure.

Cc: Jun Li <jun.li@nxp.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0bbccac94d6c..6f8b67e61771 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1062,6 +1062,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
@@ -1105,6 +1106,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			req->num_sgs = io_data->sgt.nents;
 		} else {
 			req->buf = data;
+			req->num_sgs = 0;
 		}
 		req->length = data_len;
 
-- 
2.24.1


