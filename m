Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFC5F30FA
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJCNNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiJCNN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:29 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B724F1A3;
        Mon,  3 Oct 2022 06:13:06 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D69AF42FB5;
        Mon,  3 Oct 2022 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802779;
        bh=lXalvD3l5mjHNmEH1F6hPH8hmM1D5Am8NfgRI31Fpeg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Fjh0l9p92maTbn5ud6bWuMePifjEltUAg1ANIHvW5UW5MFp2LoCmNdF+/+XiWkx/Z
         5/8ne4GWx/Evkkw/ESZU2sXfBfaKO3PiEjAwC59ZwI9QPDs0EiXlyCqfIF9XUMp7Dd
         1gPcR/jQolSRZ35kyiSpXcLaYf/+nYrS+o2GMfyXq8X+aMPEKF86o7lNDOvXVAIoIE
         cIRhMBN4yAEVp9IXU16WblmcrX02Kjiwo1mWvnVKG+eDxM2vjuPXg43KjX58a1mICi
         qoL0ziZ7f5AUD1BhYE3q96zkF5xbLi1bn2RO9eilN+7SefnUz/zxVsyd7brVVNJ9ww
         w7nI+8qOe82cg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 35/37] x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
Date:   Mon,  3 Oct 2022 10:10:36 -0300
Message-Id: <20221003131038.12645-36-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit db886979683a8360ced9b24ab1125ad0c4d2cf76 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/nospec-branch.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index a95eec0cb787..191dfa98e4ad 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -11,6 +11,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
+#include <asm/percpu.h>
 
 /*
  * This should be used immediately before a retpoline alternative. It tells
@@ -296,7 +297,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern u64 x86_spec_ctrl_current;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
-- 
2.34.1

