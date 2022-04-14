Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D83500EE1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbiDNNWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243992AbiDNNUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:20:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE16E95490;
        Thu, 14 Apr 2022 06:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BCDDCE299A;
        Thu, 14 Apr 2022 13:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35959C385A9;
        Thu, 14 Apr 2022 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942235;
        bh=3SzeC/Gz/Ac+TTZClLIUog0e21eiXA/HtE2IFS8FnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdTOHJ56BUxNnMo/EdgqNfvzf7Xuw5Rn9unCIRp0tFgBMQAP5FPDCUWtX+NkeVakc
         KRD82x+BxekNFgvgrmlQICjmXVHt0f4EZSUpiU+LQ+zwOZOJRDsU4nK3nof39vXKiq
         aXjg+ifSJWop1rd0nx6fiS7TD7PkTea95YimS+S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 061/338] DEC: Limit PMAX memory probing to R3k systems
Date:   Thu, 14 Apr 2022 15:09:24 +0200
Message-Id: <20220414110840.634210404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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


