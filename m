Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553535291CD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347505AbiEPUGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349146AbiEPT7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6881540E4F;
        Mon, 16 May 2022 12:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70B7760EE8;
        Mon, 16 May 2022 19:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C08C36AE5;
        Mon, 16 May 2022 19:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730803;
        bh=IbgkNa3Guz0qgnKUphoyCTvQihicvFTMv/ZnW1y5jqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jio/O7u203V8NUaZLx/SVFluL5j0Rw+G/2R/KxhFIIZzn3VGW9Fvjzk2RtzAdt7l5
         0A4wgmWxSdJ8KvXXinHDDqQam8GEly7G/JLLADOKlMPGaYkgaLA9oWH/L97wH7MK7i
         TZ+rHI1K+TRfgnmpzrPEUejDcPwQAFu82gdq0ksk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 011/114] fbdev: simplefb: Cleanup fb_info in .fb_destroy rather than .remove
Date:   Mon, 16 May 2022 21:35:45 +0200
Message-Id: <20220516193625.820751003@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 666b90b3ce9e4aac1e1deba266c3a230fb3913b0 ]

The driver is calling framebuffer_release() in its .remove callback, but
this will cause the struct fb_info to be freed too early. Since it could
be that a reference is still hold to it if user-space opened the fbdev.

This would lead to a use-after-free error if the framebuffer device was
unregistered but later a user-space process tries to close the fbdev fd.

To prevent this, move the framebuffer_release() call to fb_ops.fb_destroy
instead of doing it in the driver's .remove callback.

Strictly speaking, the code flow in the driver is still wrong because all
the hardware cleanupd (i.e: iounmap) should be done in .remove while the
software cleanup (i.e: releasing the framebuffer) should be done in the
.fb_destroy handler. But this at least makes to match the behavior before
commit 27599aacbaef ("fbdev: Hot-unplug firmware fb devices on forced removal").

Fixes: 27599aacbaef ("fbdev: Hot-unplug firmware fb devices on forced removal")
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220505220456.366090-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/simplefb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 57541887188b..efce6ef8532d 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -70,12 +70,18 @@ struct simplefb_par;
 static void simplefb_clocks_destroy(struct simplefb_par *par);
 static void simplefb_regulators_destroy(struct simplefb_par *par);
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
+ * of unregister_framebuffer() or fb_release(). Do any cleanup here.
+ */
 static void simplefb_destroy(struct fb_info *info)
 {
 	simplefb_regulators_destroy(info->par);
 	simplefb_clocks_destroy(info->par);
 	if (info->screen_base)
 		iounmap(info->screen_base);
+
+	framebuffer_release(info);
 }
 
 static const struct fb_ops simplefb_ops = {
@@ -520,8 +526,8 @@ static int simplefb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
+	/* simplefb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
-	framebuffer_release(info);
 
 	return 0;
 }
-- 
2.35.1



