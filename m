Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A9D5466C6
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiFJMpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 08:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiFJMpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B8017AB0
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25CBC60A6F
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 12:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350F0C34114;
        Fri, 10 Jun 2022 12:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654865148;
        bh=F//sqH+SQ5GxcwUFcWDK4U3+KReIk6qVigVrd90s5p0=;
        h=Subject:To:From:Date:From;
        b=nP4naDBzfg12yhBcH+QgfUgWGpve0GQhuvdYZQoz4rr1Jj2+Lp/LarW3BmX+yoEmr
         99/gLuY/ePSGMMLiSnSyBznZNAYypmzderuRni6RnepcxC14r5kB69EjuBn/cgeFvJ
         BM/xivjbVdp8QxYf/V3n1jBSMhZ8qSD+lRYw+kRg=
Subject: patch "usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()" added to usb-linus
To:     quic_linyyuan@quicinc.com, gregkh@linuxfoundation.org,
        john@metanate.com, michael@allwinnertech.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jun 2022 14:45:45 +0200
Message-ID: <1654865145110172@kroah.com>
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

    usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fb1f16d74e263baa4ad11e31e28b68f144aa55ed Mon Sep 17 00:00:00 2001
From: Linyu Yuan <quic_linyyuan@quicinc.com>
Date: Fri, 10 Jun 2022 20:17:57 +0800
Subject: usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()

If a task read/write data in blocking mode, it will wait the completion
in ffs_epfile_io(), if function unbind occurs, ffs_func_unbind() will
kfree ffs ep, once the task wake up, it still dereference the ffs ep to
obtain the request status.

Fix it by moving the request status to io_data which is stack-safe.

Cc: <stable@vger.kernel.org> # 5.15
Reported-by: Michael Wu <michael@allwinnertech.com>
Tested-by: Michael Wu <michael@allwinnertech.com>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1654863478-26228-2-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 34 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 4585ee3a444a..e1fcd8bc80a1 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -122,8 +122,6 @@ struct ffs_ep {
 	struct usb_endpoint_descriptor	*descs[3];
 
 	u8				num;
-
-	int				status;	/* P: epfile->mutex */
 };
 
 struct ffs_epfile {
@@ -227,6 +225,9 @@ struct ffs_io_data {
 	bool use_sg;
 
 	struct ffs_data *ffs;
+
+	int status;
+	struct completion done;
 };
 
 struct ffs_desc_helper {
@@ -707,12 +708,15 @@ static const struct file_operations ffs_ep0_operations = {
 
 static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
 {
+	struct ffs_io_data *io_data = req->context;
+
 	ENTER();
-	if (req->context) {
-		struct ffs_ep *ep = _ep->driver_data;
-		ep->status = req->status ? req->status : req->actual;
-		complete(req->context);
-	}
+	if (req->status)
+		io_data->status = req->status;
+	else
+		io_data->status = req->actual;
+
+	complete(&io_data->done);
 }
 
 static ssize_t ffs_copy_to_iter(void *data, int data_len, struct iov_iter *iter)
@@ -1050,7 +1054,6 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		WARN(1, "%s: data_len == -EINVAL\n", __func__);
 		ret = -EINVAL;
 	} else if (!io_data->aio) {
-		DECLARE_COMPLETION_ONSTACK(done);
 		bool interrupted = false;
 
 		req = ep->req;
@@ -1066,7 +1069,8 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		io_data->buf = data;
 
-		req->context  = &done;
+		init_completion(&io_data->done);
+		req->context  = io_data;
 		req->complete = ffs_epfile_io_complete;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
@@ -1075,7 +1079,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
-		if (wait_for_completion_interruptible(&done)) {
+		if (wait_for_completion_interruptible(&io_data->done)) {
 			/*
 			 * To avoid race condition with ffs_epfile_io_complete,
 			 * dequeue the request first then check
@@ -1083,17 +1087,17 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			 * condition with req->complete callback.
 			 */
 			usb_ep_dequeue(ep->ep, req);
-			wait_for_completion(&done);
-			interrupted = ep->status < 0;
+			wait_for_completion(&io_data->done);
+			interrupted = io_data->status < 0;
 		}
 
 		if (interrupted)
 			ret = -EINTR;
-		else if (io_data->read && ep->status > 0)
-			ret = __ffs_epfile_read_data(epfile, data, ep->status,
+		else if (io_data->read && io_data->status > 0)
+			ret = __ffs_epfile_read_data(epfile, data, io_data->status,
 						     &io_data->data);
 		else
-			ret = ep->status;
+			ret = io_data->status;
 		goto error_mutex;
 	} else if (!(req = usb_ep_alloc_request(ep->ep, GFP_ATOMIC))) {
 		ret = -ENOMEM;
-- 
2.36.1


