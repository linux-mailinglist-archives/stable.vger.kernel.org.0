Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00BD5945D4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351476AbiHOWwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352131AbiHOWu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:50:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1BD13790B;
        Mon, 15 Aug 2022 12:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB00FB80EB1;
        Mon, 15 Aug 2022 19:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60C7C433C1;
        Mon, 15 Aug 2022 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593240;
        bh=+5i3Ku8ynmuTRvV2CSEcO5qjFU81rtcPqBZQ8aw0a6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyshf22hQDUt7az4ejbPceFhmkoTyCGb+ibG+er91cwT9qEorcX2gyimiD4SzVlLx
         NtjI6PzVQlpaqIYPZK6daVYfEMUThzmycwLHeByHiysSYRKkOc8jEryCo9Kbtml3Ej
         6uyBp6ENqiN8ANXiUmP7Ryd2FMTrqPmLzAzUhUQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0916/1095] powerpc/32s: Fix boot failure with KASAN + SMP + JUMP_LABEL_FEATURE_CHECK_DEBUG
Date:   Mon, 15 Aug 2022 20:05:15 +0200
Message-Id: <20220815180507.174163072@linuxfoundation.org>
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

[ Upstream commit 6042a1652d643d1d34fa89bb314cb102960c0800 ]

Since commit 4291d085b0b0 ("powerpc/32s: Make pte_update() non
atomic on 603 core"), pte_update() has been using
mmu_has_feature(MMU_FTR_HPTE_TABLE) to avoid a useless atomic
operation on 603 cores.

When kasan_early_init() sets up the early zero shadow, it uses
__set_pte_at(). On book3s/32, __set_pte_at() calls pte_update()
when CONFIG_SMP is selected in order to ensure the preservation of
_PAGE_HASHPTE in case of concurrent update of the PTE. But that's
too early for mmu_has_feature(), so when
CONFIG_JUMP_LABEL_FEATURE_CHECK_DEBUG is selected, mmu_has_feature()
calls printk(). That's too early to call printk() because KASAN
early zero shadow page is not set up yet. It leads to a deadlock.

However, when kasan_early_init() is called, there is only one CPU
running and no risk of concurrent PTE update. So __set_pte_at() can
be called with the 'percpu' flag. With that flag set, the PTE is
written directly instead of being written via pte_update().

Fixes: 4291d085b0b0 ("powerpc/32s: Make pte_update() non atomic on 603 core")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2ee707512b8b212b079b877f4ceb525a1606a3fb.1656655567.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/kasan_init_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index f3e4d069e0ba..a70828a6d935 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -25,7 +25,7 @@ static void __init kasan_populate_pte(pte_t *ptep, pgprot_t prot)
 	int i;
 
 	for (i = 0; i < PTRS_PER_PTE; i++, ptep++)
-		__set_pte_at(&init_mm, va, ptep, pfn_pte(PHYS_PFN(pa), prot), 0);
+		__set_pte_at(&init_mm, va, ptep, pfn_pte(PHYS_PFN(pa), prot), 1);
 }
 
 int __init kasan_init_shadow_page_tables(unsigned long k_start, unsigned long k_end)
-- 
2.35.1



