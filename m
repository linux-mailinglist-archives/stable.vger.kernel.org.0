Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82D630A5B
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbiKSCZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235693AbiKSCXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:23:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E102E7FF06;
        Fri, 18 Nov 2022 18:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7817162833;
        Sat, 19 Nov 2022 02:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190BBC433D6;
        Sat, 19 Nov 2022 02:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824131;
        bh=G02EEvcYH5gnTW8yQ8yQBaC17QixYgFD0fZ0pWxC4Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHVZaQrhAJAqleI/XzufJhrtubR8a2RSDUR1PqjKmPpZZnq4ycdJZ6/F9P+0G5AgF
         urVfOGrdOPlh3k08qLMOZmH0x5hJaZ+l+vBqa7+7/5yVG3y1E6mWwyRY+WUxEI3c5T
         1rK3izcKnX5NqH83YV8V1xcid96FQhI084ZJzKG9e+IGlxrtzSshFSuRpArrzT9yi/
         NWh+qTaKZ2KMQ5Nt98uTnvnIZi/o2W7AEUvKncSqlJtcDl+8tw+slU9ojEzXJann0z
         Xn51qnu1tqt9Lr5RXeS4lCRTd66lvDh+p8vFh+cGaTo++xKHVBKv4SNXrBf8XYDkqE
         IWT2lK17/CjhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/18] arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.
Date:   Fri, 18 Nov 2022 21:14:57 -0500
Message-Id: <20221119021459.1775052-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021459.1775052-1-sashal@kernel.org>
References: <20221119021459.1775052-1-sashal@kernel.org>
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
index b383b4802a7b..d30217c21eff 100644
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

