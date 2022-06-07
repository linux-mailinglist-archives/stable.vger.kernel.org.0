Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53254176C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358461AbiFGVDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379106AbiFGVCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208D11207D2;
        Tue,  7 Jun 2022 11:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9255AB82018;
        Tue,  7 Jun 2022 18:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E50C385A2;
        Tue,  7 Jun 2022 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627590;
        bh=lIQbYf0TkVPgHqacQsbXEfI+WghXsnVMfGGAywaL/M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0EKsgWiZVMSNynHcHA4/KVLD5v3hbgSOKabO0/gS2Aqh5NnsAZg29WK5KsydYgWE
         7t1pI4snzs09o+Ml5N3fpccPyWgxM7Cs3AfitcDJVhbIVzIGkrgXEvJKrNCdGl73a/
         M84rO/zOsR7NR4lmk59yIqHnaH0IM3uNIP9ZXrYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 005/879] parisc/stifb: Keep track of hardware path of graphics card
Date:   Tue,  7 Jun 2022 18:52:03 +0200
Message-Id: <20220607165002.827279464@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit b046f984814af7985f444150ec28716d42d00d9a upstream.

Keep the pa_path (hardware path) of the graphics card in sti_struct and use
this info to give more useful info which card is currently being used.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/sticon.c  |    5 ++++-
 drivers/video/console/sticore.c |   15 +++++++--------
 drivers/video/fbdev/sticore.h   |    3 +++
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/font.h>
 #include <linux/crc32.h>
+#include <linux/fb.h>
 
 #include <asm/io.h>
 
@@ -392,7 +393,9 @@ static int __init sticonsole_init(void)
     for (i = 0; i < MAX_NR_CONSOLES; i++)
 	font_data[i] = STI_DEF_FONT;
 
-    pr_info("sticon: Initializing STI text console.\n");
+    pr_info("sticon: Initializing STI text console on %s at [%s]\n",
+	sticon_sti->sti_data->inq_outptr.dev_name,
+	sticon_sti->pa_path);
     console_lock();
     err = do_take_over_console(&sti_con, 0, MAX_NR_CONSOLES - 1,
 		PAGE0->mem_cons.cl_class != CL_DUPLEX);
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -34,7 +34,7 @@
 
 #include "../fbdev/sticore.h"
 
-#define STI_DRIVERVERSION "Version 0.9b"
+#define STI_DRIVERVERSION "Version 0.9c"
 
 static struct sti_struct *default_sti __read_mostly;
 
@@ -503,7 +503,7 @@ sti_select_fbfont(struct sti_cooked_rom
 	if (!fbfont)
 		return NULL;
 
-	pr_info("STI selected %ux%u framebuffer font %s for sticon\n",
+	pr_info("    using %ux%u framebuffer font %s\n",
 			fbfont->width, fbfont->height, fbfont->name);
 			
 	bpc = ((fbfont->width+7)/8) * fbfont->height; 
@@ -947,6 +947,7 @@ out_err:
 
 static void sticore_check_for_default_sti(struct sti_struct *sti, char *path)
 {
+	pr_info("    located at [%s]\n", sti->pa_path);
 	if (strcmp (path, default_sti_path) == 0)
 		default_sti = sti;
 }
@@ -958,7 +959,6 @@ static void sticore_check_for_default_st
  */
 static int __init sticore_pa_init(struct parisc_device *dev)
 {
-	char pa_path[21];
 	struct sti_struct *sti = NULL;
 	int hpa = dev->hpa.start;
 
@@ -971,8 +971,8 @@ static int __init sticore_pa_init(struct
 	if (!sti)
 		return 1;
 
-	print_pa_hwpath(dev, pa_path);
-	sticore_check_for_default_sti(sti, pa_path);
+	print_pa_hwpath(dev, sti->pa_path);
+	sticore_check_for_default_sti(sti, sti->pa_path);
 	return 0;
 }
 
@@ -1008,9 +1008,8 @@ static int sticore_pci_init(struct pci_d
 
 	sti = sti_try_rom_generic(rom_base, fb_base, pd);
 	if (sti) {
-		char pa_path[30];
-		print_pci_hwpath(pd, pa_path);
-		sticore_check_for_default_sti(sti, pa_path);
+		print_pci_hwpath(pd, sti->pa_path);
+		sticore_check_for_default_sti(sti, sti->pa_path);
 	}
 	
 	if (!sti) {
--- a/drivers/video/fbdev/sticore.h
+++ b/drivers/video/fbdev/sticore.h
@@ -370,6 +370,9 @@ struct sti_struct {
 
 	/* pointer to all internal data */
 	struct sti_all_data *sti_data;
+
+	/* pa_path of this device */
+	char pa_path[24];
 };
 
 


