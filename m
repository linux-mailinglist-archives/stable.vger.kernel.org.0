Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A92541976
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378231AbiFGVWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380819AbiFGVRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4014D11;
        Tue,  7 Jun 2022 11:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6156156D;
        Tue,  7 Jun 2022 18:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74836C385A2;
        Tue,  7 Jun 2022 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628264;
        bh=llGja+X4n31hJKn0deRxlhzf0jQ73Msyq0QGEx0Miko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yj7gN2GxexagHeJiuI1KL5CTz4Op8ZSJxvbkRF5zfy/ygmPE6I+C3GckdHS0D91HI
         DidBllu95RduezUnrCm0mkz8dcpzlW1L0olEIZHitmf/JaN1+q4PzsxHKGxotju4mW
         NeYcnF7le05UNGAZID2Hl/V2Sh5s23seFeLPrUlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 266/879] fbdev: defio: fix the pagelist corruption
Date:   Tue,  7 Jun 2022 18:56:24 +0200
Message-Id: <20220607165010.570589106@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Chuansheng Liu <chuansheng.liu@intel.com>

[ Upstream commit 856082f021a28221db2c32bd0531614a8382be67 ]

Easily hit the below list corruption:
==
list_add corruption. prev->next should be next (ffffffffc0ceb090), but
was ffffec604507edc8. (prev=ffffec604507edc8).
WARNING: CPU: 65 PID: 3959 at lib/list_debug.c:26
__list_add_valid+0x53/0x80
CPU: 65 PID: 3959 Comm: fbdev Tainted: G     U
RIP: 0010:__list_add_valid+0x53/0x80
Call Trace:
 <TASK>
 fb_deferred_io_mkwrite+0xea/0x150
 do_page_mkwrite+0x57/0xc0
 do_wp_page+0x278/0x2f0
 __handle_mm_fault+0xdc2/0x1590
 handle_mm_fault+0xdd/0x2c0
 do_user_addr_fault+0x1d3/0x650
 exc_page_fault+0x77/0x180
 ? asm_exc_page_fault+0x8/0x30
 asm_exc_page_fault+0x1e/0x30
RIP: 0033:0x7fd98fc8fad1
==

Figure out the race happens when one process is adding &page->lru into
the pagelist tail in fb_deferred_io_mkwrite(), another process is
re-initializing the same &page->lru in fb_deferred_io_fault(), which is
not protected by the lock.

This fix is to init all the page lists one time during initialization,
it not only fixes the list corruption, but also avoids INIT_LIST_HEAD()
redundantly.

V2: change "int i" to "unsigned int i" (Geert Uytterhoeven)

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Fixes: 105a940416fc ("fbdev/defio: Early-out if page is already enlisted")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220318005003.51810-1-chuansheng.liu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 842c66b3e33d..6aaf6d0abf39 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -59,7 +59,6 @@ static vm_fault_t fb_deferred_io_fault(struct vm_fault *vmf)
 		printk(KERN_ERR "no mapping available\n");
 
 	BUG_ON(!page->mapping);
-	INIT_LIST_HEAD(&page->lru);
 	page->index = vmf->pgoff;
 
 	vmf->page = page;
@@ -213,6 +212,8 @@ static void fb_deferred_io_work(struct work_struct *work)
 void fb_deferred_io_init(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *page;
+	unsigned int i;
 
 	BUG_ON(!fbdefio);
 	mutex_init(&fbdefio->lock);
@@ -220,6 +221,12 @@ void fb_deferred_io_init(struct fb_info *info)
 	INIT_LIST_HEAD(&fbdefio->pagelist);
 	if (fbdefio->delay == 0) /* set a default of 1 s */
 		fbdefio->delay = HZ;
+
+	/* initialize all the page lists one time */
+	for (i = 0; i < info->fix.smem_len; i += PAGE_SIZE) {
+		page = fb_deferred_io_page(info, i);
+		INIT_LIST_HEAD(&page->lru);
+	}
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_init);
 
-- 
2.35.1



