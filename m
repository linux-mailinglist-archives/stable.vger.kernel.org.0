Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD185404DB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbiFGRTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345690AbiFGRTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B421053D6;
        Tue,  7 Jun 2022 10:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1536618D2;
        Tue,  7 Jun 2022 17:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F9CC36AFF;
        Tue,  7 Jun 2022 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622341;
        bh=OQNA3pbhO751SWW63OLtmzQBzHLEIHa7GSdyG62NU3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9eebfuhIetQ6x3asgmU4z2poKION1WJtKFKyCGYyakO3K9NaIQccvhRzk9J/HEJX
         oxW7PNkSREWx0Yf1lJSVy5eMPkB6lWlDJ/FbHNkcKa5dDKPaXGkMdl5GDyTFih/AoA
         hg0mKUt40yvUDzV5fIATJer696tMKW/6ld71A7yQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 003/452] parisc/stifb: Implement fb_is_primary_device()
Date:   Tue,  7 Jun 2022 18:57:40 +0200
Message-Id: <20220607164908.631554091@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit cf936af790a3ef5f41ff687ec91bfbffee141278 upstream.

Implement fb_is_primary_device() function, so that fbcon detects if this
framebuffer belongs to the default graphics card which was used to start
the system.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/fb.h    |    4 ++++
 drivers/video/console/sticore.c |   17 +++++++++++++++++
 drivers/video/fbdev/stifb.c     |    4 ++--
 3 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/fb.h
+++ b/arch/parisc/include/asm/fb.h
@@ -12,9 +12,13 @@ static inline void fb_pgprotect(struct f
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
+#if defined(CONFIG_STI_CONSOLE) || defined(CONFIG_FB_STI)
+int fb_is_primary_device(struct fb_info *info);
+#else
 static inline int fb_is_primary_device(struct fb_info *info)
 {
 	return 0;
 }
+#endif
 
 #endif /* _ASM_FB_H_ */
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -30,6 +30,7 @@
 #include <asm/pdc.h>
 #include <asm/cacheflush.h>
 #include <asm/grfioctl.h>
+#include <asm/fb.h>
 
 #include "../fbdev/sticore.h"
 
@@ -1127,6 +1128,22 @@ int sti_call(const struct sti_struct *st
 	return ret;
 }
 
+/* check if given fb_info is the primary device */
+int fb_is_primary_device(struct fb_info *info)
+{
+	struct sti_struct *sti;
+
+	sti = sti_get_rom(0);
+
+	/* if no built-in graphics card found, allow any fb driver as default */
+	if (!sti)
+		return true;
+
+	/* return true if it's the default built-in framebuffer driver */
+	return (sti->info == info);
+}
+EXPORT_SYMBOL(fb_is_primary_device);
+
 MODULE_AUTHOR("Philipp Rumpf, Helge Deller, Thomas Bogendoerfer");
 MODULE_DESCRIPTION("Core STI driver for HP's NGLE series graphics cards in HP PARISC machines");
 MODULE_LICENSE("GPL v2");
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1317,11 +1317,11 @@ static int __init stifb_init_fb(struct s
 		goto out_err3;
 	}
 
+	/* save for primary gfx device detection & unregister_framebuffer() */
+	sti->info = info;
 	if (register_framebuffer(&fb->info) < 0)
 		goto out_err4;
 
-	sti->info = info; /* save for unregister_framebuffer() */
-
 	fb_info(&fb->info, "%s %dx%d-%d frame buffer device, %s, id: %04x, mmio: 0x%04lx\n",
 		fix->id,
 		var->xres, 


