Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1855466C7
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiFJMqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 08:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiFJMqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25D31277F
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7108D60B3D
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 12:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76077C34114;
        Fri, 10 Jun 2022 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654865161;
        bh=dhH2LMrBadLMJ5gueQjN7oC7oOrFz5/fxvi2rVbTGvY=;
        h=Subject:To:From:Date:From;
        b=l49B8oZziFaVB5Ft1bhx9lKn2iKEAy+cfhVCpA3wzgUDmgg0eVVSAyMFs/JviUS4J
         EXFXNrD8qQb5Od6SVUoIJx6EnNe07SxqEyK7+7Cb9BuO2b4NZBB/cFJ2urGDPT2flg
         0pHQ+WZMdySn3+5IQPcwBQ86zrp+3s06MEUqQtbE=
Subject: patch "usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()" added to usb-linus
To:     quic_linyyuan@quicinc.com, gregkh@linuxfoundation.org,
        john@metanate.com, michael@allwinnertech.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jun 2022 14:45:46 +0200
Message-ID: <1654865146242255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0698f0209d8032e8869525aeb68f65ee7fde12ad Mon Sep 17 00:00:00 2001
From: Linyu Yuan <quic_linyyuan@quicinc.com>
Date: Fri, 10 Jun 2022 20:17:58 +0800
Subject: usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()

In ffs_epfile_io(), when read/write data in blocking mode, it will wait
the completion in interruptible mode, if task receive a signal, it will
terminate the wait, at same time, if function unbind occurs,
ffs_func_unbind() will kfree all eps, ffs_epfile_io() still try to
dequeue request by dereferencing ep which may become invalid.

Fix it by add ep spinlock and will not dereference ep if it is not valid.

Cc: <stable@vger.kernel.org> # 5.15
Reported-by: Michael Wu <michael@allwinnertech.com>
Tested-by: Michael Wu <michael@allwinnertech.com>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1654863478-26228-3-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index e1fcd8bc80a1..e0fa4b186ec6 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1080,6 +1080,11 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		if (wait_for_completion_interruptible(&io_data->done)) {
+			spin_lock_irq(&epfile->ffs->eps_lock);
+			if (epfile->ep != ep) {
+				ret = -ESHUTDOWN;
+				goto error_lock;
+			}
 			/*
 			 * To avoid race condition with ffs_epfile_io_complete,
 			 * dequeue the request first then check
@@ -1087,6 +1092,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			 * condition with req->complete callback.
 			 */
 			usb_ep_dequeue(ep->ep, req);
+			spin_unlock_irq(&epfile->ffs->eps_lock);
 			wait_for_completion(&io_data->done);
 			interrupted = io_data->status < 0;
 		}
-- 
2.36.1


