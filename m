Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2F53E359
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiFFHS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiFFHSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:18:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E42D11A3E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09CC1B811CF
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAABC385A9;
        Mon,  6 Jun 2022 07:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499929;
        bh=o63ne88BA1tzWlgLmYr1qAN2dBR9+AgK4tPn1ct+nIU=;
        h=Subject:To:Cc:From:Date:From;
        b=JAN8H5z6uPcSkGSBmtf7naJaAGSMQuQmv5fsEMye/9bxIn4M5C5cbASP7f6eScmU+
         DlbuTBR2YUuxzM5bu7fnQwrpAp040Wr4WFmzRISeW6x/6X3XeppRh37+qZJi0aM/oh
         Ve57bH0CO/c6ZW84RUDk2taTHwUM1oZrgcFf39mY=
Subject: FAILED: patch "[PATCH] parisc/stifb: Keep track of hardware path of graphics card" failed to apply to 5.10-stable tree
To:     deller@gmx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:18:38 +0200
Message-ID: <1654499918187107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b046f984814af7985f444150ec28716d42d00d9a Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Thu, 2 Jun 2022 13:55:26 +0200
Subject: [PATCH] parisc/stifb: Keep track of hardware path of graphics card

Keep the pa_path (hardware path) of the graphics card in sti_struct and use
this info to give more useful info which card is currently being used.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v5.10+

diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon.c
index 40496e9e9b43..f304163e87e9 100644
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
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 62005064911b..6a947ff96d6e 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -34,7 +34,7 @@
 
 #include "../fbdev/sticore.h"
 
-#define STI_DRIVERVERSION "Version 0.9b"
+#define STI_DRIVERVERSION "Version 0.9c"
 
 static struct sti_struct *default_sti __read_mostly;
 
@@ -503,7 +503,7 @@ sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 	if (!fbfont)
 		return NULL;
 
-	pr_info("STI selected %ux%u framebuffer font %s for sticon\n",
+	pr_info("    using %ux%u framebuffer font %s\n",
 			fbfont->width, fbfont->height, fbfont->name);
 			
 	bpc = ((fbfont->width+7)/8) * fbfont->height; 
@@ -947,6 +947,7 @@ static struct sti_struct *sti_try_rom_generic(unsigned long address,
 
 static void sticore_check_for_default_sti(struct sti_struct *sti, char *path)
 {
+	pr_info("    located at [%s]\n", sti->pa_path);
 	if (strcmp (path, default_sti_path) == 0)
 		default_sti = sti;
 }
@@ -958,7 +959,6 @@ static void sticore_check_for_default_sti(struct sti_struct *sti, char *path)
  */
 static int __init sticore_pa_init(struct parisc_device *dev)
 {
-	char pa_path[21];
 	struct sti_struct *sti = NULL;
 	int hpa = dev->hpa.start;
 
@@ -971,8 +971,8 @@ static int __init sticore_pa_init(struct parisc_device *dev)
 	if (!sti)
 		return 1;
 
-	print_pa_hwpath(dev, pa_path);
-	sticore_check_for_default_sti(sti, pa_path);
+	print_pa_hwpath(dev, sti->pa_path);
+	sticore_check_for_default_sti(sti, sti->pa_path);
 	return 0;
 }
 
@@ -1008,9 +1008,8 @@ static int sticore_pci_init(struct pci_dev *pd, const struct pci_device_id *ent)
 
 	sti = sti_try_rom_generic(rom_base, fb_base, pd);
 	if (sti) {
-		char pa_path[30];
-		print_pci_hwpath(pd, pa_path);
-		sticore_check_for_default_sti(sti, pa_path);
+		print_pci_hwpath(pd, sti->pa_path);
+		sticore_check_for_default_sti(sti, sti->pa_path);
 	}
 	
 	if (!sti) {
diff --git a/drivers/video/fbdev/sticore.h b/drivers/video/fbdev/sticore.h
index c338f7848ae2..0ebdd28a0b81 100644
--- a/drivers/video/fbdev/sticore.h
+++ b/drivers/video/fbdev/sticore.h
@@ -370,6 +370,9 @@ struct sti_struct {
 
 	/* pointer to all internal data */
 	struct sti_all_data *sti_data;
+
+	/* pa_path of this device */
+	char pa_path[24];
 };
 
 

