Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD3560B5C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJXSjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiJXSjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:39:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52007B7ECA;
        Mon, 24 Oct 2022 10:21:26 -0700 (PDT)
Date:   Mon, 24 Oct 2022 17:10:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666631457;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGfm3vLqdme7A5E0vyS+E4k+G5iTckWHeneSgjrt6Us=;
        b=UKmarg7xrPzCAcoEp+bwHWS888Y2NGkmsLTIhizgYRqQ3yZPiiHF8I1CuMmQvXF0uPtkkU
        cLbUlYmJRN+oM4HWNXq3i0+CZB0h74B3bk48gsry6InceAr69b6cgPCIKSiBb/w+S3kTub
        /28XeC6D14gmQjexuCu3LZ86rnBfCCVBj8nblKU0OFrH15+oIeqsOgqzu2R6Z2+R5fBRyE
        FUxM3te0nwG3ZYLh7TkNtrWimUZmbwqFKmTQpIGsQGWLpqBaYa6Ms906yCltFUdqzMAZUi
        GpCXv8u0grRWg+2QYvlUPWD52JluOi8XUtvjcSN5z8vhUujPdXSgQR6XbhZf8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666631457;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGfm3vLqdme7A5E0vyS+E4k+G5iTckWHeneSgjrt6Us=;
        b=xtGsC+xq2tYNrwJEDZZ2euO/az4mPKT84I09CS6MNlNNkVmsn4eiB/REMA3+NP4GKNSYdE
        ghzTm+JYB3uScYBQ==
From:   "tip-bot2 for Jiri Olsa" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/syscall: Include asm/ptrace.h in syscall_wrapper header
Cc:     Akihiro HARAI <jharai0815@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Andrii Nakryiko <andrii@kernel.org>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221018122708.823792-1-jolsa@kernel.org>
References: <20221018122708.823792-1-jolsa@kernel.org>
MIME-Version: 1.0
Message-ID: <166663145589.401.720002161640534427.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9440c42941606af4c379afa3cf8624f0dc43a629
Gitweb:        https://git.kernel.org/tip/9440c42941606af4c379afa3cf8624f0dc43a629
Author:        Jiri Olsa <olsajiri@gmail.com>
AuthorDate:    Tue, 18 Oct 2022 14:27:08 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 24 Oct 2022 17:57:28 +02:00

x86/syscall: Include asm/ptrace.h in syscall_wrapper header

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
---
 arch/x86/include/asm/syscall_wrapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/syscall_wrapper.h b/arch/x86/include/asm/syscall_wrapper.h
index 59358d1..fd2669b 100644
--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_X86_SYSCALL_WRAPPER_H
 #define _ASM_X86_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 extern long __x64_sys_ni_syscall(const struct pt_regs *regs);
 extern long __ia32_sys_ni_syscall(const struct pt_regs *regs);
