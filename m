Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2F31BA11
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 14:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBONNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 08:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhBONNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 08:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E77864E29;
        Mon, 15 Feb 2021 13:13:05 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH stable-5.10.y] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page
Date:   Mon, 15 Feb 2021 13:13:03 +0000
Message-Id: <20210215131303.15395-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 68d54ceeec0e5fee4fb8048e6a04c193f32525ca upstream.

The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
-EIO.

A newly created (PROT_MTE) mapping points to the zero page which had its
tags zeroed during cpu_enable_mte(). If there were no prior writes to
this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
page does not have the PG_mte_tagged flag set.

Set PG_mte_tagged on the zero page when its tags are cleared during
boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
!PROT_MTE mappings pointing to the zero page, change the
__access_remote_tags() check to (vm_flags & VM_MTE) instead of
PG_mte_tagged.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Will Deacon <will@kernel.org>
Reported-by: Luis Machado <luis.machado@linaro.org>
Tested-by: Luis Machado <luis.machado@linaro.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210210180316.23654-1-catalin.marinas@arm.com
---
 arch/arm64/kernel/cpufeature.c | 6 +-----
 arch/arm64/kernel/mte.c        | 3 ++-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0a52e076153b..65a522fbd874 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1696,16 +1696,12 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
-	static bool cleared_zero_page = false;
-
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!cleared_zero_page) {
-		cleared_zero_page = true;
+	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
 		mte_clear_page_tags(lm_alias(empty_zero_page));
-	}
 }
 #endif /* CONFIG_ARM64_MTE */
 
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index ef15c8a2a49d..7a66a7d9c1ff 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -239,11 +239,12 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		 * would cause the existing tags to be cleared if the page
 		 * was never mapped with PROT_MTE.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!(vma->vm_flags & VM_MTE)) {
 			ret = -EOPNOTSUPP;
 			put_page(page);
 			break;
 		}
+		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
