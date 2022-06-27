Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C966C55C1D4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiF0L3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbiF0L26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:28:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ECFA199;
        Mon, 27 Jun 2022 04:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5822614A2;
        Mon, 27 Jun 2022 11:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C05C341C7;
        Mon, 27 Jun 2022 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329264;
        bh=4w0rb8WM7fGTNmflEmNCvYh4biFDvlmKXvwa62Cg0+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYvy5j8MswRoXls0Q8yPT+FhqpKk87EkkqUa53/fb9I1nGFS3t1ScBUem01pqOjfA
         y+J6JQ7pL0unWai+gxwRk69OkM8nLc8gbn4iFZEQllxBdzsHNzR3jzlUqC2DrgIsez
         EYtS3jF6IEEXzjEwXpp01wwDTRAym6meFq0Vk50U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 087/102] parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI
Date:   Mon, 27 Jun 2022 13:21:38 +0200
Message-Id: <20220627111936.046180187@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 1d0811b03eb30b2f0793acaa96c6ce90b8b9c87a upstream.

Fix this build error noticed by the kernel test robot:

drivers/video/console/sticore.c:1132:5: error: redefinition of 'fb_is_primary_device'
 arch/parisc/include/asm/fb.h:18:19: note: previous definition of 'fb_is_primary_device'

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org   # v5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/fb.h    |    2 +-
 drivers/video/console/sticore.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/fb.h
+++ b/arch/parisc/include/asm/fb.h
@@ -12,7 +12,7 @@ static inline void fb_pgprotect(struct f
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
-#if defined(CONFIG_STI_CONSOLE) || defined(CONFIG_FB_STI)
+#if defined(CONFIG_FB_STI)
 int fb_is_primary_device(struct fb_info *info);
 #else
 static inline int fb_is_primary_device(struct fb_info *info)
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -1127,6 +1127,7 @@ int sti_call(const struct sti_struct *st
 	return ret;
 }
 
+#if defined(CONFIG_FB_STI)
 /* check if given fb_info is the primary device */
 int fb_is_primary_device(struct fb_info *info)
 {
@@ -1142,6 +1143,7 @@ int fb_is_primary_device(struct fb_info
 	return (sti->info == info);
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+#endif
 
 MODULE_AUTHOR("Philipp Rumpf, Helge Deller, Thomas Bogendoerfer");
 MODULE_DESCRIPTION("Core STI driver for HP's NGLE series graphics cards in HP PARISC machines");


