Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3332558452
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiFWRlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiFWRje (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:39:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA76B629A;
        Thu, 23 Jun 2022 10:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7390A61D1E;
        Thu, 23 Jun 2022 17:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D24BC3411B;
        Thu, 23 Jun 2022 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004183;
        bh=x7UkBg+RxWxt1z+tw6F6BoYf8pSlWBssWhzPHanWVRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO/kMf7Y3I9K9P7Hi3P5tTSIEo+NH+JH1yfFTjZZIg/2NZOAxgNY4fQpJncounAlW
         gFUCq/z6wOW5/Gw5noEzOXdOiaOkr/gFp1+Q/6NY0KU3xu4SDJ365GnIvXW/fDrm+8
         +ttlMYJCtPahrEPlTV0upNFJGtmtNVX0Isbsrgh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 214/237] arm64: ftrace: fix branch range checks
Date:   Thu, 23 Jun 2022 18:44:08 +0200
Message-Id: <20220623164349.307153773@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 3eefdf9d1e406f3da47470b2854347009ffcb6fa ]

The branch range checks in ftrace_make_call() and ftrace_make_nop() are
incorrect, erroneously permitting a forwards branch of 128M and
erroneously rejecting a backwards branch of 128M.

This is because both functions calculate the offset backwards,
calculating the offset *from* the target *to* the branch, rather than
the other way around as the later comparisons expect.

If an out-of-range branch were erroeously permitted, this would later be
rejected by aarch64_insn_gen_branch_imm() as branch_imm_common() checks
the bounds correctly, resulting in warnings and the placement of a BRK
instruction. Note that this can only happen for a forwards branch of
exactly 128M, and so the caller would need to be exactly 128M bytes
below the relevant ftrace trampoline.

If an in-range branch were erroeously rejected, then:

* For modules when CONFIG_ARM64_MODULE_PLTS=y, this would result in the
  use of a PLT entry, which is benign.

  Note that this is the common case, as this is selected by
  CONFIG_RANDOMIZE_BASE (and therefore RANDOMIZE_MODULE_REGION_FULL),
  which distributions typically seelct. This is also selected by
  CONFIG_ARM64_ERRATUM_843419.

* For modules when CONFIG_ARM64_MODULE_PLTS=n, this would result in
  internal ftrace failures.

* For core kernel text, this would result in internal ftrace failues.

  Note that for this to happen, the kernel text would need to be at
  least 128M bytes in size, and typical configurations are smaller tha
  this.

Fix this by calculating the offset *from* the branch *to* the target in
both functions.

Fixes: f8af0b364e24 ("arm64: ftrace: don't validate branch via PLT in ftrace_make_nop()")
Fixes: e71a4e1bebaf ("arm64: ftrace: add support for far branches to dynamic ftrace")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Will Deacon <will@kernel.org>
Tested-by: "Ivan T. Ivanov" <iivanov@suse.de>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220614080944.1349146-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 6eefd5873aef..cd0b2fc94d3b 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -72,7 +72,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned long pc = rec->ip;
 	u32 old, new;
-	long offset = (long)pc - (long)addr;
+	long offset = (long)addr - (long)pc;
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
@@ -151,7 +151,7 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	unsigned long pc = rec->ip;
 	bool validate = true;
 	u32 old = 0, new;
-	long offset = (long)pc - (long)addr;
+	long offset = (long)addr - (long)pc;
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-- 
2.35.1



