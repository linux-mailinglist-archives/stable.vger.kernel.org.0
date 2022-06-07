Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D5540D62
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353844AbiFGSsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354051AbiFGSq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ABA18F2E1;
        Tue,  7 Jun 2022 11:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F4216617A7;
        Tue,  7 Jun 2022 17:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F4AC341C4;
        Tue,  7 Jun 2022 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624798;
        bh=ZxmjvAyRXC2LFYdT7yWmSVT58DifZY7x0GFuK+Fi3t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4XcStIn1E/4MmmxHYH7G47dU6JHF+4qH4+ZYArLUCR5v9nqxBVFDmzgiYDAZP5Vb
         OCOs9yzOeqZNpajrzfUoySe9mSzoiiZYiFGN83cZq6pz2PWl0bx5lli9EOkoi39v9G
         zenmi2k7TaOsMqooyJACoG5XeAGg90ju3HCeFD27HywzbrsBuqhPGu2zFWxww3CmBN
         0fxTREsrY6R7crdq2uUmSA9UsHQQ/hwb3ieZLSXo/TXYWe6aG3kbWXY9L01gCOGUax
         WgunIUw+weqSpg6LxLM7F3BOIA2XYNVgibKMQOo6SyZjshHsgYnNRq0gGr4XuojemK
         e3/jPDz1kLAWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, keescook@chromium.org, hpa@zytor.com
Subject: [PATCH AUTOSEL 5.10 31/38] x86/cpu: Elide KCSAN for cpu_has() and friends
Date:   Tue,  7 Jun 2022 13:58:26 -0400
Message-Id: <20220607175835.480735-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit a6a5eb269f6f3a2fe392f725a8d9052190c731e2 ]

As x86 uses the <asm-generic/bitops/instrumented-*.h> headers, the
regular forms of all bitops are instrumented with explicit calls to
KASAN and KCSAN checks. As these are explicit calls, these are not
suppressed by the noinstr function attribute.

This can result in calls to those check functions in noinstr code, which
objtool warns about:

vmlinux.o: warning: objtool: enter_from_user_mode+0x24: call to __kcsan_check_access() leaves .noinstr.text section
vmlinux.o: warning: objtool: syscall_enter_from_user_mode+0x28: call to __kcsan_check_access() leaves .noinstr.text section
vmlinux.o: warning: objtool: syscall_enter_from_user_mode_prepare+0x24: call to __kcsan_check_access() leaves .noinstr.text section
vmlinux.o: warning: objtool: irqentry_enter_from_user_mode+0x24: call to __kcsan_check_access() leaves .noinstr.text section

Prevent this by using the arch_*() bitops, which are the underlying
bitops without explciit instrumentation.

[null: Changelog]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220502111216.290518605@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 59bf91c57aa8..619c1f80a2ab 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -49,7 +49,7 @@ extern const char * const x86_power_flags[32];
 extern const char * const x86_bug_flags[NBUGINTS*32];
 
 #define test_cpu_cap(c, bit)						\
-	 test_bit(bit, (unsigned long *)((c)->x86_capability))
+	 arch_test_bit(bit, (unsigned long *)((c)->x86_capability))
 
 /*
  * There are 32 bits/features in each mask word.  The high bits
-- 
2.35.1

