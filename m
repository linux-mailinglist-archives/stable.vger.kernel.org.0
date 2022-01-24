Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A31497FA1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbiAXMhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:37:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47912 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239545AbiAXMhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:37:07 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EF6F221991;
        Mon, 24 Jan 2022 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643027825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sbKMhoGEFM5DRua4TCfIt+KaHZ7VwHUYL4HswVi+bMo=;
        b=OwR5ARjOuSDRN5wcsmRIcUffZwCKiNjx7N82ZbfaN/xJfI+ILCTvkrL1cOURwPwcWBASel
        J4xBTLrm4MZkuqZHzKWFY3jsZ/Hl9IcGvQwUeOnD/AijUDW4kWNlPr05oiqDeciOcDPJwv
        YGgcwIl60ZJJiKgP55RFRhbCqGCQJBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643027825;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sbKMhoGEFM5DRua4TCfIt+KaHZ7VwHUYL4HswVi+bMo=;
        b=BEcNSygkDqfP43s/dwnR8tP2DKv/C6Jmn64aTJwryrOESc+2LPuKMwe8Oqr+pi5HdQyiTX
        mAqZrjIkJn8IdfDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE28513BA4;
        Mon, 24 Jan 2022 12:37:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iB6UKXGd7mFyNQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 24 Jan 2022 12:37:05 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     zackr@vmware.com, javierm@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        hdegoede@redhat.com
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced removal
Date:   Mon, 24 Jan 2022 13:36:55 +0100
Message-Id: <20220124123659.4692-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124123659.4692-1-tzimmermann@suse.de>
References: <20220124123659.4692-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
CC: stable@vger.kernel.org # v5.11+
---
 drivers/video/fbdev/core/fbmem.c | 29 ++++++++++++++++++++++++++---
 include/linux/fb.h               |  1 +
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 0fa7ede94fa6..f73f8415b8cb 100644
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
@@ -1557,18 +1558,36 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for_each_registered_fb(i) {
 		struct apertures_struct *gen_aper;
+		struct device *dev;
 
 		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
 			continue;
 
 		gen_aper = registered_fb[i]->apertures;
+		dev = registered_fb[i]->device;
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
+			if (dev_is_platform(dev)) {
+				registered_fb[i]->forced_out = true;
+				platform_device_unregister(to_platform_device(dev));
+			} else {
+				pr_warn("fb%d: cannot remove device\n", i);
+				do_unregister_framebuffer(registered_fb[i]);
+			}
 		}
 	}
 }
@@ -1898,9 +1917,13 @@ EXPORT_SYMBOL(register_framebuffer);
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
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 3da95842b207..9a14f3f8a329 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -502,6 +502,7 @@ struct fb_info {
 	} *apertures;
 
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
+	bool forced_out; /* set when being removed by another driver */
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
-- 
2.34.1

