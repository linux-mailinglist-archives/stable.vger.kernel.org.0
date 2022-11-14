Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FAB6278DF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 10:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiKNJT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 04:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiKNJT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 04:19:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB16AE017
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 01:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF02B80D61
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 09:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66593C433D6;
        Mon, 14 Nov 2022 09:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668417560;
        bh=saECQ2yS6PlJevtDI4stbY/MNbrhbsmSEFS+ibRYzd8=;
        h=Subject:To:Cc:From:Date:From;
        b=0fuA5slYWQcR7ha6nyLBVUbTJz4Plu0uvnGX+9Lg+DA8WgmwLYO6xp9AK1zLStu3D
         XE5wnHkoIpdPkobJpNoCZxtkdDtzxVezVhVPnDDpheVS8cp054+vyZ0GkcJetRYBNV
         X/M4xB3HHF+ypy1l7YdIFBUrnt1xZhuVm9foDMtM=
Subject: FAILED: patch "[PATCH] arm64: fix rodata=full again" failed to apply to 6.0-stable tree
To:     ardb@kernel.org, catalin.marinas@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 10:19:16 +0100
Message-ID: <16684175567415@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2081b3bd0c11 ("arm64: fix rodata=full again")
b9dd04a20f81 ("arm64/mm: fold check for KFENCE into can_set_direct_map()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2081b3bd0c11757725dcab9ba5d38e1bddb03459 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 3 Nov 2022 18:00:15 +0100
Subject: [PATCH] arm64: fix rodata=full again

Commit 2e8cff0a0eee87b2 ("arm64: fix rodata=full") addressed a couple of
issues with the rodata= kernel command line option, which is not a
simple boolean on arm64, and inadvertently got broken due to changes in
the generic bool handling.

Unfortunately, the resulting code never clears the rodata_full boolean
variable if it defaults to true and rodata=on or rodata=off is passed,
as the generic code is not aware of the existence of this variable.

Given the way this code is plumbed together, clearing rodata_full when
returning false from arch_parse_debug_rodata() may result in
inconsistencies if the generic code decides that it cannot parse the
right hand side, so the best way to deal with this is to only take
rodata_full in account if rodata_enabled is also true.

Fixes: 2e8cff0a0eee ("arm64: fix rodata=full")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221103170015.4124426-1-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index d107c3d434e2..5922178d7a06 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -26,7 +26,7 @@ bool can_set_direct_map(void)
 	 * mapped at page granularity, so that it is possible to
 	 * protect/unprotect single pages.
 	 */
-	return rodata_full || debug_pagealloc_enabled() ||
+	return (rodata_enabled && rodata_full) || debug_pagealloc_enabled() ||
 		IS_ENABLED(CONFIG_KFENCE);
 }
 
@@ -102,7 +102,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * If we are manipulating read-only permissions, apply the same
 	 * change to the linear mapping of the pages that back this VM area.
 	 */
-	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
+	if (rodata_enabled &&
+	    rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
 			    pgprot_val(clear_mask) == PTE_RDONLY)) {
 		for (i = 0; i < area->nr_pages; i++) {
 			__change_memory_common((u64)page_address(area->pages[i]),

