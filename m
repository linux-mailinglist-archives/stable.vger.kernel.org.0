Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867B634CAC1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhC2Ijt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhC2Ii1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277EF61580;
        Mon, 29 Mar 2021 08:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007106;
        bh=eghLgthahG554ZGl0095jz9fFgId/FojoOKssZKR2NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNbQ1tpsgjYuByZl4Efts4V9ffm6OVM5GecAC/F/jWztsgnV49frgpWWo1t2VfgSP
         6hL4RhCXIUvnUVNj30NXUK4+3Er/18e6aZvEl5HlTdCPYrnxQJqbx5NJXP3oav6aWj
         OAhqdPOa7ivFoWOwN+koUGFddlV616TWj8xCnlTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 223/254] bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG
Date:   Mon, 29 Mar 2021 09:58:59 +0200
Message-Id: <20210329075640.419966788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit b9082970478009b778aa9b22d5561eef35b53b63 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 652bd64e422d..023ac12f54a2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1811,7 +1811,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 		im->ip_after_call = prog;
-		emit_nops(&prog, 5);
+		memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
+		prog += X86_PATCH_SIZE;
 	}
 
 	if (fmod_ret->nr_progs) {
-- 
2.30.1



