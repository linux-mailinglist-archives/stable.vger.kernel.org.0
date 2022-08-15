Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4855950FD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiHPErK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiHPEqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94BC135;
        Mon, 15 Aug 2022 13:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AB7B80EAD;
        Mon, 15 Aug 2022 20:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7338C433C1;
        Mon, 15 Aug 2022 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596165;
        bh=hjKaXMlf/qIWQalHOBKYAOOd5KyNV3mEb9Uy2J+LTrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmQonE/wEyBv0mi49IW8ecY0dxSteQ+DLIUx0CGAS1Jl5j4sKB8dtn2q1yUw0MPsP
         YG61hhC97A55T/Tp1llyxbMzWPGN6t/3RSfP6Pjc6ZdQRqMD5RCW26IorlR3iMKAba
         OMIuw7sVxryhCs2kEywy4gz8quP7pavGwJDkua2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0993/1157] powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.
Date:   Mon, 15 Aug 2022 20:05:49 +0200
Message-Id: <20220815180519.444327738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



