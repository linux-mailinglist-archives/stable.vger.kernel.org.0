Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6435F6214CF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiKHOFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiKHOFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E25686B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48557B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A9C433C1;
        Tue,  8 Nov 2022 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916312;
        bh=t4j1T1Lm7Q3Pbj2XKY0AtHkDYl4QukL5gejmK/myfTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIRNRWomE4g8mwTT6VZJl5dfFe+k1JTZGLJpZctXz9fpnLHq7DQ4CootePYEeME2n
         oI/1/QzHX2PJ3HxNDVAI9wfTsA/ho/pwOOPLluJ1SBrKQyM5tzpwY1sueNyXsnhlTv
         Q2YSVtSDpq7RmKknrToyELWja4fkcYL1h1X4U3Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akihiro HARAI <jharai0815@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 125/144] x86/syscall: Include asm/ptrace.h in syscall_wrapper header
Date:   Tue,  8 Nov 2022 14:40:02 +0100
Message-Id: <20221108133350.563299417@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <olsajiri@gmail.com>

commit 9440c42941606af4c379afa3cf8624f0dc43a629 upstream.

With just the forward declaration of the 'struct pt_regs' in
syscall_wrapper.h, the syscall stub functions:

  __[x64|ia32]_sys_*(struct pt_regs *regs)

will have different definition of 'regs' argument in BTF data
based on which object file they are defined in.

If the syscall's object includes 'struct pt_regs' definition,
the BTF argument data will point to a 'struct pt_regs' record,
like:

  [226] STRUCT 'pt_regs' size=168 vlen=21
         'r15' type_id=1 bits_offset=0
         'r14' type_id=1 bits_offset=64
         'r13' type_id=1 bits_offset=128
  ...

If not, it will point to a fwd declaration record:

  [15439] FWD 'pt_regs' fwd_kind=struct

and make bpf tracing program hooking on those functions unable
to access fields from 'struct pt_regs'.

Include asm/ptrace.h directly in syscall_wrapper.h to make sure all
syscalls see 'struct pt_regs' definition. This then results in BTF for
'__*_sys_*(struct pt_regs *regs)' functions to point to the actual
struct, not just the forward declaration.

  [ bp: No Fixes tag as this is not really a bug fix but "adjustment" so
    that BTF is happy. ]

Reported-by: Akihiro HARAI <jharai0815@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Cc: <stable@vger.kernel.org> # this is needed only for BTF so kernels >= 5.15
Link: https://lore.kernel.org/r/20221018122708.823792-1-jolsa@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/syscall_wrapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/syscall_wrapper.h b/arch/x86/include/asm/syscall_wrapper.h
index 59358d1bf880..fd2669b1cb2d 100644
--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_X86_SYSCALL_WRAPPER_H
 #define _ASM_X86_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 extern long __x64_sys_ni_syscall(const struct pt_regs *regs);
 extern long __ia32_sys_ni_syscall(const struct pt_regs *regs);
-- 
2.38.1



