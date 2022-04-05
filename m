Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BD94F338D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344653AbiDEKkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243468AbiDEJjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E589A94FE;
        Tue,  5 Apr 2022 02:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF65861548;
        Tue,  5 Apr 2022 09:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC746C385A0;
        Tue,  5 Apr 2022 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150679;
        bh=Oz7kjiqQ9LAMJyU+ReyjeGZIzfRUeRrMLpi5UDQ8hN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB7hjj4EBNbqzAMlGjvL3QXDvekmeSqoTXaQR25ACGjii7jzNl87ASQ9HKjJjGR0w
         ACCTt08eZyGiPL0DiFDachgHnTUG5srRmEdAXZtPoC1RoRfa0qGzyyMmXBOdz0DbNt
         yKZ1qcWHQXSNcZQhmw8TaGWee3g95sPV0jYp3gyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Zack Rusin <zackr@vmware.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 142/913] fbdev: Hot-unplug firmware fb devices on forced removal
Date:   Tue,  5 Apr 2022 09:20:04 +0200
Message-Id: <20220405070344.089478544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 27599aacbaefcbf2af7b06b0029459bbf682000d upstream.

Hot-unplug all firmware-framebuffer devices as part of removing
them via remove_conflicting_framebuffers() et al. Releases all
memory regions to be acquired by native drivers.

Firmware, such as EFI, install a framebuffer while posting the
computer. After removing the firmware-framebuffer device from fbdev,
a native driver takes over the hardware and the firmware framebuffer
becomes invalid.

Firmware-framebuffer drivers, specifically simplefb, don't release
their device from Linux' device hierarchy. It still owns the firmware
framebuffer and blocks the native drivers from loading. This has been
observed in the vmwgfx driver. [1]

Initiating a device removal (i.e., hot unplug) as part of
remove_conflicting_framebuffers() removes the underlying device and
returns the memory range to the system.

[1] https://lore.kernel.org/dri-devel/20220117180359.18114-1-zack@kde.org/

v2:
	* rename variable 'dev' to 'device' (Javier)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
CC: stable@vger.kernel.org # v5.11+
Link: https://patchwork.freedesktop.org/patch/msgid/20220125091222.21457-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   29 ++++++++++++++++++++++++++---
 include/linux/fb.h               |    1 +
 2 files changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/linux_logo.h>
 #include <linux/proc_fs.h>
+#include <linux/platform_device.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
 #include <linux/kmod.h>
@@ -1557,18 +1558,36 @@ static void do_remove_conflicting_frameb
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for_each_registered_fb(i) {
 		struct apertures_struct *gen_aper;
+		struct device *device;
 
 		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
 			continue;
 
 		gen_aper = registered_fb[i]->apertures;
+		device = registered_fb[i]->device;
 		if (fb_do_apertures_overlap(gen_aper, a) ||
 			(primary && gen_aper && gen_aper->count &&
 			 gen_aper->ranges[0].base == VGA_FB_PHYS)) {
 
 			printk(KERN_INFO "fb%d: switching to %s from %s\n",
 			       i, name, registered_fb[i]->fix.id);
-			do_unregister_framebuffer(registered_fb[i]);
+
+			/*
+			 * If we kick-out a firmware driver, we also want to remove
+			 * the underlying platform device, such as simple-framebuffer,
+			 * VESA, EFI, etc. A native driver will then be able to
+			 * allocate the memory range.
+			 *
+			 * If it's not a platform device, at least print a warning. A
+			 * fix would add code to remove the device from the system.
+			 */
+			if (dev_is_platform(device)) {
+				registered_fb[i]->forced_out = true;
+				platform_device_unregister(to_platform_device(device));
+			} else {
+				pr_warn("fb%d: cannot remove device\n", i);
+				do_unregister_framebuffer(registered_fb[i]);
+			}
 		}
 	}
 }
@@ -1895,9 +1914,13 @@ EXPORT_SYMBOL(register_framebuffer);
 void
 unregister_framebuffer(struct fb_info *fb_info)
 {
-	mutex_lock(&registration_lock);
+	bool forced_out = fb_info->forced_out;
+
+	if (!forced_out)
+		mutex_lock(&registration_lock);
 	do_unregister_framebuffer(fb_info);
-	mutex_unlock(&registration_lock);
+	if (!forced_out)
+		mutex_unlock(&registration_lock);
 }
 EXPORT_SYMBOL(unregister_framebuffer);
 
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -502,6 +502,7 @@ struct fb_info {
 	} *apertures;
 
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
+	bool forced_out; /* set when being removed by another driver */
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {


