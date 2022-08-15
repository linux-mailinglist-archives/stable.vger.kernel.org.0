Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3755943E2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351379AbiHOWwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351956AbiHOWuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:50:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A3A13728B;
        Mon, 15 Aug 2022 12:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED54EB80EB1;
        Mon, 15 Aug 2022 19:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF6C433C1;
        Mon, 15 Aug 2022 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593230;
        bh=hjKaXMlf/qIWQalHOBKYAOOd5KyNV3mEb9Uy2J+LTrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9FMMkVsQ2hrqsXJOVlmzx3JhJEUCVhGyv/Lt7y17Gvfeq+qDV2wi0b45VrJvXNWP
         scvU2ze3K6HJbpCVezCGrlXk8hq346b2TldX7B/eH5aO/+3u1aq2vSIZuhb/FEuk2E
         2gXhCoq3A7KXH1n5cpQLsyTQ5A4LtyR7CYtZ18eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0915/1095] powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.
Date:   Mon, 15 Aug 2022 20:05:14 +0200
Message-Id: <20220815180507.134696584@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 980bbf7ca72012d317617fcdbfabe8708e4cef29 ]

mark_initmem_nx() calls either mmu_mark_initmem_nx() or
set_memory_attr() based on return from v_block_mapped()
of _sinittext.

But we can now handle text and data independently, so that
text may be mapped by block even when data is mapped by pages.

On the 8xx for instance, at startup 32Mbytes of memory are
pinned in TLB. So the pinned entries need to go away for sinittext.

In next patch a BAT will be set to also covers sinittext on book3s/32.
So it will also be needed to call mmu_mark_initmem_nx() even when
data above sinittext is not mapped with BATs.

As this is highly dependent on the platform, call mmu_mark_initmem_nx()
regardless of data block mapping. Then the platform will know what to
do.

Modify 8xx mmu_mark_initmem_nx() so that inittext mapping is modified
only when pagealloc debug and kfence are not active, otherwise inittext
is mapped with standard pages. And don't do anything on kernel text
which is already mapped with PAGE_KERNEL_TEXT.

Fixes: da1adea07576 ("powerpc/8xx: Allow STRICT_KERNEL_RwX with pinned TLB")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/db3fc14f3bfa6215b0786ef58a6e2bc1e1f964d7.1655202804.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/8xx.c | 4 ++--
 arch/powerpc/mm/pgtable_32.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 27f9186ae374..1ee08c3efe5b 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -179,8 +179,8 @@ void mmu_mark_initmem_nx(void)
 	unsigned long boundary = strict_kernel_rwx_enabled() ? sinittext : etext8;
 	unsigned long einittext8 = ALIGN(__pa(_einittext), SZ_8M);
 
-	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_TEXT, false);
-	mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL, false);
+	if (!debug_pagealloc_enabled_or_kfence())
+		mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL, false);
 
 	mmu_pin_tlb(block_mapped_ram, false);
 }
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index a56ade39dc68..3ac73f9fb5d5 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -135,9 +135,9 @@ void mark_initmem_nx(void)
 	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
 				 PFN_DOWN((unsigned long)_sinittext);
 
-	if (v_block_mapped((unsigned long)_sinittext)) {
-		mmu_mark_initmem_nx();
-	} else {
+	mmu_mark_initmem_nx();
+
+	if (!v_block_mapped((unsigned long)_sinittext)) {
 		set_memory_nx((unsigned long)_sinittext, numpages);
 		set_memory_rw((unsigned long)_sinittext, numpages);
 	}
-- 
2.35.1



