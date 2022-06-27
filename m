Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02255D029
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbiF0Ln0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiF0Lmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70648DF0E;
        Mon, 27 Jun 2022 04:36:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279EAB81117;
        Mon, 27 Jun 2022 11:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6EAC36AE2;
        Mon, 27 Jun 2022 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329786;
        bh=4w0rb8WM7fGTNmflEmNCvYh4biFDvlmKXvwa62Cg0+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoDwWpmrih7xFRqP9a4roue5Dh0ee3BWOfMdDcylUGw2VVH8UmivwCbW8VkeAD7g2
         Yg+Wa62483WdyYFHOWwq9gVwr/axEB/RWsLiZ/siCZQlyk2k0+WZtD9ITkxERrKPNY
         Kru2yuIMSHB70KLsNw8KplnkZpYMaMKMD5mwmelM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.15 114/135] parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI
Date:   Mon, 27 Jun 2022 13:22:01 +0200
Message-Id: <20220627111941.461212505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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


