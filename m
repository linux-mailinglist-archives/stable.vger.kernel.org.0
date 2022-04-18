Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5BD50548F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiDRNO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiDRNJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA33377E6;
        Mon, 18 Apr 2022 05:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB30861267;
        Mon, 18 Apr 2022 12:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AF5C385A8;
        Mon, 18 Apr 2022 12:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286160;
        bh=3SzeC/Gz/Ac+TTZClLIUog0e21eiXA/HtE2IFS8FnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Am3RNPLkFGglxlpZZjJxeNhypSOK1vnpDNQmLX/eRU+ZRYs8PiPwkvIFMfdM8ErJw
         2Lw68/AYCZnK2Zn4dzJA+ENSers/e8iK/MQQcRL+eDpJ7lJC0CM1r6d0+HzBaSdjtS
         gkEHh3YOcYIv6/yeFMbX99WSfPrQ4l2HcC5Ccx0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 048/284] DEC: Limit PMAX memory probing to R3k systems
Date:   Mon, 18 Apr 2022 14:10:29 +0200
Message-Id: <20220418121212.062614390@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 244eae91a94c6dab82b3232967d10eeb9dfa21c6 upstream.

Recent tightening of the opcode table in binutils so as to consistently
disallow the assembly or disassembly of CP0 instructions not supported
by the processor architecture chosen has caused a regression like below:

arch/mips/dec/prom/locore.S: Assembler messages:
arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this processor: r4600 (mips3) `rfe'

in a piece of code used to probe for memory with PMAX DECstation models,
which have non-REX firmware.  Those computers always have an R2000 CPU
and consequently the exception handler used in memory probing uses the
RFE instruction, which those processors use.

While adding 64-bit support this code was correctly excluded for 64-bit
configurations, however it should have also been excluded for irrelevant
32-bit configurations.  Do this now then, and only enable PMAX memory
probing for R3k systems.

Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # v2.6.12+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/Makefile      |    2 +-
 arch/mips/include/asm/dec/prom.h |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/arch/mips/dec/prom/Makefile
+++ b/arch/mips/dec/prom/Makefile
@@ -5,4 +5,4 @@
 
 lib-y			+= init.o memory.o cmdline.o identify.o console.o
 
-lib-$(CONFIG_32BIT)	+= locore.o
+lib-$(CONFIG_CPU_R3000)	+= locore.o
--- a/arch/mips/include/asm/dec/prom.h
+++ b/arch/mips/include/asm/dec/prom.h
@@ -47,16 +47,11 @@
  */
 #define REX_PROM_MAGIC		0x30464354
 
-#ifdef CONFIG_64BIT
-
-#define prom_is_rex(magic)	1	/* KN04 and KN05 are REX PROMs.  */
-
-#else /* !CONFIG_64BIT */
-
-#define prom_is_rex(magic)	((magic) == REX_PROM_MAGIC)
-
-#endif /* !CONFIG_64BIT */
-
+/* KN04 and KN05 are REX PROMs, so only do the check for R3k systems.  */
+static inline bool prom_is_rex(u32 magic)
+{
+	return !IS_ENABLED(CONFIG_CPU_R3000) || magic == REX_PROM_MAGIC;
+}
 
 /*
  * 3MIN/MAXINE PROM entry points for DS5000/1xx's, DS5000/xx's and


