Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDEC546678
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiFJMSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 08:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348865AbiFJMSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:18:12 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFC7273912;
        Fri, 10 Jun 2022 05:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654863489; x=1686399489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QY+MoqRaocvrkDjvRhxlH1r4zKQeIIoc0IvvWA1YDiE=;
  b=HOE6eLJBBPHY6/eu0BBXdeiB36lUPk5AWzVB0AzdQhApzM/zzfF7jmaK
   +n0k+8IsdDZqPty819UtMvM4MfWR9EOYO/96VUHjQaOsUfRMZ5E49ArgW
   nNlwCcDhQ/2R9UIELNZ89toJMFZwTxCYxZsRj6EKDVuSVrzyjMuzH0E5c
   w=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 10 Jun 2022 05:18:08 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 05:18:08 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 10 Jun 2022 05:18:08 -0700
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 10 Jun 2022 05:18:05 -0700
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Michael Wu <michael@allwinnertech.com>,
        "John Keeping" <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH v5 1/2] usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()
Date:   Fri, 10 Jun 2022 20:17:57 +0800
Message-ID: <1654863478-26228-2-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1654863478-26228-1-git-send-email-quic_linyyuan@quicinc.com>
References: <1654863478-26228-1-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v2: correct interrupted assignment
v3: add Reviewed-by and Reported-by
v4: add Tetsed-by from Michael Wu,
    remove one empty line
    cc stable kernel
v5: change ?: to if/else format

 drivers/usb/gadget/function/f_fs.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 4585ee3..e1fcd8b 100644
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
2.7.4

