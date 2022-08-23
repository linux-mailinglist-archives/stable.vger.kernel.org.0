Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3256059E3B2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiHWM3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240770AbiHWM1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB047B08A7;
        Tue, 23 Aug 2022 02:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71C64B81C89;
        Tue, 23 Aug 2022 09:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B61C433D6;
        Tue, 23 Aug 2022 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247796;
        bh=kZjCwi/ZghYXD9yFoDyuDQAVaWe7B0FSLT4PDSpmsPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+gSZBWyIu51Jx/uL9kORnfHWP98Cd5gFQ4HRNwVoGVEQXc9/jtJDniMnDj8AXlxi
         Dkol5FUqTnL0W9GbWuqNOff7CLcDNbtGetZ9njmUXhFmZE/eB9s7hxZJ76FLDFnYmZ
         pTIqjkbt1XdOeBLk1RC4qBRQiB73L9o4PKwZK3C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/158] MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0
Date:   Tue, 23 Aug 2022 10:28:02 +0200
Message-Id: <20220823080051.868940324@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 74de14fe05dd6b151d73cb0c73c8ec874cbdcde6 ]

When CONFIG_XPA is enabled, Clang warns:

  arch/mips/mm/tlbex.c:629:24: error: converting the result of '<<' to a boolean; did you mean '(1 << _PAGE_NO_EXEC_SHIFT) != 0'? [-Werror,-Wint-in-bool-context]
          if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
                              ^
  arch/mips/include/asm/pgtable-bits.h:174:28: note: expanded from macro '_PAGE_NO_EXEC'
  # define _PAGE_NO_EXEC          (1 << _PAGE_NO_EXEC_SHIFT)
                                     ^
  arch/mips/mm/tlbex.c:2568:24: error: converting the result of '<<' to a boolean; did you mean '(1 << _PAGE_NO_EXEC_SHIFT) != 0'? [-Werror,-Wint-in-bool-context]
          if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
                                ^
  arch/mips/include/asm/pgtable-bits.h:174:28: note: expanded from macro '_PAGE_NO_EXEC'
  # define _PAGE_NO_EXEC          (1 << _PAGE_NO_EXEC_SHIFT)
                                     ^
  2 errors generated.

_PAGE_NO_EXEC can be '0' or '1 << _PAGE_NO_EXEC_SHIFT' depending on the
build and runtime configuration, which is what the negation operators
are trying to convey. To silence the warning, explicitly compare against
0 so the result of the '<<' operator is not implicitly converted to a
boolean.

According to its documentation, GCC enables -Wint-in-bool-context with
-Wall but this warning is not visible when building the same
configuration with GCC. It appears GCC only warns when compiling C++,
not C, although the documentation makes no note of this:
https://godbolt.org/z/x39q3brxf

Reported-by: Sudip Mukherjee (Codethink) <sudipm.mukherjee@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlbex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index a7521b8f7658..e8e3635dda09 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -633,7 +633,7 @@ static __maybe_unused void build_convert_pte_to_entrylo(u32 **p,
 		return;
 	}
 
-	if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
+	if (cpu_has_rixi && _PAGE_NO_EXEC != 0) {
 		if (fill_includes_sw_bits) {
 			UASM_i_ROTR(p, reg, reg, ilog2(_PAGE_GLOBAL));
 		} else {
@@ -2572,7 +2572,7 @@ static void check_pabits(void)
 	unsigned long entry;
 	unsigned pabits, fillbits;
 
-	if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
+	if (!cpu_has_rixi || _PAGE_NO_EXEC == 0) {
 		/*
 		 * We'll only be making use of the fact that we can rotate bits
 		 * into the fill if the CPU supports RIXI, so don't bother
-- 
2.35.1



