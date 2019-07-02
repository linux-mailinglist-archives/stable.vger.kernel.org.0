Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D845CF8D
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGBMfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfGBMfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:35:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93B9208C4;
        Tue,  2 Jul 2019 12:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562070913;
        bh=wFxh3ecm1+SBsibpNos3qJ6LtvzzqIaEruyHOf3Kmdg=;
        h=Subject:To:From:Date:From;
        b=GAM+W9XBgsUDUBYP0sUZ/64GZumFyQzBJuq6vwgo7hRF7Eyf9ROAFQs50xDcGmjyn
         Sah5GAMcysmutN2Nk/gj3bOh7FPRAk0wIp4f+isxf6B+j+lsZ6rCUjKYYcLGnckS/N
         MWxwEqqpXe16lI0fJr2AvaKVMqc4BK4a3XwLzYUg=
Subject: patch "usb: gadget: f_fs: data_len used before properly set" added to usb-next
To:     fei.yang@intel.com, felipe.balbi@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Jul 2019 14:29:43 +0200
Message-ID: <1562070583159130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: data_len used before properly set

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4833a94eb383f5b22775077ff92ddaae90440921 Mon Sep 17 00:00:00 2001
From: Fei Yang <fei.yang@intel.com>
Date: Wed, 12 Jun 2019 15:13:26 -0700
Subject: usb: gadget: f_fs: data_len used before properly set

The following line of code in function ffs_epfile_io is trying to set
flag io_data->use_sg in case buffer required is larger than one page.

    io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;

However at this point of time the variable data_len has not been set
to the proper buffer size yet. The consequence is that io_data->use_sg
is always set regardless what buffer size really is, because the condition
(data_len > PAGE_SIZE) is effectively an unsigned comparison between
-EINVAL and PAGE_SIZE which would always result in TRUE.

Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Fei Yang <fei.yang@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/gadget/function/f_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47be961f1bf3..c7ed90084d1a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -997,7 +997,6 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		 * earlier
 		 */
 		gadget = epfile->ffs->gadget;
-		io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;
 
 		spin_lock_irq(&epfile->ffs->eps_lock);
 		/* In the meantime, endpoint got disabled or changed. */
@@ -1012,6 +1011,8 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		 */
 		if (io_data->read)
 			data_len = usb_ep_align_maybe(gadget, ep->ep, data_len);
+
+		io_data->use_sg = gadget->sg_supported && data_len > PAGE_SIZE;
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		data = ffs_alloc_buffer(io_data, data_len);
-- 
2.22.0


