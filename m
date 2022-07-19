Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2553579D27
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiGSMri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiGSMqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB188AB02;
        Tue, 19 Jul 2022 05:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3E06182A;
        Tue, 19 Jul 2022 12:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF2FC341CA;
        Tue, 19 Jul 2022 12:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233082;
        bh=B5R6E+ddq8m5/lQLkLjA5+soKj5kmq3p6rjJ4fQbuHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/PweP/JoFVLgoeBmOhS744n19CQIjgrti/wD+kzCJTup5mckjpH6yLkoYQOd1WCl
         ID7CSOGyEbNLa5P5IYLWMCfQ+yamHp+Aal6/dRr+IH5axDUxA2ylYxApmYiit00R89
         01OvUzrjxrkq7PibKtjjLy9+wiL2MR5x//y5PhYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 167/167] x86/pat: Fix x86_has_pat_wp()
Date:   Tue, 19 Jul 2022 13:54:59 +0200
Message-Id: <20220719114712.619651806@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 230ec83d4299b30c51a1c133b4f2a669972cc08a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -78,10 +78,20 @@ static uint8_t __pte2cachemode_tbl[8] =
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


