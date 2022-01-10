Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D554891EF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbiAJHhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33970 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240186AbiAJHdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B172B8120C;
        Mon, 10 Jan 2022 07:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD818C36AED;
        Mon, 10 Jan 2022 07:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800009;
        bh=nV4sVNXe+91kbTnlCc0Bt4RlIYFySXGdtdmIaZEf19Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn3pmHAqkXKOEtfVHjoKHNz8Ck8J5Cfulpf56ohXbFDLctU2TjJ6yCOkJu0WTSo/Z
         BsJZo8UKhifKGvE2U6kLV6HjJl4U0SgdacVc91tqlVp6Wp4YbwbAiWQHRbuygNTYsY
         x6Ustfp6RWiE1/QCGWVVF2qw7KcjFoJWt90upUBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 48/72] fbdev: fbmem: add a helper to determine if an aperture is used by a fw fb
Date:   Mon, 10 Jan 2022 08:23:25 +0100
Message-Id: <20220110071823.172955307@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 9a45ac2320d0a6ae01880a30d4b86025fce4061b upstream.

Add a function for drivers to check if the a firmware initialized
fb is corresponds to their aperture.  This allows drivers to check if the
device corresponds to what the firmware set up as the display device.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=215203
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1840
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   47 +++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h               |    1 
 2 files changed, 48 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1760,6 +1760,53 @@ int remove_conflicting_framebuffers(stru
 EXPORT_SYMBOL(remove_conflicting_framebuffers);
 
 /**
+ * is_firmware_framebuffer - detect if firmware-configured framebuffer matches
+ * @a: memory range, users of which are to be checked
+ *
+ * This function checks framebuffer devices (initialized by firmware/bootloader)
+ * which use memory range described by @a. If @a matchesm the function returns
+ * true, otherwise false.
+ */
+bool is_firmware_framebuffer(struct apertures_struct *a)
+{
+	bool do_free = false;
+	bool found = false;
+	int i;
+
+	if (!a) {
+		a = alloc_apertures(1);
+		if (!a)
+			return false;
+
+		a->ranges[0].base = 0;
+		a->ranges[0].size = ~0;
+		do_free = true;
+	}
+
+	mutex_lock(&registration_lock);
+	/* check all firmware fbs and kick off if the base addr overlaps */
+	for_each_registered_fb(i) {
+		struct apertures_struct *gen_aper;
+
+		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
+			continue;
+
+		gen_aper = registered_fb[i]->apertures;
+		if (fb_do_apertures_overlap(gen_aper, a)) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&registration_lock);
+
+	if (do_free)
+		kfree(a);
+
+	return found;
+}
+EXPORT_SYMBOL(is_firmware_framebuffer);
+
+/**
  * remove_conflicting_pci_framebuffers - remove firmware-configured framebuffers for PCI devices
  * @pdev: PCI device
  * @name: requesting driver name
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -610,6 +610,7 @@ extern int remove_conflicting_pci_frameb
 					       const char *name);
 extern int remove_conflicting_framebuffers(struct apertures_struct *a,
 					   const char *name, bool primary);
+extern bool is_firmware_framebuffer(struct apertures_struct *a);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);


