Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26032573480
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbiGMKpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiGMKpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:45:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63B9F990A;
        Wed, 13 Jul 2022 03:45:10 -0700 (PDT)
Date:   Wed, 13 Jul 2022 10:45:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1657709108;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/THw7b/dbCSKOAhofrOGXHOh63A6XAgjMRnWLsvrJA=;
        b=SWRHQGrFhvX1JSx0tpSAfdznl8nLJM/Pt/acFI3bc7rikKSU/F+ZuCRKdi80iHrrIBYtb2
        Xv7x07Ck9C3SDJDOw9pI6n0NixRsuyhj/1Q4OcGNvy2WGRvE9IG/BiL2KR2TNJu5doCFLb
        sgAL7vj37zTlfO3ouUt7WWNLKVosqWfs4IcDXOrzYftqRZ2wUpkUAHdf6U/88GL6BtrzEO
        +gXwcgdHB62VCoZbfMjaFCFyS9U5vK7f5EQXMLsxWz+sM7fe67qQipqEcC3AXOQgoM8ajc
        PcFWA2TeKe2/JhJAoxXN6hDspUNnQgDaOrPY6CrwpGCl44XMt26e5cR07mzHpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1657709108;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/THw7b/dbCSKOAhofrOGXHOh63A6XAgjMRnWLsvrJA=;
        b=rT44xZSnfADOpOp06QXPTXhS17NuL63Tm7ajRHypv8VKr+jXQR6qTZnDnW/bRrSY5po16y
        wuWaIqr+umZBkDDQ==
From:   "tip-bot2 for Juergen Gross" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pat: Fix x86_has_pat_wp()
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220503132207.17234-1-jgross@suse.com>
References: <20220503132207.17234-1-jgross@suse.com>
MIME-Version: 1.0
Message-ID: <165770910660.15455.10226651626540518739.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     f0592491eba2e42cc84d7831750b84cfc0150dde
Gitweb:        https://git.kernel.org/tip/f0592491eba2e42cc84d7831750b84cfc0150dde
Author:        Juergen Gross <jgross@suse.com>
AuthorDate:    Fri, 08 Jul 2022 15:14:56 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 13 Jul 2022 12:21:03 +02:00

x86/pat: Fix x86_has_pat_wp()

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
---
 arch/x86/mm/init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d8cfce2..57ba550 100644
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
