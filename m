Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB8759D81A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349043AbiHWJOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348671AbiHWJMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0796D576;
        Tue, 23 Aug 2022 01:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19CF76147B;
        Tue, 23 Aug 2022 08:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250DDC433C1;
        Tue, 23 Aug 2022 08:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243469;
        bh=mDDod5hoK9zUIp4GLrFxdxCIQSI8HzlisO5aPIIpYBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weXUF9jGuxizLED8U2nYYGYAH8rBGyk4ZRrlil22bAqMKnWaqfs9mU6T9zHz7+a8c
         eR7Hl9u3JQNeqHLGVyfwqFpFhsjgQQeEO2+sJtSI4hyGU71H3Tj15M2X9v9sFhnxyz
         hGEzNZK/GJ5kR547Ua+vObm8HPNRmrU/nwLeyQHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Tao Zhang <quic_taozha@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 287/365] coresight: etm4x: avoid build failure with unrolled loops
Date:   Tue, 23 Aug 2022 10:03:08 +0200
Message-Id: <20220823080130.208107606@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 4d45bc82df667ad9e9cb8361830e54fc1264e993 ]

When the following configs are enabled:
* CORESIGHT
* CORESIGHT_SOURCE_ETM4X
* UBSAN
* UBSAN_TRAP

Clang fails assemble the kernel with the error:
<instantiation>:1:7: error: expected constant expression in '.inst' directive
.inst (0xd5200000|((((2) << 19) | ((1) << 16) | (((((((((((0x160 + (i * 4))))) >> 2))) >> 7) & 0x7)) << 12) | ((((((((((0x160 + (i * 4))))) >> 2))) & 0xf)) << 8) | (((((((((((0x160 + (i * 4))))) >> 2))) >> 4) & 0x7)) << 5)))|(.L__reg_num_x8))
      ^
drivers/hwtracing/coresight/coresight-etm4x-core.c:702:4: note: while in
macro instantiation
etm4x_relaxed_read32(csa, TRCCNTVRn(i));
^
drivers/hwtracing/coresight/coresight-etm4x.h:403:4: note: expanded from
macro 'etm4x_relaxed_read32'
read_etm4x_sysreg_offset((offset), false)))
^
drivers/hwtracing/coresight/coresight-etm4x.h:383:12: note: expanded
from macro 'read_etm4x_sysreg_offset'
__val = read_etm4x_sysreg_const_offset((offset));       \
        ^
drivers/hwtracing/coresight/coresight-etm4x.h:149:2: note: expanded from
macro 'read_etm4x_sysreg_const_offset'
READ_ETM4x_REG(ETM4x_OFFSET_TO_REG(offset))
^
drivers/hwtracing/coresight/coresight-etm4x.h:144:2: note: expanded from
macro 'READ_ETM4x_REG'
read_sysreg_s(ETM4x_REG_NUM_TO_SYSREG((reg)))
^
arch/arm64/include/asm/sysreg.h:1108:15: note: expanded from macro
'read_sysreg_s'
asm volatile(__mrs_s("%0", r) : "=r" (__val));                  \
             ^
arch/arm64/include/asm/sysreg.h:1074:2: note: expanded from macro '__mrs_s'
"       mrs_s " v ", " __stringify(r) "\n"                      \
 ^

Consider the definitions of TRCSSCSRn and TRCCNTVRn:
drivers/hwtracing/coresight/coresight-etm4x.h:56
 #define TRCCNTVRn(n)      (0x160 + (n * 4))
drivers/hwtracing/coresight/coresight-etm4x.h:81
 #define TRCSSCSRn(n)      (0x2A0 + (n * 4))

Where the macro parameter is expanded to i; a loop induction variable
from etm4_disable_hw.

When any compiler can determine that loops may be unrolled, then the
__builtin_constant_p check in read_etm4x_sysreg_offset() defined in
drivers/hwtracing/coresight/coresight-etm4x.h may evaluate to true. This
can lead to the expression `(0x160 + (i * 4))` being passed to
read_etm4x_sysreg_const_offset. Via the trace above, this is passed
through READ_ETM4x_REG, read_sysreg_s, and finally to __mrs_s where it
is string-ified and used directly in inline asm.

Regardless of which compiler or compiler options determine whether a
loop can or can't be unrolled, which determines whether
__builtin_constant_p evaluates to true when passed an expression using a
loop induction variable, it is NEVER safe to allow the preprocessor to
construct inline asm like:
  asm volatile (".inst (0x160 + (i * 4))" : "=r"(__val));
                                 ^ expected constant expression

Instead of read_etm4x_sysreg_offset() using __builtin_constant_p(), use
__is_constexpr from include/linux/const.h instead to ensure only
expressions that are valid integer constant expressions get passed
through to read_sysreg_s().

This is not a bug in clang; it's a potentially unsafe use of the macro
arguments in read_etm4x_sysreg_offset dependent on __builtin_constant_p.

Link: https://github.com/ClangBuiltLinux/linux/issues/1310
Reported-by: Arnd Bergmann <arnd@kernel.org>
Reported-by: Tao Zhang <quic_taozha@quicinc.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220708231520.3958391-1-ndesaulniers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 33869c1d20c3..a7bfea31f7d8 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -7,6 +7,7 @@
 #define _CORESIGHT_CORESIGHT_ETM_H
 
 #include <asm/local.h>
+#include <linux/const.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include "coresight-priv.h"
@@ -515,7 +516,7 @@
 	({									\
 		u64 __val;							\
 										\
-		if (__builtin_constant_p((offset)))				\
+		if (__is_constexpr((offset)))					\
 			__val = read_etm4x_sysreg_const_offset((offset));	\
 		else								\
 			__val = etm4x_sysreg_read((offset), true, (_64bit));	\
-- 
2.35.1



