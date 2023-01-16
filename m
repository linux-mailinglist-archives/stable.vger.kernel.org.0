Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E2466C7C0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjAPQeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbjAPQd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFB23B0C7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C576B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A6C433EF;
        Mon, 16 Jan 2023 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886096;
        bh=4HaWJ5ypt05dt8NSNGAQQZUq7pKycqWEt65RTRXcmsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hIo51PS7JJtKPN/arW4xmkj+oNlnF081mDfVfiY66w3lncBnYV95v7/N3m7GOTeh
         7ML9k0y2a98W/qJ/DSpjYuSOT936W5FlSpFIP2hrE2QTonhN4neQrTWcHBaZtl9sNw
         dicxkXs2fJMtleefJ0R8p5q+v56hmH9HnoxHNyB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 301/658] usb: gadget: f_hid: fix f_hidg lifetime vs cdev
Date:   Mon, 16 Jan 2023 16:46:29 +0100
Message-Id: <20230116154923.363596059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: John Keeping <john@metanate.com>

[ Upstream commit 89ff3dfac604614287ad5aad9370c3f984ea3f4b ]

The embedded struct cdev does not have its lifetime correctly tied to
the enclosing struct f_hidg, so there is a use-after-free if /dev/hidgN
is held open while the gadget is deleted.

This can readily be replicated with libusbgx's example programs (for
conciseness - operating directly via configfs is equivalent):

	gadget-hid
	exec 3<> /dev/hidg0
	gadget-vid-pid-remove
	exec 3<&-

Pull the existing device up in to struct f_hidg and make use of the
cdev_device_{add,del}() helpers.  This changes the lifetime of the
device object to match struct f_hidg, but note that it is still added
and deleted at the same time.

Fixes: 71adf1189469 ("USB: gadget: add HID gadget driver")
Tested-by: Lee Jones <lee@kernel.org>
Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20221122123523.3068034-2-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 52 ++++++++++++++++-------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 6fb2e1f560ec..464e0b376f7f 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -71,7 +71,7 @@ struct f_hidg {
 	wait_queue_head_t		write_queue;
 	struct usb_request		*req;
 
-	int				minor;
+	struct device			dev;
 	struct cdev			cdev;
 	struct usb_function		func;
 
@@ -84,6 +84,14 @@ static inline struct f_hidg *func_to_hidg(struct usb_function *f)
 	return container_of(f, struct f_hidg, func);
 }
 
+static void hidg_release(struct device *dev)
+{
+	struct f_hidg *hidg = container_of(dev, struct f_hidg, dev);
+
+	kfree(hidg->set_report_buf);
+	kfree(hidg);
+}
+
 /*-------------------------------------------------------------------------*/
 /*                           Static descriptors                            */
 
@@ -910,9 +918,7 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_ep		*ep;
 	struct f_hidg		*hidg = func_to_hidg(f);
 	struct usb_string	*us;
-	struct device		*device;
 	int			status;
-	dev_t			dev;
 
 	/* maybe allocate device-global string IDs, and patch descriptors */
 	us = usb_gstrings_attach(c->cdev, ct_func_strings,
@@ -1005,21 +1011,11 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 
 	/* create char device */
 	cdev_init(&hidg->cdev, &f_hidg_fops);
-	dev = MKDEV(major, hidg->minor);
-	status = cdev_add(&hidg->cdev, dev, 1);
+	status = cdev_device_add(&hidg->cdev, &hidg->dev);
 	if (status)
 		goto fail_free_descs;
 
-	device = device_create(hidg_class, NULL, dev, NULL,
-			       "%s%d", "hidg", hidg->minor);
-	if (IS_ERR(device)) {
-		status = PTR_ERR(device);
-		goto del;
-	}
-
 	return 0;
-del:
-	cdev_del(&hidg->cdev);
 fail_free_descs:
 	usb_free_all_descriptors(f);
 fail:
@@ -1250,9 +1246,7 @@ static void hidg_free(struct usb_function *f)
 
 	hidg = func_to_hidg(f);
 	opts = container_of(f->fi, struct f_hid_opts, func_inst);
-	kfree(hidg->report_desc);
-	kfree(hidg->set_report_buf);
-	kfree(hidg);
+	put_device(&hidg->dev);
 	mutex_lock(&opts->lock);
 	--opts->refcnt;
 	mutex_unlock(&opts->lock);
@@ -1262,8 +1256,7 @@ static void hidg_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_hidg *hidg = func_to_hidg(f);
 
-	device_destroy(hidg_class, MKDEV(major, hidg->minor));
-	cdev_del(&hidg->cdev);
+	cdev_device_del(&hidg->cdev, &hidg->dev);
 
 	usb_free_all_descriptors(f);
 }
@@ -1272,6 +1265,7 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 {
 	struct f_hidg *hidg;
 	struct f_hid_opts *opts;
+	int ret;
 
 	/* allocate and initialize one new instance */
 	hidg = kzalloc(sizeof(*hidg), GFP_KERNEL);
@@ -1283,17 +1277,27 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 	mutex_lock(&opts->lock);
 	++opts->refcnt;
 
-	hidg->minor = opts->minor;
+	device_initialize(&hidg->dev);
+	hidg->dev.release = hidg_release;
+	hidg->dev.class = hidg_class;
+	hidg->dev.devt = MKDEV(major, opts->minor);
+	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
+	if (ret) {
+		--opts->refcnt;
+		mutex_unlock(&opts->lock);
+		return ERR_PTR(ret);
+	}
+
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
 	hidg->report_length = opts->report_length;
 	hidg->report_desc_length = opts->report_desc_length;
 	if (opts->report_desc) {
-		hidg->report_desc = kmemdup(opts->report_desc,
-					    opts->report_desc_length,
-					    GFP_KERNEL);
+		hidg->report_desc = devm_kmemdup(&hidg->dev, opts->report_desc,
+						 opts->report_desc_length,
+						 GFP_KERNEL);
 		if (!hidg->report_desc) {
-			kfree(hidg);
+			put_device(&hidg->dev);
 			mutex_unlock(&opts->lock);
 			return ERR_PTR(-ENOMEM);
 		}
-- 
2.35.1



