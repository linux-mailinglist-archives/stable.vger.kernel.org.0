Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6C630A80
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiKSC0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbiKSCZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:25:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABA1809BA;
        Fri, 18 Nov 2022 18:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71243B82677;
        Sat, 19 Nov 2022 02:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AB7C433D6;
        Sat, 19 Nov 2022 02:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824159;
        bh=eTIar0q5yTH0PjFlwz1Yo2cBoRr9/VhWQ+C9Y1j1S2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiRGQSEFpYMd9YQdWWlR6A39q7wbAlYiIEmXZLphLiON5U4wpjpSLoBIWoMGa78Vd
         HycjrF84GOiU+zvjIm/k4/SVAJ5B8BsNOVjo4pJl15O/6Xpv7bpoIHvfp+iftfhygE
         lbnZMlYZ5+Oy3DZCrFG3QB3hb4H+rER0wTGp4HLOBrFw7cuq2i23V+OIBYhj4mZXDX
         ENSvRgMVId1lLqORz/RhJ+jAIl/XDPKXqCiaWgjQYiDLxtOkv2vXBcHnO7/NlYpOGx
         WCk7TZ1WZR5QIB+l7ZcJROSFgSmTzs3GlNCtUCFKjeO1e4hH+0/MmlaK2ZLPkUGi80
         sZETXhBGCsgtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/11] arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.
Date:   Fri, 18 Nov 2022 21:15:41 -0500
Message-Id: <20221119021543.1775315-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021543.1775315-1-sashal@kernel.org>
References: <20221119021543.1775315-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit acfc35cfcee5df419391671ef1a631f43feee4e3 ]

Add the same change for ARM64 as done in the commit 9440c4294160
("x86/syscall: Include asm/ptrace.h in syscall_wrapper header") to
make sure all syscalls see 'struct pt_regs' definition and resulted
BTF for '__arm64_sys_*(struct pt_regs *regs)' functions point to
actual struct.

Without this patch, the BPF verifier refuses to load a tracing prog
which accesses pt_regs.

  bpf(BPF_PROG_LOAD, {prog_type=0x1a, ...}, 128) = -1 EACCES

With this patch, we can see the correct error, which saves us time
in debugging the prog.

  bpf(BPF_PROG_LOAD, {prog_type=0x1a, ...}, 128) = 4
  bpf(BPF_RAW_TRACEPOINT_OPEN, {raw_tracepoint={name=NULL, prog_fd=4}}, 128) = -1 ENOTSUPP

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221031215728.50389-1-kuniyu@amazon.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/syscall_wrapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/syscall_wrapper.h b/arch/arm64/include/asm/syscall_wrapper.h
index 06d880b3526c..43a20888bf19 100644
--- a/arch/arm64/include/asm/syscall_wrapper.h
+++ b/arch/arm64/include/asm/syscall_wrapper.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_SYSCALL_WRAPPER_H
 #define __ASM_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 #define SC_ARM64_REGS_TO_ARGS(x, ...)				\
 	__MAP(x,__SC_ARGS					\
-- 
2.35.1

