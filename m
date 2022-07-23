Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E230F57EE97
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiGWKNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiGWKNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974DE8AB3D;
        Sat, 23 Jul 2022 03:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B912BB82C1A;
        Sat, 23 Jul 2022 10:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10494C341C0;
        Sat, 23 Jul 2022 10:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570608;
        bh=iGIXm+MJ2pyHxJsG/SZdynCWcn2aikgM28KIxvJ1Ohg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CklgUZSWx3AKnrGehuhHcwRT+ZpPQtyBhaAKD4cn2zWku5wNIPMlJIeVhCaMrisHz
         vAGrLcCuBGnqDY9VmrfSXGRFvS7PHRWKswWlxbujIMpZ5eOaBximjk60iIh1yYIx0X
         8bCYzU3Cfuksrfih4DBpfNeO+XzobhoI999GdHHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 136/148] x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
Date:   Sat, 23 Jul 2022 11:55:48 +0200
Message-Id: <20220723095302.474417251@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -11,6 +11,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
+#include <asm/percpu.h>
 
 #define RETPOLINE_THUNK_SIZE	32
 
@@ -281,7 +282,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern u64 x86_spec_ctrl_current;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 


