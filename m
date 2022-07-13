Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5735739FB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiGMPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiGMPWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 11:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B1D46DB2;
        Wed, 13 Jul 2022 08:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6079A614AD;
        Wed, 13 Jul 2022 15:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33289C34114;
        Wed, 13 Jul 2022 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657725761;
        bh=M3s3z9XPrbSeW+ifjj4FlEwxjuV9nAI5u3w331qUeyQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oJNOIyWhDB/OL2qVkQeFvanYA9xYBoaLVB7SSptFZZGaax6vHQOYNKi04FQjuVjBP
         RQT3STyQhVJCuh69pd7dgNk+6GHzytZKFoX4B5mzy3H34qa2NTuzTQmTw2w+KHyHrt
         JuRM9czFqm/akALRtKKfZU/g9zf2O9OUYwSbDzu9nvQomSSlhglqH94HDk0oYoGKH2
         SyQVkxrQQ03sYnlJmXt+JXyJs7qycJwSZr8ISuJS9mxBSn/xaGlvs5CYcCmqhq+pfE
         LqrP/OQw4a7tiUD+sjYiZFmJO7wSxP0Q0FoGaXu8/Rse+dBkMKPxWbhySSP9xNaNPM
         4KR/HaDclrQ9w==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
Date:   Wed, 13 Jul 2022 08:22:22 -0700
Message-Id: <20220713152222.1697913-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
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

Clang warns:

  arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
  DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
                      ^
  arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
  extern u64 x86_spec_ctrl_current;
             ^
  1 error generated.

The declaration should be using DECLARE_PER_CPU instead so all
attributes stay in sync.

Cc: stable@vger.kernel.org
Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index bb05ed4f46bd..99a29c83adf8 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -6,6 +6,7 @@
 #include <linux/static_key.h>
 #include <linux/objtool.h>
 #include <linux/linkage.h>
+#include <linux/percpu.h>
 
 #include <asm/alternative.h>
 #include <asm/cpufeatures.h>
@@ -280,7 +281,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern u64 x86_spec_ctrl_current;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 

base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
-- 
2.37.1

