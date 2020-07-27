Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71CE22EFCC
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbgG0OTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731384AbgG0OTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDB720775;
        Mon, 27 Jul 2020 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859561;
        bh=Iwpq0K3LI/457THLc5GqV5NyV/1EOMMNxj0I7YNH3+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMPW2erUX4tOs6PyrvRQUTJ54jOcf/rG5nk7rziQohGjF49X8ZRcLFYzPsVWmGdYx
         0s/m7+yBtAqe9JpIDrSjcNV8p06xq5RRT+ZVqiM7hYumWFhpovoC3gr8EZQwQxYZzD
         gIymdWRK3ug8XaIWleZZmdZSNg3S8GVrfQMxu3gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 005/179] bpf: Set the number of exception entries properly for subprograms
Date:   Mon, 27 Jul 2020 16:03:00 +0200
Message-Id: <20200727134932.932784098@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit c4c0bdc0d2d084ed847c7066bdf59fe2cd25aa17 ]

Currently, if a bpf program has more than one subprograms, each program will be
jitted separately. For programs with bpf-to-bpf calls the
prog->aux->num_exentries is not setup properly. For example, with
bpf_iter_netlink.c modified to force one function to be not inlined and with
CONFIG_BPF_JIT_ALWAYS_ON the following error is seen:
   $ ./test_progs -n 3/3
   ...
   libbpf: failed to load program 'iter/netlink'
   libbpf: failed to load object 'bpf_iter_netlink'
   libbpf: failed to load BPF skeleton 'bpf_iter_netlink': -4007
   test_netlink:FAIL:bpf_iter_netlink__open_and_load skeleton open_and_load failed
   #3/3 netlink:FAIL
The dmesg shows the following errors:
   ex gen bug
which is triggered by the following code in arch/x86/net/bpf_jit_comp.c:
   if (excnt >= bpf_prog->aux->num_exentries) {
     pr_err("ex gen bug\n");
     return -EFAULT;
   }

This patch fixes the issue by computing proper num_exentries for each
subprogram before calling JIT.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 739d9ba3ba6b7..eebdd5307713b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9613,7 +9613,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	int i, j, subprog_start, subprog_end = 0, len, subprog;
 	struct bpf_insn *insn;
 	void *old_bpf_func;
-	int err;
+	int err, num_exentries;
 
 	if (env->subprog_cnt <= 1)
 		return 0;
@@ -9688,6 +9688,14 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
 		func[i]->aux->linfo_idx = env->subprog_info[i].linfo_idx;
+		num_exentries = 0;
+		insn = func[i]->insnsi;
+		for (j = 0; j < func[i]->len; j++, insn++) {
+			if (BPF_CLASS(insn->code) == BPF_LDX &&
+			    BPF_MODE(insn->code) == BPF_PROBE_MEM)
+				num_exentries++;
+		}
+		func[i]->aux->num_exentries = num_exentries;
 		func[i] = bpf_int_jit_compile(func[i]);
 		if (!func[i]->jited) {
 			err = -ENOTSUPP;
-- 
2.25.1



