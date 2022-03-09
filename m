Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB4E4D325A
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiCIQBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiCIQBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:01:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197331637E6;
        Wed,  9 Mar 2022 08:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AACD361672;
        Wed,  9 Mar 2022 16:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8741BC340E8;
        Wed,  9 Mar 2022 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841652;
        bh=6g3HeBO2zRKzOSmJFIYDEBU/mGaghVue+fBkH7lFoHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5q6/Zy+J7wOPQd3XsE9U/NGusYnSSxaw47lmXeyE4uy331HMtrlbQLR9sSr5uAcJ
         qU1y6vCqyTv0GLYu5ikYwxBbMbYkgI8qiMQY7JdbWlK90n+zvB7t0fcH4HRCC4BIZ4
         HQe9WKY4yznzxS1rkbay0btqKDcyTGkjANhSIjlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wang YanQing <udknight@gmail.com>, dhaval.giani@oracle.com,
        srinivas.eeda@oracle.com, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 01/24] x86/speculation: Add RETPOLINE_AMD support to the inline asm CALL_NOSPEC variant
Date:   Wed,  9 Mar 2022 16:59:14 +0100
Message-Id: <20220309155856.340753414@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 0cbb76d6285794f30953bfa3ab831714b59dd700 upstream.

..so that they match their asm counterpart.

Add the missing ANNOTATE_NOSPEC_ALTERNATIVE in CALL_NOSPEC, while at it.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wang YanQing <udknight@gmail.com>
Cc: dhaval.giani@oracle.com
Cc: srinivas.eeda@oracle.com
Link: http://lkml.kernel.org/r/c3975665-173e-4d70-8dee-06c926ac26ee@default
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -172,11 +172,15 @@
  */
 # define CALL_NOSPEC						\
 	ANNOTATE_NOSPEC_ALTERNATIVE				\
-	ALTERNATIVE(						\
+	ALTERNATIVE_2(						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
 	"call __x86_indirect_thunk_%V[thunk_target]\n",		\
-	X86_FEATURE_RETPOLINE)
+	X86_FEATURE_RETPOLINE,					\
+	"lfence;\n"						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"call *%[thunk_target]\n",				\
+	X86_FEATURE_RETPOLINE_AMD)
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
 #elif defined(CONFIG_X86_32) && defined(CONFIG_RETPOLINE)
@@ -186,7 +190,8 @@
  * here, anyway.
  */
 # define CALL_NOSPEC						\
-	ALTERNATIVE(						\
+	ANNOTATE_NOSPEC_ALTERNATIVE				\
+	ALTERNATIVE_2(						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
 	"       jmp    904f;\n"					\
@@ -201,7 +206,11 @@
 	"       ret;\n"						\
 	"       .align 16\n"					\
 	"904:	call   901b;\n",				\
-	X86_FEATURE_RETPOLINE)
+	X86_FEATURE_RETPOLINE,					\
+	"lfence;\n"						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"call *%[thunk_target]\n",				\
+	X86_FEATURE_RETPOLINE_AMD)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #else /* No retpoline for C / inline asm */


