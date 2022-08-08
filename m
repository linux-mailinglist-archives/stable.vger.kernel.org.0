Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A22958BED0
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242057AbiHHBct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiHHBcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9736B87C;
        Sun,  7 Aug 2022 18:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1060D60DDF;
        Mon,  8 Aug 2022 01:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C52C433C1;
        Mon,  8 Aug 2022 01:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922334;
        bh=UHJdW9c1sxzkkfsqewEfIRKTxn7cA7ASal24VdsM6Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBVYLXXDaCOzAczMsRdhMTZUQQErrcD6nixdPj6LRpwDSpHQq6YPQmQLtrB9SP7Jb
         kuvveiSp74CR4woF++us6ANLZMbzXi9f86wBAPLtaxmjZQTVwc1dYhFIkeB33YHJB2
         sG/n2GmBni9CfiTdb6WZ/UxIrCv9EJ6U02sj/O3o3l4bcKJnb8b+HxkPwnq8vVIH+8
         Sd6XWjremo4uHQkzpj1Af1cPLABETDYw0yW98h8fGKtMGPkZHMCKsT2Joc6kVeqscg
         elovSgJq5FDq++4g55py2Sy6iNnDmNlHuQIwnBEcjfe6fpQ1fPD40gzMsdNn/1xWFV
         3eyEEi/ooIlXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Sasha Levin <sashal@kernel.org>, pasha.tatashin@soleen.com,
        wangxiang@cdjrlc.com, keescook@chromium.org, broonie@kernel.org,
        wangkefeng.wang@huawei.com, mark.rutland@arm.com,
        tongtiangen@huawei.com, luis.machado@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 13/58] arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"
Date:   Sun,  7 Aug 2022 21:30:31 -0400
Message-Id: <20220808013118.313965-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit 20794545c14692094a882d2221c251c4573e6adf ]

This reverts commit e5b8d9218951e59df986f627ec93569a0d22149b.

Pages mapped in user-space with PROT_MTE have the allocation tags either
zeroed or copied/restored to some user values. In order for the kernel
to access such pages via page_address(), resetting the tag in
page->flags was necessary. This tag resetting was deferred to
set_pte_at() -> mte_sync_page_tags() but it can race with another CPU
reading the flags (via page_to_virt()):

P0 (mte_sync_page_tags):	P1 (memcpy from virt_to_page):
				  Rflags!=0xff
  Wflags=0xff
  DMB (doesn't help)
  Wtags=0
				  Rtags=0   // fault

Since now the post_alloc_hook() function resets the page->flags tag when
unpoisoning is skipped for user pages (including the __GFP_ZEROTAGS
case), revert the arm64 commit calling page_kasan_tag_reset().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Collingbourne <pcc@google.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20220610152141.2148929-5-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 5 -----
 arch/arm64/kernel/mte.c       | 9 ---------
 arch/arm64/mm/copypage.c      | 9 ---------
 arch/arm64/mm/mteswap.c       | 9 ---------
 4 files changed, 32 deletions(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 2e248342476e..af5df48ba915 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -300,11 +300,6 @@ static void swsusp_mte_restore_tags(void)
 		unsigned long pfn = xa_state.xa_index;
 		struct page *page = pfn_to_online_page(pfn);
 
-		/*
-		 * It is not required to invoke page_kasan_tag_reset(page)
-		 * at this point since the tags stored in page->flags are
-		 * already restored.
-		 */
 		mte_restore_page_tags(page_address(page), tags);
 
 		mte_free_tag_storage(tags);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index f6b00743c399..b2b730233274 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -48,15 +48,6 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (!pte_is_tagged)
 		return;
 
-	page_kasan_tag_reset(page);
-	/*
-	 * We need smp_wmb() in between setting the flags and clearing the
-	 * tags because if another thread reads page->flags and builds a
-	 * tagged address out of it, there is an actual dependency to the
-	 * memory access, but on the current thread we do not guarantee that
-	 * the new page->flags are visible before the tags were updated.
-	 */
-	smp_wmb();
 	mte_clear_page_tags(page_address(page));
 }
 
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 0dea80bf6de4..24913271e898 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -23,15 +23,6 @@ void copy_highpage(struct page *to, struct page *from)
 
 	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
 		set_bit(PG_mte_tagged, &to->flags);
-		page_kasan_tag_reset(to);
-		/*
-		 * We need smp_wmb() in between setting the flags and clearing the
-		 * tags because if another thread reads page->flags and builds a
-		 * tagged address out of it, there is an actual dependency to the
-		 * memory access, but on the current thread we do not guarantee that
-		 * the new page->flags are visible before the tags were updated.
-		 */
-		smp_wmb();
 		mte_copy_page_tags(kto, kfrom);
 	}
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index a9e50e930484..4334dec93bd4 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -53,15 +53,6 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
 	if (!tags)
 		return false;
 
-	page_kasan_tag_reset(page);
-	/*
-	 * We need smp_wmb() in between setting the flags and clearing the
-	 * tags because if another thread reads page->flags and builds a
-	 * tagged address out of it, there is an actual dependency to the
-	 * memory access, but on the current thread we do not guarantee that
-	 * the new page->flags are visible before the tags were updated.
-	 */
-	smp_wmb();
 	mte_restore_page_tags(page_address(page), tags);
 
 	return true;
-- 
2.35.1

