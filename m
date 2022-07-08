Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DC056BA7C
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 15:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiGHNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 09:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiGHNPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 09:15:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F14DD98;
        Fri,  8 Jul 2022 06:15:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C220121ECC;
        Fri,  8 Jul 2022 13:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657286098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=36XAfuKXjscIMRoDtiDJGKATV58DDVN9bq8xNSF9IGE=;
        b=LOwT+zhDaiJgx3k1OdpAf7iPB3UfjhPRvulCjGstCP+2FsaxLiKewwWtC9llkLUIyeAlxb
        QxuaV7Ty2+jFclwaxx8SueMiQ/50/emx8Ogzkn5gCfShWmIWBMRfM8e3Um6ANNV0CNR983
        IPXbnduDUEYWkwF6+sRxyiYzSg6BRNM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6484213A80;
        Fri,  8 Jul 2022 13:14:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VH/ZFtItyGJYNQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 08 Jul 2022 13:14:58 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH v3] x86/pat: fix x86_has_pat_wp()
Date:   Fri,  8 Jul 2022 15:14:56 +0200
Message-Id: <20220708131456.5645-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: <stable@vger.kernel.org> # 4.14
Fixes: f88a68facd9a ("x86/mm: Extend early_memremap() support with additional attrs")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- fix indexing into __pte2cachemode_tbl[]
V3:
- expand commit message, add comment (Boris Petkov)
---
 arch/x86/mm/init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

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
-- 
2.35.3

