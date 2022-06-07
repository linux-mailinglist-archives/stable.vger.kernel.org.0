Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D536540BCB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350957AbiFGSbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351518AbiFGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B175144FEC;
        Tue,  7 Jun 2022 10:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D68FDB8234A;
        Tue,  7 Jun 2022 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59772C34115;
        Tue,  7 Jun 2022 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624516;
        bh=QNxyg8a/EeMSToOh3j6ZgqqKkIM/59Fix+XBI1emb1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFJWMZcWL2GSKKvuM2lu+jeKO4KONdlvPvpP+pDUI/JyzeMeAcHX6v2iykc534Wue
         cpcVgapGcrkDnwq2bTMEnEzjTjpAZuc9+NCH5sx4buIDeEWqKJMpZptNs11MWC0pAL
         1o1fkpNOr9IbzP9q/65i+MOBcZ/UFhH8OvITEZep4ZH4s1MgNcVohGSUOT2hQnJsF4
         zMo31LE/b2NkixspG4EkL5OF0fd8gWfmIEVOFl+whlmawl+LULd5rt20NheMtyBbCI
         5NWlJoWcvzAEvkdm2WlsOdQmERtHuaXMkVmTFMS+NfT9o4dOKZpHHIGzakLSml6syd
         6ClJso+25N1uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, keescook@chromium.org
Subject: [PATCH AUTOSEL 5.17 47/60] x86/cpu: Elide KCSAN for cpu_has() and friends
Date:   Tue,  7 Jun 2022 13:52:44 -0400
Message-Id: <20220607175259.478835-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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
index 1261842d006c..49a3b122279e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -51,7 +51,7 @@ extern const char * const x86_power_flags[32];
 extern const char * const x86_bug_flags[NBUGINTS*32];
 
 #define test_cpu_cap(c, bit)						\
-	 test_bit(bit, (unsigned long *)((c)->x86_capability))
+	 arch_test_bit(bit, (unsigned long *)((c)->x86_capability))
 
 /*
  * There are 32 bits/features in each mask word.  The high bits
-- 
2.35.1

