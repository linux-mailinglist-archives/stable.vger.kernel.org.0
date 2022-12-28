Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4F658100
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiL1QXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiL1QW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:22:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3BD1A836
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF74F61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6B0C433D2;
        Wed, 28 Dec 2022 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244422;
        bh=IlAqDXUvJ4iIaZ6G/S0/eWkfBghb8GqAhsXMul4kkmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WcBVlpp7EOZ0OIGjKnvH2TCtYuMKgvMraI5qP4oVaegP+e0/sXWFr/YMsvFFVSom
         5c4Jkrk+7oOktp/9wvHP518agV/j59EI2g68Lx1k44A8t3eQQYK1LvpkBq0KznYhgV
         7ied9E155WjkL9oSPWuGqz+hYJXmYUmhRTYSHJY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0707/1073] usb: gadget: f_hid: fix f_hidg lifetime vs cdev
Date:   Wed, 28 Dec 2022 15:38:15 +0100
Message-Id: <20221228144347.236045698@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index ca0a7d9eaa34..8b8bbeaa27cb 100644
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
 
@@ -904,9 +912,7 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_ep		*ep;
 	struct f_hidg		*hidg = func_to_hidg(f);
 	struct usb_string	*us;
-	struct device		*device;
 	int			status;
-	dev_t			dev;
 
 	/* maybe allocate device-global string IDs, and patch descriptors */
 	us = usb_gstrings_attach(c->cdev, ct_func_strings,
@@ -999,21 +1005,11 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 
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
@@ -1244,9 +1240,7 @@ static void hidg_free(struct usb_function *f)
 
 	hidg = func_to_hidg(f);
 	opts = container_of(f->fi, struct f_hid_opts, func_inst);
-	kfree(hidg->report_desc);
-	kfree(hidg->set_report_buf);
-	kfree(hidg);
+	put_device(&hidg->dev);
 	mutex_lock(&opts->lock);
 	--opts->refcnt;
 	mutex_unlock(&opts->lock);
@@ -1256,8 +1250,7 @@ static void hidg_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_hidg *hidg = func_to_hidg(f);
 
-	device_destroy(hidg_class, MKDEV(major, hidg->minor));
-	cdev_del(&hidg->cdev);
+	cdev_device_del(&hidg->cdev, &hidg->dev);
 
 	usb_free_all_descriptors(f);
 }
@@ -1266,6 +1259,7 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 {
 	struct f_hidg *hidg;
 	struct f_hid_opts *opts;
+	int ret;
 
 	/* allocate and initialize one new instance */
 	hidg = kzalloc(sizeof(*hidg), GFP_KERNEL);
@@ -1277,17 +1271,27 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
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



