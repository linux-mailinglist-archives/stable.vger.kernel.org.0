Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE53A635A
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhFNLMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235593AbhFNLKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66DC26134F;
        Mon, 14 Jun 2021 10:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667628;
        bh=Q++CsxtREIC8FCY/1uPJKTt2EsZi3QGlUnJUgfmLe+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8WLJf2z45vjlRc6wEMq68Xf2JnF0mKY64nS0XluCI7jM7yuy0IgL1Ns5GEoKYnRP
         bL8IRyRkrAiNiFcDOnbBzAkDa2k0v1amRrUKQlbjHsfFHy4JcNqL6bj/IHA7bTibeX
         BebpuqijOHX7xQwBoLeVxOjyPO+lzF2tC06TqDE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 013/173] bpf: Add deny list of btf ids check for tracing programs
Date:   Mon, 14 Jun 2021 12:25:45 +0200
Message-Id: <20210614102658.593168410@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 35e3815fa8102fab4dee75f3547472c66581125d ]

The recursion check in __bpf_prog_enter and __bpf_prog_exit
leaves some (not inlined) functions unprotected:

In __bpf_prog_enter:
  - migrate_disable is called before prog->active is checked

In __bpf_prog_exit:
  - migrate_enable,rcu_read_unlock_strict are called after
    prog->active is decreased

When attaching trampoline to them we get panic like:

  traps: PANIC: double fault, error_code: 0x0
  double fault: 0000 [#1] SMP PTI
  RIP: 0010:__bpf_prog_enter+0x4/0x50
  ...
  Call Trace:
   <IRQ>
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   ...

Fixing this by adding deny list of btf ids for tracing
programs and checking btf id during program verification.
Adding above functions to this list.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210429114712.43783-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b186d852fe3d..9e600767803b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12556,6 +12556,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 	return 0;
 }
 
+BTF_SET_START(btf_id_deny)
+BTF_ID_UNUSED
+#ifdef CONFIG_SMP
+BTF_ID(func, migrate_disable)
+BTF_ID(func, migrate_enable)
+#endif
+#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
+BTF_ID(func, rcu_read_unlock_strict)
+#endif
+BTF_SET_END(btf_id_deny)
+
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
@@ -12615,6 +12626,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		ret = bpf_lsm_verify_prog(&env->log, prog);
 		if (ret < 0)
 			return ret;
+	} else if (prog->type == BPF_PROG_TYPE_TRACING &&
+		   btf_id_set_contains(&btf_id_deny, btf_id)) {
+		return -EINVAL;
 	}
 
 	key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
-- 
2.30.2



