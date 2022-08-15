Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787A1593585
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbiHOS1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242854AbiHOS0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:26:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B697729CB8;
        Mon, 15 Aug 2022 11:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA6D060ED3;
        Mon, 15 Aug 2022 18:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEBCC433C1;
        Mon, 15 Aug 2022 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587537;
        bh=ZxWz0hJH7CGyQ5XHjdFME7AxasqVLcjVOdfkOBfdryI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXpIh+U57DFlflcS/nwmKp5DRLmNxxd+PZjiqeOjMCHxNDArLHMqRkWfV4p1aO6No
         DPrIaabi8I92v+S48d68k7dkAYbLATUPsq1+ACu0ESJBnCm+pj6j1dfPsd4IkXWsVW
         goL9G/nWuAM1A/6QbxXwHW/iuW5ytikzYTO+6WrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/779] arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"
Date:   Mon, 15 Aug 2022 19:55:59 +0200
Message-Id: <20220815180342.246608756@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 46a0b4d6e251..db93ce2b0113 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -326,11 +326,6 @@ static void swsusp_mte_restore_tags(void)
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
index 7c1c82c8115c..10207e3e5ae2 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -44,15 +44,6 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
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
index 7c4ef56265ee..c52c1847079c 100644
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



