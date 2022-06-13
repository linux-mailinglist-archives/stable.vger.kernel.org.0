Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C5A549263
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350637AbiFMMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358531AbiFMMkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2966A5F26B;
        Mon, 13 Jun 2022 04:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEB7EB80EB5;
        Mon, 13 Jun 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D81C34114;
        Mon, 13 Jun 2022 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118618;
        bh=ZxmjvAyRXC2LFYdT7yWmSVT58DifZY7x0GFuK+Fi3t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifnmst9961mOJd8J9D3AfsPqLY4CPuiFKphFN3KeTOkZGjFzw/47y04NfYnhUSKMX
         FQFBhw1OrFym53Q3gFGzvDMFPsF1R13xQM2wncEyhiDENNUZ81P5V/zZuaS57TU1wO
         VWJ1nEoKkjC3cmUK2vqBkCzsinNBFlo4ywNwXwvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/172] x86/cpu: Elide KCSAN for cpu_has() and friends
Date:   Mon, 13 Jun 2022 12:11:41 +0200
Message-Id: <20220613094922.046118448@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



