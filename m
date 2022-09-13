Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A295B71C6
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiIMOoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiIMOmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:42:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A306E2F7;
        Tue, 13 Sep 2022 07:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4AA9B80F97;
        Tue, 13 Sep 2022 14:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FABAC433D6;
        Tue, 13 Sep 2022 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078873;
        bh=0YoYNZ0VzzkVc9M9CtrMPhjFUH1yFxIrDxWCU2srcY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zt9nHRP5kPrpovQ+NEahDy7DtyPopjqrkuDgzvN471sALbvaNyY9o44Ymmo6etmzm
         3lSfjODAiWkka+UtP11Zq2AGkgyhCr6JBmYSVuU/yeYLy9HI9uzFjF/CFUl6icaqAk
         aDgSgVrIjUX2e8BqfbG/kDVl8X6ONMm9onVK3A7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/121] Revert "arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags""
Date:   Tue, 13 Sep 2022 16:05:06 +0200
Message-Id: <20220913140402.301848843@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

This reverts commit add4bc9281e8704e5ab15616b429576c84f453a2.

On Mon, Sep 12, 2022 at 10:52:45AM +0100, Catalin Marinas wrote:
>I missed this (holidays) and it looks like it's in stable already. On
>its own it will likely break kasan_hw if used together with user-space
>MTE as this change relies on two previous commits:
>
>70c248aca9e7 ("mm: kasan: Skip unpoisoning of user pages")
>6d05141a3930 ("mm: kasan: Skip page unpoisoning only if __GFP_SKIP_KASAN_UNPOISON")
>
>The reason I did not cc stable is that there are other dependencies in
>this area. The potential issues without the above commits were rather
>theoretical, so take these patches rather as clean-ups/refactoring than
>fixes.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 5 +++++
 arch/arm64/kernel/mte.c       | 9 +++++++++
 arch/arm64/mm/copypage.c      | 9 +++++++++
 arch/arm64/mm/mteswap.c       | 9 +++++++++
 4 files changed, 32 insertions(+)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index db93ce2b0113b..46a0b4d6e2519 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -326,6 +326,11 @@ static void swsusp_mte_restore_tags(void)
 		unsigned long pfn = xa_state.xa_index;
 		struct page *page = pfn_to_online_page(pfn);
 
+		/*
+		 * It is not required to invoke page_kasan_tag_reset(page)
+		 * at this point since the tags stored in page->flags are
+		 * already restored.
+		 */
 		mte_restore_page_tags(page_address(page), tags);
 
 		mte_free_tag_storage(tags);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 10207e3e5ae20..7c1c82c8115cc 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -44,6 +44,15 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (!pte_is_tagged)
 		return;
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_clear_page_tags(page_address(page));
 }
 
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 24913271e898c..0dea80bf6de46 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -23,6 +23,15 @@ void copy_highpage(struct page *to, struct page *from)
 
 	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
 		set_bit(PG_mte_tagged, &to->flags);
+		page_kasan_tag_reset(to);
+		/*
+		 * We need smp_wmb() in between setting the flags and clearing the
+		 * tags because if another thread reads page->flags and builds a
+		 * tagged address out of it, there is an actual dependency to the
+		 * memory access, but on the current thread we do not guarantee that
+		 * the new page->flags are visible before the tags were updated.
+		 */
+		smp_wmb();
 		mte_copy_page_tags(kto, kfrom);
 	}
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index c52c1847079c1..7c4ef56265ee1 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -53,6 +53,15 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
 	if (!tags)
 		return false;
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_restore_page_tags(page_address(page), tags);
 
 	return true;
-- 
2.35.1



