Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DA05920BB
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbiHNPaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240320AbiHNP3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD250B4B0;
        Sun, 14 Aug 2022 08:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3D5B80B48;
        Sun, 14 Aug 2022 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0712C433C1;
        Sun, 14 Aug 2022 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490937;
        bh=mDDod5hoK9zUIp4GLrFxdxCIQSI8HzlisO5aPIIpYBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmVsbBFU/j93P+ja3YK1lSuc+16nTMIgn6iLNGT1lbqb7Gpbriw5Xx4XeO8EN3lqk
         FNYj8TSTV/yyMHfhpA/FgiF9WfCobQApoMdH3clhMMqjIGJCQoDxyhb4nOf/SyUN96
         S6fU2Wuuxnq7gAxRUFPYNDx4OEsjJ3DiwLSwoLknlBZBIl1VUnJrTQGnodZysIsore
         gVvtzA01RENGo0WhzAeDLzf4CNYwVbm8Ntzo516Ng7+tZpvYua1hgd3DVNKEX5bv/C
         oLIJ3xlAFLB7t/tDk492ZLiefhiIy51NPub6SxiwQh8Vxxp032Qo+C5VXAgHkB+aAS
         Qp/uKbUaamKqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Tao Zhang <quic_taozha@quicinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>, mathieu.poirier@linaro.org,
        alexander.shishkin@linux.intel.com, nathan@kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 32/64] coresight: etm4x: avoid build failure with unrolled loops
Date:   Sun, 14 Aug 2022 11:24:05 -0400
Message-Id: <20220814152437.2374207-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

