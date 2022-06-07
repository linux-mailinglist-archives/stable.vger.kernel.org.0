Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C635410C0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355144AbiFGT3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356864AbiFGT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FE798766;
        Tue,  7 Jun 2022 11:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6EB71CE2439;
        Tue,  7 Jun 2022 18:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581D7C385A2;
        Tue,  7 Jun 2022 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625471;
        bh=OQNA3pbhO751SWW63OLtmzQBzHLEIHa7GSdyG62NU3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5Z4fHyzrl/i7h+cqOK9JDMBIMI4xXaBTwL5kxFOc6/ZAfqIqwxVoDxIBFzqxvr4Q
         eaXDPIVffyLFdpNu41SrMGnMHfHWa84vH83hRB3Cr64pidjEwTzBbePJWK/6K4yLhD
         axEPfzJHYR0RxMC2TcRBgXdoIXqTUmJZxenTo7Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.17 003/772] parisc/stifb: Implement fb_is_primary_device()
Date:   Tue,  7 Jun 2022 18:53:15 +0200
Message-Id: <20220607164949.091339911@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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


