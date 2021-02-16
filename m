Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95231D090
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 19:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhBPS5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 13:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhBPS5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 13:57:22 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B80AC061756
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 10:56:42 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id r2so5988626plr.10
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 10:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=17MvUHSR/AgsD2ojTRIPeb+N4hqhY0ccIpCcwV00IH4=;
        b=bU81mn5bjlxdT1FvqJlq3F5+Ogg1mW6QLVX0CbpPn4gMvLLeBWqRViI1sDXt63fd1O
         lDKFnarjzhgiFcjVlty8dt3xnXUMPG5gpOExOysz0neZYepLnafwa7vjtWuNxj7vJpLc
         KhIrSOHQlfL+peYkfyQX7j5J9o9zBIrEngWxz1GM9zwG8CTGFGgVgcAKnG2Hzw9R0oO0
         AabvqxeCoTG+NIOsWmJpnB6XlhygI1x+evewQOn2eP3mwIUivbOCFjvPvEQ5NL+5v3eR
         CyXLFdoT54thtNFqSBQPCwYjGFn5mi8Z2fjCnyw1NeaFsYaGtL9hI8bYj/rhnVU7jvRc
         EiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=17MvUHSR/AgsD2ojTRIPeb+N4hqhY0ccIpCcwV00IH4=;
        b=doXuPNjn02En4aI/fCP0+ET8Yoz8UsQrD+WnBsi9IWQcVcBI7De2e5LTy52TdpgPXh
         qaa7U7xWuOwHa2K3qyrXQMKe/JmjARoVfPQE4wCLWIuCMfEbDYUHt9HQ2k/4esJ2dn7i
         C7c54o9FdwmjMEm0Nvk+maT0fJmGArJYwQiOXGT+hCL4GYHmFbxV/jIwJukS4hqEMBkh
         yR6t1M8Wx7o+bXxvSchxgLNNeQPIYKKPiQLVBB3uq9epApUhVKy3xnMi6RfCJizJlqJG
         mSo1OQakBj5fa2GldjAKA3h2dbeVZs1a2bguLyidiSn2KXkxAXkPdhz5JIFiJUioY35g
         Adqw==
X-Gm-Message-State: AOAM530XQJa7631CGveJFu/MNuBwUid8BOEUdkFoqMu6lzqicB8bWCXx
        x1lzeNShiNyXxplVjPwGZQ==
X-Google-Smtp-Source: ABdhPJxZ9vFl4V3USp2xgsPb1vov7G0kNkXX1ZfRuPr5gG7AvK1CZlI+P810CJBkxsu91EAQWsBu1g==
X-Received: by 2002:a17:90b:1081:: with SMTP id gj1mr5673789pjb.231.1613501801831;
        Tue, 16 Feb 2021 10:56:41 -0800 (PST)
Received: from vivek-HP-15-Notebook-PC ([2405:201:a000:c08d:941e:ba54:cea6:30fc])
        by smtp.gmail.com with ESMTPSA id y16sm23590374pfb.83.2021.02.16.10.56.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Feb 2021 10:56:41 -0800 (PST)
From:   vivek <bitu.kv@gmail.com>
X-Google-Original-From: vivek <"vivek@bitu.kv"@gmail.com>
Received: by vivek-HP-15-Notebook-PC (Postfix, from userid 1000)
        id 985FE2437BE; Wed, 17 Feb 2021 00:26:34 +0530 (IST)
To:     bitu.kv@gmail.com
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        "# 5 . 10 . x" <stable@vger.kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page
Date:   Wed, 17 Feb 2021 00:26:31 +0530
Message-Id: <1613501791-13419-1-git-send-email-user@test.local.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

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
index e99edde..3e6331b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1701,16 +1701,12 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
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
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index dc9ada6..80b62fe 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -329,11 +329,12 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
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
-- 
2.7.4

