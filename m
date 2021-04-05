Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D728353F63
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhDEJL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239020AbhDEJLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38593613B3;
        Mon,  5 Apr 2021 09:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613877;
        bh=G8Qg84PWMT9VQAkv24V0rf8JejJZcpYP2MBZLk/qk30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fcbb3M0L+7nMpchK54IMBQuAf+Ir2OxOF4HjlVGWUhY/M+UQANtO8J/5EoWurjGik
         Eg8yZBiOg5TwqBH/6bJBPX4LojIBr2NP7b+HU5YP2zGC4rwRfBcV5+NUxA30h3odRh
         PJerJ3VTliD7PStT5voh65cv0MHUuChC8zG+UKMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 126/126] bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG
Date:   Mon,  5 Apr 2021 10:54:48 +0200
Message-Id: <20210405085035.204608164@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

commit b9082970478009b778aa9b22d5561eef35b53b63 upstream.

__bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
emits non-atomic one which breaks fentry/fexit with k8 atomics:

P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)

Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
and running fexit_bpf2bpf selftest.

Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210320000001.915366-1-sdf@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1811,7 +1811,8 @@ int arch_prepare_bpf_trampoline(struct b
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 		im->ip_after_call = prog;
-		emit_nops(&prog, 5);
+		memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
+		prog += X86_PATCH_SIZE;
 	}
 
 	if (fmod_ret->nr_progs) {


