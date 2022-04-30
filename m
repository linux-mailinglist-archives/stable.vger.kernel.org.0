Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5F3515E90
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 17:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbiD3PKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiD3PKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 11:10:31 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C82785A2C0;
        Sat, 30 Apr 2022 08:07:09 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 0EE8392009E; Sat, 30 Apr 2022 17:07:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 085D092009D;
        Sat, 30 Apr 2022 16:07:09 +0100 (BST)
Date:   Sat, 30 Apr 2022 16:07:08 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     Joshua Kinard <kumba@gentoo.org>,
        Stephen Zhang <starzhangzsd@gmail.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] MIPS: IP27: Remove incorrect `cpu_has_fpu' override
In-Reply-To: <alpine.DEB.2.21.2204301559030.9383@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2204301600560.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2204301559030.9383@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu' 
kernel parameter non-functional, and also causes a link error:

ld: arch/mips/kernel/traps.o: in function `trap_init':
./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'

where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 0ebb2f4159af ("MIPS: IP27: Update/restructure CPU overrides")
Cc: stable@vger.kernel.org # v4.2+
---
Changes from v1:

- s/chosen/disabled/ in the change description.
---
 arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h |    1 -
 1 file changed, 1 deletion(-)

linux-mips-ip27-cpu-has-fpu.diff
Index: linux-macro/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
===================================================================
--- linux-macro.orig/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
+++ linux-macro/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
@@ -25,7 +25,6 @@
 #define cpu_has_4kex			1
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1
