Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD826C19D7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjCTPiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjCTPi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D741DBA0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 110DFB80ED9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C6AC433EF;
        Mon, 20 Mar 2023 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326194;
        bh=g0Y3bHwbUpHEIJrYW+OpGGROrUU4EvSftGOGj7/WUWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhCcIKS9fV8s7ZkYe6PU43RneoJ9Bdsugn31/tbTS3NXJW2GlNS67FECZs6hkS+a/
         gOrpDFeQEH4w1zPPobFMviI8QiE5e5+DeoMGRSyXhGtujjWlLHzSO/q/fn/uCYH6EH
         JeJljFP59Xoj98EjKPX2zgTMWGcr5jiE5xvZoICM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.2 195/211] fbdev: Fix incorrect page mapping clearance at fb_deferred_io_release()
Date:   Mon, 20 Mar 2023 15:55:30 +0100
Message-Id: <20230320145521.701607214@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit fe9ae05cfbe587dda724fcf537c00bc2f287da62 upstream.

The recent fix for the deferred I/O by the commit
  3efc61d95259 ("fbdev: Fix invalid page access after closing deferred I/O devices")
caused a regression when the same fb device is opened/closed while
it's being used.  It resulted in a frozen screen even if something
is redrawn there after the close.  The breakage is because the patch
was made under a wrong assumption of a single open; in the current
code, fb_deferred_io_release() cleans up the page mapping of the
pageref list and it calls cancel_delayed_work_sync() unconditionally,
where both are no correct behavior for multiple opens.

This patch adds a refcount for the opens of the device, and applies
the cleanup only when all files get closed.

As both fb_deferred_io_open() and _close() are called always in the
fb_info lock (mutex), it's safe to use the normal int for the
refcounting.

Also, a useless BUG_ON() is dropped.

Fixes: 3efc61d95259 ("fbdev: Fix invalid page access after closing deferred I/O devices")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230308105012.1845-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_defio.c |   17 +++++++++++++----
 include/linux/fb.h                  |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -309,17 +309,18 @@ void fb_deferred_io_open(struct fb_info
 			 struct inode *inode,
 			 struct file *file)
 {
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
 	file->f_mapping->a_ops = &fb_deferred_io_aops;
+	fbdefio->open_count++;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
-void fb_deferred_io_release(struct fb_info *info)
+static void fb_deferred_io_lastclose(struct fb_info *info)
 {
-	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *page;
 	int i;
 
-	BUG_ON(!fbdefio);
 	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
@@ -328,13 +329,21 @@ void fb_deferred_io_release(struct fb_in
 		page->mapping = NULL;
 	}
 }
+
+void fb_deferred_io_release(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	if (!--fbdefio->open_count)
+		fb_deferred_io_lastclose(info);
+}
 EXPORT_SYMBOL_GPL(fb_deferred_io_release);
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	fb_deferred_io_release(info);
+	fb_deferred_io_lastclose(info);
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -212,6 +212,7 @@ struct fb_deferred_io {
 	/* delay between mkwrite and deferred handler */
 	unsigned long delay;
 	bool sort_pagereflist; /* sort pagelist by offset */
+	int open_count; /* number of opened files; protected by fb_info lock */
 	struct mutex lock; /* mutex that protects the pageref list */
 	struct list_head pagereflist; /* list of pagerefs for touched pages */
 	/* callback */


