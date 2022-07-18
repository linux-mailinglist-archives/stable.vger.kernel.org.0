Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A85786BF
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiGRPuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbiGRPuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:50:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C516E00D
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0570AB8163C
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 15:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE3DC341C0;
        Mon, 18 Jul 2022 15:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658159401;
        bh=v5OkgN48lEr0uz3hYDT2+Zg+yR4QtygLKHVcZW7NmkY=;
        h=Subject:To:Cc:From:Date:From;
        b=mPMrtfSg1cGj1/asLIK3nveLH9cTPeRusW605MY+lD4oovkkWYjobVtNLryHt4QlD
         hbeXXn7JWeKY/C+umniyMPHb0Ju4QzIQ8i9qJEXOLIdh4RByOdiJlxORNUjP0ayGUG
         q3Q04RdRqbypbzBkN9/fgoK7uLoC8CikMbZcpJOs=
Subject: FAILED: patch "[PATCH] x86/pat: Fix x86_has_pat_wp()" failed to apply to 4.14-stable tree
To:     jgross@suse.com, bp@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 17:49:49 +0200
Message-ID: <165815938910133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 230ec83d4299b30c51a1c133b4f2a669972cc08a Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Fri, 8 Jul 2022 15:14:56 +0200
Subject: [PATCH] x86/pat: Fix x86_has_pat_wp()

x86_has_pat_wp() is using a wrong test, as it relies on the normal
PAT configuration used by the kernel. In case the PAT MSR has been
setup by another entity (e.g. Xen hypervisor) it might return false
even if the PAT configuration is allowing WP mappings. This due to the
fact that when running as Xen PV guest the PAT MSR is setup by the
hypervisor and cannot be changed by the guest. This results in the WP
related entry to be at a different position when running as Xen PV
guest compared to the bare metal or fully virtualized case.

The correct way to test for WP support is:

1. Get the PTE protection bits needed to select WP mode by reading
   __cachemode2pte_tbl[_PAGE_CACHE_MODE_WP] (depending on the PAT MSR
   setting this might return protection bits for a stronger mode, e.g.
   UC-)
2. Translate those bits back into the real cache mode selected by those
   PTE bits by reading __pte2cachemode_tbl[__pte2cm_idx(prot)]
3. Test for the cache mode to be _PAGE_CACHE_MODE_WP

Fixes: f88a68facd9a ("x86/mm: Extend early_memremap() support with additional attrs")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 4.14
Link: https://lore.kernel.org/r/20220503132207.17234-1-jgross@suse.com

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d8cfce221275..57ba5502aecf 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -77,10 +77,20 @@ static uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
 };
 
-/* Check that the write-protect PAT entry is set for write-protect */
+/*
+ * Check that the write-protect PAT entry is set for write-protect.
+ * To do this without making assumptions how PAT has been set up (Xen has
+ * another layout than the kernel), translate the _PAGE_CACHE_MODE_WP cache
+ * mode via the __cachemode2pte_tbl[] into protection bits (those protection
+ * bits will select a cache mode of WP or better), and then translate the
+ * protection bits back into the cache mode using __pte2cm_idx() and the
+ * __pte2cachemode_tbl[] array. This will return the really used cache mode.
+ */
 bool x86_has_pat_wp(void)
 {
-	return __pte2cachemode_tbl[_PAGE_CACHE_MODE_WP] == _PAGE_CACHE_MODE_WP;
+	uint16_t prot = __cachemode2pte_tbl[_PAGE_CACHE_MODE_WP];
+
+	return __pte2cachemode_tbl[__pte2cm_idx(prot)] == _PAGE_CACHE_MODE_WP;
 }
 
 enum page_cache_mode pgprot2cachemode(pgprot_t pgprot)

