Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E95667631
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbjALO3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbjALO3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A7659522
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F9461F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856CAC433D2;
        Thu, 12 Jan 2023 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533213;
        bh=96EHNRdOGp269ZxsJ7j3J0Bs31wUAqv9po7MohV1uls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ikl9kNLsER1cxImtEplhVyZxr7Jtam/pTU8bxiFnq/qlMy1ef7Cf37ryFxCNb3InZ
         tiBph/3xOpEXkvRrmOqa4EkVfbu9PzkUOSs4RjdlkDV707f7DvEf0qSRpVUlGw5IF6
         P1cZeKTmLbTh2PG5Sj9e0E6XoUn68roSO+51ESqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Maxim Devaev <mdevaev@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/783] usb: gadget: f_hid: optional SETUP/SET_REPORT mode
Date:   Thu, 12 Jan 2023 14:51:32 +0100
Message-Id: <20230112135541.748105944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Devaev <mdevaev@gmail.com>

[ Upstream commit d7428bc26fc767942c38d74b80299bcd4f01e7cb ]

f_hid provides the OUT Endpoint as only way for receiving reports
from the host. SETUP/SET_REPORT method is not supported, and this causes
a number of compatibility problems with various host drivers, especially
in the case of keyboard emulation using f_hid.

  - Some hosts do not support the OUT Endpoint and ignore it,
    so it becomes impossible for the gadget to receive a report
    from the host. In the case of a keyboard, the gadget loses
    the ability to receive the status of the LEDs.

  - Some BIOSes/UEFIs can't work with HID devices with the OUT Endpoint
    at all. This may be due to their bugs or incomplete implementation
    of the HID standard.
    For example, absolutely all Apple UEFIs can't handle the OUT Endpoint
    if it goes after IN Endpoint in the descriptor and require the reverse
    order (OUT, IN) which is a violation of the standard.
    Other hosts either do not initialize gadgets with a descriptor
    containing the OUT Endpoint completely (like some HP and DELL BIOSes
    and embedded firmwares like on KVM switches), or initialize them,
    but will not poll the IN Endpoint.

This patch adds configfs option no_out_endpoint=1 to disable
the OUT Endpoint and allows f_hid to receive reports from the host
via SETUP/SET_REPORT.

Previously, there was such a feature in f_hid, but it was replaced
by the OUT Endpoint [1] in the commit 99c515005857 ("usb: gadget: hidg:
register OUT INT endpoint for SET_REPORT"). So this patch actually
returns the removed functionality while making it optional.
For backward compatibility reasons, the OUT Endpoint mode remains
the default behaviour.

  - The OUT Endpoint mode provides the report queue and reduces
    USB overhead (eliminating SETUP routine) on transmitting a report
    from the host.

  - If the SETUP/SET_REPORT mode is used, there is no report queue,
    so the userspace will only read last report. For classic HID devices
    like keyboards this is not a problem, since it's intended to transmit
    the status of the LEDs and only the last report is important.
    This mode provides better compatibility with strange and buggy
    host drivers.

Both modes passed USBCV tests. Checking with the USB protocol analyzer
also confirmed that everything is working as it should and the new mode
ensures operability in all of the described cases.

Link: https://www.spinics.net/lists/linux-usb/msg65494.html [1]
Reviewed-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Link: https://lore.kernel.org/r/20210821134004.363217-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 89ff3dfac604 ("usb: gadget: f_hid: fix f_hidg lifetime vs cdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 220 +++++++++++++++++++++++-----
 drivers/usb/gadget/function/u_hid.h |   1 +
 2 files changed, 188 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 6742271cd6e6..8cb199f52b52 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -45,12 +45,25 @@ struct f_hidg {
 	unsigned short			report_desc_length;
 	char				*report_desc;
 	unsigned short			report_length;
+	/*
+	 * use_out_ep - if true, the OUT Endpoint (interrupt out method)
+	 *              will be used to receive reports from the host
+	 *              using functions with the "intout" suffix.
+	 *              Otherwise, the OUT Endpoint will not be configured
+	 *              and the SETUP/SET_REPORT method ("ssreport" suffix)
+	 *              will be used to receive reports.
+	 */
+	bool				use_out_ep;
 
 	/* recv report */
-	struct list_head		completed_out_req;
 	spinlock_t			read_spinlock;
 	wait_queue_head_t		read_queue;
+	/* recv report - interrupt out only (use_out_ep == 1) */
+	struct list_head		completed_out_req;
 	unsigned int			qlen;
+	/* recv report - setup set_report only (use_out_ep == 0) */
+	char				*set_report_buf;
+	unsigned int			set_report_length;
 
 	/* send report */
 	spinlock_t			write_spinlock;
@@ -79,7 +92,7 @@ static struct usb_interface_descriptor hidg_interface_desc = {
 	.bDescriptorType	= USB_DT_INTERFACE,
 	/* .bInterfaceNumber	= DYNAMIC */
 	.bAlternateSetting	= 0,
-	.bNumEndpoints		= 2,
+	/* .bNumEndpoints	= DYNAMIC (depends on use_out_ep) */
 	.bInterfaceClass	= USB_CLASS_HID,
 	/* .bInterfaceSubClass	= DYNAMIC */
 	/* .bInterfaceProtocol	= DYNAMIC */
@@ -140,7 +153,7 @@ static struct usb_ss_ep_comp_descriptor hidg_ss_out_comp_desc = {
 	/* .wBytesPerInterval   = DYNAMIC */
 };
 
-static struct usb_descriptor_header *hidg_ss_descriptors[] = {
+static struct usb_descriptor_header *hidg_ss_descriptors_intout[] = {
 	(struct usb_descriptor_header *)&hidg_interface_desc,
 	(struct usb_descriptor_header *)&hidg_desc,
 	(struct usb_descriptor_header *)&hidg_ss_in_ep_desc,
@@ -150,6 +163,14 @@ static struct usb_descriptor_header *hidg_ss_descriptors[] = {
 	NULL,
 };
 
+static struct usb_descriptor_header *hidg_ss_descriptors_ssreport[] = {
+	(struct usb_descriptor_header *)&hidg_interface_desc,
+	(struct usb_descriptor_header *)&hidg_desc,
+	(struct usb_descriptor_header *)&hidg_ss_in_ep_desc,
+	(struct usb_descriptor_header *)&hidg_ss_in_comp_desc,
+	NULL,
+};
+
 /* High-Speed Support */
 
 static struct usb_endpoint_descriptor hidg_hs_in_ep_desc = {
@@ -176,7 +197,7 @@ static struct usb_endpoint_descriptor hidg_hs_out_ep_desc = {
 				      */
 };
 
-static struct usb_descriptor_header *hidg_hs_descriptors[] = {
+static struct usb_descriptor_header *hidg_hs_descriptors_intout[] = {
 	(struct usb_descriptor_header *)&hidg_interface_desc,
 	(struct usb_descriptor_header *)&hidg_desc,
 	(struct usb_descriptor_header *)&hidg_hs_in_ep_desc,
@@ -184,6 +205,13 @@ static struct usb_descriptor_header *hidg_hs_descriptors[] = {
 	NULL,
 };
 
+static struct usb_descriptor_header *hidg_hs_descriptors_ssreport[] = {
+	(struct usb_descriptor_header *)&hidg_interface_desc,
+	(struct usb_descriptor_header *)&hidg_desc,
+	(struct usb_descriptor_header *)&hidg_hs_in_ep_desc,
+	NULL,
+};
+
 /* Full-Speed Support */
 
 static struct usb_endpoint_descriptor hidg_fs_in_ep_desc = {
@@ -210,7 +238,7 @@ static struct usb_endpoint_descriptor hidg_fs_out_ep_desc = {
 				       */
 };
 
-static struct usb_descriptor_header *hidg_fs_descriptors[] = {
+static struct usb_descriptor_header *hidg_fs_descriptors_intout[] = {
 	(struct usb_descriptor_header *)&hidg_interface_desc,
 	(struct usb_descriptor_header *)&hidg_desc,
 	(struct usb_descriptor_header *)&hidg_fs_in_ep_desc,
@@ -218,6 +246,13 @@ static struct usb_descriptor_header *hidg_fs_descriptors[] = {
 	NULL,
 };
 
+static struct usb_descriptor_header *hidg_fs_descriptors_ssreport[] = {
+	(struct usb_descriptor_header *)&hidg_interface_desc,
+	(struct usb_descriptor_header *)&hidg_desc,
+	(struct usb_descriptor_header *)&hidg_fs_in_ep_desc,
+	NULL,
+};
+
 /*-------------------------------------------------------------------------*/
 /*                                 Strings                                 */
 
@@ -241,8 +276,8 @@ static struct usb_gadget_strings *ct_func_strings[] = {
 /*-------------------------------------------------------------------------*/
 /*                              Char Device                                */
 
-static ssize_t f_hidg_read(struct file *file, char __user *buffer,
-			size_t count, loff_t *ptr)
+static ssize_t f_hidg_intout_read(struct file *file, char __user *buffer,
+				  size_t count, loff_t *ptr)
 {
 	struct f_hidg *hidg = file->private_data;
 	struct f_hidg_req_list *list;
@@ -255,15 +290,15 @@ static ssize_t f_hidg_read(struct file *file, char __user *buffer,
 
 	spin_lock_irqsave(&hidg->read_spinlock, flags);
 
-#define READ_COND (!list_empty(&hidg->completed_out_req))
+#define READ_COND_INTOUT (!list_empty(&hidg->completed_out_req))
 
 	/* wait for at least one buffer to complete */
-	while (!READ_COND) {
+	while (!READ_COND_INTOUT) {
 		spin_unlock_irqrestore(&hidg->read_spinlock, flags);
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		if (wait_event_interruptible(hidg->read_queue, READ_COND))
+		if (wait_event_interruptible(hidg->read_queue, READ_COND_INTOUT))
 			return -ERESTARTSYS;
 
 		spin_lock_irqsave(&hidg->read_spinlock, flags);
@@ -313,6 +348,60 @@ static ssize_t f_hidg_read(struct file *file, char __user *buffer,
 	return count;
 }
 
+#define READ_COND_SSREPORT (hidg->set_report_buf != NULL)
+
+static ssize_t f_hidg_ssreport_read(struct file *file, char __user *buffer,
+				    size_t count, loff_t *ptr)
+{
+	struct f_hidg *hidg = file->private_data;
+	char *tmp_buf = NULL;
+	unsigned long flags;
+
+	if (!count)
+		return 0;
+
+	spin_lock_irqsave(&hidg->read_spinlock, flags);
+
+	while (!READ_COND_SSREPORT) {
+		spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		if (wait_event_interruptible(hidg->read_queue, READ_COND_SSREPORT))
+			return -ERESTARTSYS;
+
+		spin_lock_irqsave(&hidg->read_spinlock, flags);
+	}
+
+	count = min_t(unsigned int, count, hidg->set_report_length);
+	tmp_buf = hidg->set_report_buf;
+	hidg->set_report_buf = NULL;
+
+	spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+
+	if (tmp_buf != NULL) {
+		count -= copy_to_user(buffer, tmp_buf, count);
+		kfree(tmp_buf);
+	} else {
+		count = -ENOMEM;
+	}
+
+	wake_up(&hidg->read_queue);
+
+	return count;
+}
+
+static ssize_t f_hidg_read(struct file *file, char __user *buffer,
+			   size_t count, loff_t *ptr)
+{
+	struct f_hidg *hidg = file->private_data;
+
+	if (hidg->use_out_ep)
+		return f_hidg_intout_read(file, buffer, count, ptr);
+	else
+		return f_hidg_ssreport_read(file, buffer, count, ptr);
+}
+
 static void f_hidg_req_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_hidg *hidg = (struct f_hidg *)ep->driver_data;
@@ -433,14 +522,20 @@ static __poll_t f_hidg_poll(struct file *file, poll_table *wait)
 	if (WRITE_COND)
 		ret |= EPOLLOUT | EPOLLWRNORM;
 
-	if (READ_COND)
-		ret |= EPOLLIN | EPOLLRDNORM;
+	if (hidg->use_out_ep) {
+		if (READ_COND_INTOUT)
+			ret |= EPOLLIN | EPOLLRDNORM;
+	} else {
+		if (READ_COND_SSREPORT)
+			ret |= EPOLLIN | EPOLLRDNORM;
+	}
 
 	return ret;
 }
 
 #undef WRITE_COND
-#undef READ_COND
+#undef READ_COND_SSREPORT
+#undef READ_COND_INTOUT
 
 static int f_hidg_release(struct inode *inode, struct file *fd)
 {
@@ -467,7 +562,7 @@ static inline struct usb_request *hidg_alloc_ep_req(struct usb_ep *ep,
 	return alloc_ep_req(ep, length);
 }
 
-static void hidg_set_report_complete(struct usb_ep *ep, struct usb_request *req)
+static void hidg_intout_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_hidg *hidg = (struct f_hidg *) req->context;
 	struct usb_composite_dev *cdev = hidg->func.config->cdev;
@@ -502,6 +597,37 @@ static void hidg_set_report_complete(struct usb_ep *ep, struct usb_request *req)
 	}
 }
 
+static void hidg_ssreport_complete(struct usb_ep *ep, struct usb_request *req)
+{
+	struct f_hidg *hidg = (struct f_hidg *)req->context;
+	struct usb_composite_dev *cdev = hidg->func.config->cdev;
+	char *new_buf = NULL;
+	unsigned long flags;
+
+	if (req->status != 0 || req->buf == NULL || req->actual == 0) {
+		ERROR(cdev,
+		      "%s FAILED: status=%d, buf=%p, actual=%d\n",
+		      __func__, req->status, req->buf, req->actual);
+		return;
+	}
+
+	spin_lock_irqsave(&hidg->read_spinlock, flags);
+
+	new_buf = krealloc(hidg->set_report_buf, req->actual, GFP_ATOMIC);
+	if (new_buf == NULL) {
+		spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+		return;
+	}
+	hidg->set_report_buf = new_buf;
+
+	hidg->set_report_length = req->actual;
+	memcpy(hidg->set_report_buf, req->buf, req->actual);
+
+	spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+
+	wake_up(&hidg->read_queue);
+}
+
 static int hidg_setup(struct usb_function *f,
 		const struct usb_ctrlrequest *ctrl)
 {
@@ -549,7 +675,11 @@ static int hidg_setup(struct usb_function *f,
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
 		VDBG(cdev, "set_report | wLength=%d\n", ctrl->wLength);
-		goto stall;
+		if (hidg->use_out_ep)
+			goto stall;
+		req->complete = hidg_ssreport_complete;
+		req->context  = hidg;
+		goto respond;
 		break;
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
@@ -637,15 +767,18 @@ static void hidg_disable(struct usb_function *f)
 	unsigned long flags;
 
 	usb_ep_disable(hidg->in_ep);
-	usb_ep_disable(hidg->out_ep);
 
-	spin_lock_irqsave(&hidg->read_spinlock, flags);
-	list_for_each_entry_safe(list, next, &hidg->completed_out_req, list) {
-		free_ep_req(hidg->out_ep, list->req);
-		list_del(&list->list);
-		kfree(list);
+	if (hidg->out_ep) {
+		usb_ep_disable(hidg->out_ep);
+
+		spin_lock_irqsave(&hidg->read_spinlock, flags);
+		list_for_each_entry_safe(list, next, &hidg->completed_out_req, list) {
+			free_ep_req(hidg->out_ep, list->req);
+			list_del(&list->list);
+			kfree(list);
+		}
+		spin_unlock_irqrestore(&hidg->read_spinlock, flags);
 	}
-	spin_unlock_irqrestore(&hidg->read_spinlock, flags);
 
 	spin_lock_irqsave(&hidg->write_spinlock, flags);
 	if (!hidg->write_pending) {
@@ -691,8 +824,7 @@ static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		}
 	}
 
-
-	if (hidg->out_ep != NULL) {
+	if (hidg->use_out_ep && hidg->out_ep != NULL) {
 		/* restart endpoint */
 		usb_ep_disable(hidg->out_ep);
 
@@ -717,7 +849,7 @@ static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 					hidg_alloc_ep_req(hidg->out_ep,
 							  hidg->report_length);
 			if (req) {
-				req->complete = hidg_set_report_complete;
+				req->complete = hidg_intout_complete;
 				req->context  = hidg;
 				status = usb_ep_queue(hidg->out_ep, req,
 						      GFP_ATOMIC);
@@ -743,7 +875,8 @@ static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	}
 	return 0;
 disable_out_ep:
-	usb_ep_disable(hidg->out_ep);
+	if (hidg->out_ep)
+		usb_ep_disable(hidg->out_ep);
 free_req_in:
 	if (req_in)
 		free_ep_req(hidg->in_ep, req_in);
@@ -795,14 +928,21 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 		goto fail;
 	hidg->in_ep = ep;
 
-	ep = usb_ep_autoconfig(c->cdev->gadget, &hidg_fs_out_ep_desc);
-	if (!ep)
-		goto fail;
-	hidg->out_ep = ep;
+	hidg->out_ep = NULL;
+	if (hidg->use_out_ep) {
+		ep = usb_ep_autoconfig(c->cdev->gadget, &hidg_fs_out_ep_desc);
+		if (!ep)
+			goto fail;
+		hidg->out_ep = ep;
+	}
+
+	/* used only if use_out_ep == 1 */
+	hidg->set_report_buf = NULL;
 
 	/* set descriptor dynamic values */
 	hidg_interface_desc.bInterfaceSubClass = hidg->bInterfaceSubClass;
 	hidg_interface_desc.bInterfaceProtocol = hidg->bInterfaceProtocol;
+	hidg_interface_desc.bNumEndpoints = hidg->use_out_ep ? 2 : 1;
 	hidg->protocol = HID_REPORT_PROTOCOL;
 	hidg->idle = 1;
 	hidg_ss_in_ep_desc.wMaxPacketSize = cpu_to_le16(hidg->report_length);
@@ -833,9 +973,19 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	hidg_ss_out_ep_desc.bEndpointAddress =
 		hidg_fs_out_ep_desc.bEndpointAddress;
 
-	status = usb_assign_descriptors(f, hidg_fs_descriptors,
-			hidg_hs_descriptors, hidg_ss_descriptors,
-			hidg_ss_descriptors);
+	if (hidg->use_out_ep)
+		status = usb_assign_descriptors(f,
+			hidg_fs_descriptors_intout,
+			hidg_hs_descriptors_intout,
+			hidg_ss_descriptors_intout,
+			hidg_ss_descriptors_intout);
+	else
+		status = usb_assign_descriptors(f,
+			hidg_fs_descriptors_ssreport,
+			hidg_hs_descriptors_ssreport,
+			hidg_ss_descriptors_ssreport,
+			hidg_ss_descriptors_ssreport);
+
 	if (status)
 		goto fail;
 
@@ -950,6 +1100,7 @@ CONFIGFS_ATTR(f_hid_opts_, name)
 
 F_HID_OPT(subclass, 8, 255);
 F_HID_OPT(protocol, 8, 255);
+F_HID_OPT(no_out_endpoint, 8, 1);
 F_HID_OPT(report_length, 16, 65535);
 
 static ssize_t f_hid_opts_report_desc_show(struct config_item *item, char *page)
@@ -1009,6 +1160,7 @@ CONFIGFS_ATTR_RO(f_hid_opts_, dev);
 static struct configfs_attribute *hid_attrs[] = {
 	&f_hid_opts_attr_subclass,
 	&f_hid_opts_attr_protocol,
+	&f_hid_opts_attr_no_out_endpoint,
 	&f_hid_opts_attr_report_length,
 	&f_hid_opts_attr_report_desc,
 	&f_hid_opts_attr_dev,
@@ -1093,6 +1245,7 @@ static void hidg_free(struct usb_function *f)
 	hidg = func_to_hidg(f);
 	opts = container_of(f->fi, struct f_hid_opts, func_inst);
 	kfree(hidg->report_desc);
+	kfree(hidg->set_report_buf);
 	kfree(hidg);
 	mutex_lock(&opts->lock);
 	--opts->refcnt;
@@ -1139,6 +1292,7 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 			return ERR_PTR(-ENOMEM);
 		}
 	}
+	hidg->use_out_ep = !opts->no_out_endpoint;
 
 	mutex_unlock(&opts->lock);
 
diff --git a/drivers/usb/gadget/function/u_hid.h b/drivers/usb/gadget/function/u_hid.h
index 84e6da302499..fa631f34bb3d 100644
--- a/drivers/usb/gadget/function/u_hid.h
+++ b/drivers/usb/gadget/function/u_hid.h
@@ -20,6 +20,7 @@ struct f_hid_opts {
 	int				minor;
 	unsigned char			subclass;
 	unsigned char			protocol;
+	unsigned char			no_out_endpoint;
 	unsigned short			report_length;
 	unsigned short			report_desc_length;
 	unsigned char			*report_desc;
-- 
2.35.1



