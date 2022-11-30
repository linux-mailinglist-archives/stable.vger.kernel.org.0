Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8B663D595
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiK3M30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiK3M30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:29:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416BB450AD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED8E3B81B34
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AA5C433D6;
        Wed, 30 Nov 2022 12:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669811362;
        bh=7yH4I7zW7AhDN2mfedSN/5mHrL5kUztvOyZWT1SqBcI=;
        h=Subject:To:Cc:From:Date:From;
        b=umV+l3LgYGSoaAZxW+awTOLi+OWHa70mhoCFA9Kf+QiCa7bWYSCFsfdcB/PMFvg0C
         mPj/PwJOeTv5PLn3NhTR/JAMIF4v8s0C9gDlOJMvJOhufe7tlfe41o3knm+LTp/QT3
         /8a1lZtfweNjTG2sb/DzCoRzGvH+e1JgPzAZsFK4=
Subject: FAILED: patch "[PATCH] x86/ioremap: Fix page aligned size calculation in" failed to apply to 5.4-stable tree
To:     mikelley@microsoft.com, bp@suse.de, dave.hansen@linux.intel.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:29:18 +0100
Message-ID: <1669811358103208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4dbd6a3e90e0 ("x86/ioremap: Fix page aligned size calculation in __ioremap_caller()")
ecdd6ee77b73 ("x86/mm/pat: Standardize on memtype_*() prefix for APIs")
f9b57cf80c8b ("x86/mm/pat: Move the memtype related files to arch/x86/mm/pat/")
baf65855baac ("x86/mm/pat: Harmonize 'struct memtype *' local variable and function parameter use")
ef35b0fcee23 ("x86/mm/pat: Create fixed width output in /sys/kernel/debug/x86/pat_memtype_list, similar to the E820 debug printouts")
aee7f91369a8 ("x86/mm/pat: Update the comments in pat.c and pat_interval.c and refresh the code a bit")
91298f1a302d ("x86/mm/pat: Fix off-by-one bugs in interval tree search")
1c134b198daa ("Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4dbd6a3e90e03130973688fd79e19425f720d999 Mon Sep 17 00:00:00 2001
From: Michael Kelley <mikelley@microsoft.com>
Date: Wed, 16 Nov 2022 10:41:24 -0800
Subject: [PATCH] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()

Current code re-calculates the size after aligning the starting and
ending physical addresses on a page boundary. But the re-calculation
also embeds the masking of high order bits that exceed the size of
the physical address space (via PHYSICAL_PAGE_MASK). If the masking
removes any high order bits, the size calculation results in a huge
value that is likely to immediately fail.

Fix this by re-calculating the page-aligned size first. Then mask any
high order bits using PHYSICAL_PAGE_MASK.

Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/1668624097-14884-2-git-send-email-mikelley@microsoft.com

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78c5bc654cff..6453fbaedb08 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -217,9 +217,15 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {

