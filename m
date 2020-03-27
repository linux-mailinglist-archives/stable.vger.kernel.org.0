Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F281C195177
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 07:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgC0Gps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 02:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgC0Gps (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 02:45:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C502C20714;
        Fri, 27 Mar 2020 06:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585291547;
        bh=Jrd64wZb9ebpsRgXxqFa7NbW0umwef/lmf2/ISkFucE=;
        h=Subject:To:From:Date:From;
        b=g7XTDS9I4g3x8B3LgCONoBTxDYl8EpbO6QBKFsQviymJDdMV45HH2axIQMpecXZpD
         R73zupR2j/+AvdX0AJ5keEvHynCBJrKlxHqxKktmOY1DWFvS7iVK4RQyV+W87yl6gP
         8FjhHfb6XAvbeu63lJ5lne6HtKEF7fsQdIDXtfRE=
Subject: patch "usb: gadget: f_fs: Fix use after free issue as part of queue failure" added to usb-next
To:     sallenki@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Mar 2020 07:45:01 +0100
Message-ID: <15852915016261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: Fix use after free issue as part of queue failure

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From f63ec55ff904b2f2e126884fcad93175f16ab4bb Mon Sep 17 00:00:00 2001
From: Sriharsha Allenki <sallenki@codeaurora.org>
Date: Thu, 26 Mar 2020 17:26:20 +0530
Subject: usb: gadget: f_fs: Fix use after free issue as part of queue failure

In AIO case, the request is freed up if ep_queue fails.
However, io_data->req still has the reference to this freed
request. In the case of this failure if there is aio_cancel
call on this io_data it will lead to an invalid dequeue
operation and a potential use after free issue.
Fix this by setting the io_data->req to NULL when the request
is freed as part of queue failure.

Fixes: 2e4c7553cd6f ("usb: gadget: f_fs: add aio support")
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
CC: stable <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200326115620.12571-1-sallenki@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 571917677d35..767f30b86645 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1120,6 +1120,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
 		if (unlikely(ret)) {
+			io_data->req = NULL;
 			usb_ep_free_request(ep->ep, req);
 			goto error_lock;
 		}
-- 
2.26.0


