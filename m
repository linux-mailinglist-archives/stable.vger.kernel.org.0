Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAF6157CA
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiKBCjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiKBCjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D40D10FE3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD100601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79892C433D6;
        Wed,  2 Nov 2022 02:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356741;
        bh=rDAZAqLi/2LK4Tmx9shpZ7YC3VMmoVuygEsOtD3U9/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zP/sHVVrd9IMuBQNdxg9t9dD64TBqpIINwkGpwOAzr3p55boE9lmWF0/w+5n+Mc9J
         jtcV1XON8xFnN2Pk6xzE1uSRgVDDkRhx24mF26qL5WtQ9DqmiEmldgXes4jqzvqRrO
         GO1aQErcUEs1CAmVnOU4rxSzmQsitNj9wm3XPpPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyunwoo Kim <imv4bel@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 051/240] fbdev: smscufx: Fix several use-after-free bugs
Date:   Wed,  2 Nov 2022 03:30:26 +0100
Message-Id: <20221102022112.553808629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwoo Kim <imv4bel@gmail.com>

commit cc67482c9e5f2c80d62f623bcc347c29f9f648e1 upstream.

Several types of UAFs can occur when physically removing a USB device.

Adds ufx_ops_destroy() function to .fb_destroy of fb_ops, and
in this function, there is kref_put() that finally calls ufx_free().

This fix prevents multiple UAFs.

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/linux-fbdev/20221011153436.GA4446@ubuntu/
Cc: <stable@vger.kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/smscufx.c |   55 ++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -97,7 +97,6 @@ struct ufx_data {
 	struct kref kref;
 	int fb_count;
 	bool virtualized; /* true when physical usb device not present */
-	struct delayed_work free_framebuffer_work;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */
 	u8 *edid; /* null until we read edid from hw or get from sysfs */
@@ -1117,15 +1116,24 @@ static void ufx_free(struct kref *kref)
 {
 	struct ufx_data *dev = container_of(kref, struct ufx_data, kref);
 
-	/* this function will wait for all in-flight urbs to complete */
-	if (dev->urbs.count > 0)
-		ufx_free_urb_list(dev);
+	kfree(dev);
+}
 
-	pr_debug("freeing ufx_data %p", dev);
+static void ufx_ops_destory(struct fb_info *info)
+{
+	struct ufx_data *dev = info->par;
+	int node = info->node;
 
-	kfree(dev);
+	/* Assume info structure is freed after this point */
+	framebuffer_release(info);
+
+	pr_debug("fb_info for /dev/fb%d has been freed", node);
+
+	/* release reference taken by kref_init in probe() */
+	kref_put(&dev->kref, ufx_free);
 }
 
+
 static void ufx_release_urb_work(struct work_struct *work)
 {
 	struct urb_node *unode = container_of(work, struct urb_node,
@@ -1134,14 +1142,9 @@ static void ufx_release_urb_work(struct
 	up(&unode->dev->urbs.limit_sem);
 }
 
-static void ufx_free_framebuffer_work(struct work_struct *work)
+static void ufx_free_framebuffer(struct ufx_data *dev)
 {
-	struct ufx_data *dev = container_of(work, struct ufx_data,
-					    free_framebuffer_work.work);
 	struct fb_info *info = dev->info;
-	int node = info->node;
-
-	unregister_framebuffer(info);
 
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
@@ -1153,11 +1156,6 @@ static void ufx_free_framebuffer_work(st
 
 	dev->info = NULL;
 
-	/* Assume info structure is freed after this point */
-	framebuffer_release(info);
-
-	pr_debug("fb_info for /dev/fb%d has been freed", node);
-
 	/* ref taken in probe() as part of registering framebfufer */
 	kref_put(&dev->kref, ufx_free);
 }
@@ -1169,11 +1167,13 @@ static int ufx_ops_release(struct fb_inf
 {
 	struct ufx_data *dev = info->par;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev->fb_count--;
 
 	/* We can't free fb_info here - fbmem will touch it when we return */
 	if (dev->virtualized && (dev->fb_count == 0))
-		schedule_delayed_work(&dev->free_framebuffer_work, HZ);
+		ufx_free_framebuffer(dev);
 
 	if ((dev->fb_count == 0) && (info->fbdefio)) {
 		fb_deferred_io_cleanup(info);
@@ -1186,6 +1186,8 @@ static int ufx_ops_release(struct fb_inf
 
 	kref_put(&dev->kref, ufx_free);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1292,6 +1294,7 @@ static const struct fb_ops ufx_ops = {
 	.fb_blank = ufx_ops_blank,
 	.fb_check_var = ufx_ops_check_var,
 	.fb_set_par = ufx_ops_set_par,
+	.fb_destroy = ufx_ops_destory,
 };
 
 /* Assumes &info->lock held by caller
@@ -1673,9 +1676,6 @@ static int ufx_usb_probe(struct usb_inte
 		goto destroy_modedb;
 	}
 
-	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
-			  ufx_free_framebuffer_work);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
@@ -1748,10 +1748,12 @@ e_nomem:
 static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
+	struct fb_info *info;
 
 	mutex_lock(&disconnect_mutex);
 
 	dev = usb_get_intfdata(interface);
+	info = dev->info;
 
 	pr_debug("USB disconnect starting\n");
 
@@ -1765,12 +1767,15 @@ static void ufx_usb_disconnect(struct us
 
 	/* if clients still have us open, will be freed on last close */
 	if (dev->fb_count == 0)
-		schedule_delayed_work(&dev->free_framebuffer_work, 0);
+		ufx_free_framebuffer(dev);
 
-	/* release reference taken by kref_init in probe() */
-	kref_put(&dev->kref, ufx_free);
+	/* this function will wait for all in-flight urbs to complete */
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 
-	/* consider ufx_data freed */
+	pr_debug("freeing ufx_data %p", dev);
+
+	unregister_framebuffer(info);
 
 	mutex_unlock(&disconnect_mutex);
 }


