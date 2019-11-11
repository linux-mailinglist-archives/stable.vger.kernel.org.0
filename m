Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39357F7DF2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfKKSx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfKKSx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 179B02184C;
        Mon, 11 Nov 2019 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498436;
        bh=0UXlZxhZLcvEzM7joCVK81AnM9ibdqsJS+MsEByHkqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRZssEUfvz6yWpbOw0fraG7V6FaeGgiwIGn4XTofGw9T40lvFGOTHcU4VLTA4NjCH
         x2cYPgIGAk6Ze1G+02ZDZDYLnH+IlSLrM6cHLKNEF+YvuU0qLLFrd/fEMdD9BqWYhS
         ggzzIlb15unIPLWynTESDLtfAstcAeGmySu+siWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 120/193] bpf: Fix use after free in bpf_get_prog_name
Date:   Mon, 11 Nov 2019 19:28:22 +0100
Message-Id: <20191111181510.026805214@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3b4d9eb2ee74dd5ea7fa36cffb0ca7f5bc4924da ]

There is one more problematic case I noticed while recently fixing BPF kallsyms
handling in cd7455f1013e ("bpf: Fix use after free in subprog's jited symbol
removal") and that is bpf_get_prog_name().

If BTF has been attached to the prog, then we may be able to fetch the function
signature type id in kallsyms through prog->aux->func_info[prog->aux->func_idx].type_id.
However, while the BTF object itself is torn down via RCU callback, the prog's
aux->func_info is immediately freed via kvfree(prog->aux->func_info) once the
prog's refcount either hit zero or when subprograms were already exposed via
kallsyms and we hit the error path added in 5482e9a93c83 ("bpf: Fix memleak in
aux->func_info and aux->btf").

This violates RCU as well since kallsyms could be walked in parallel where we
could access aux->func_info. Hence, defer kvfree() to after RCU grace period.
Looking at ba64e7d85252 ("bpf: btf: support proper non-jit func info") there
is no reason/dependency where we couldn't defer the kvfree(aux->func_info) into
the RCU callback.

Fixes: 5482e9a93c83 ("bpf: Fix memleak in aux->func_info and aux->btf")
Fixes: ba64e7d85252 ("bpf: btf: support proper non-jit func info")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/875f2906a7c1a0691f2d567b4d8e4ea2739b1e88.1571779205.git.daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index af5c60b07463e..aac966b32c42e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1316,6 +1316,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	kvfree(aux->func_info);
 	free_used_maps(aux);
 	bpf_prog_uncharge_memlock(aux->prog);
 	security_bpf_prog_free(aux);
@@ -1326,7 +1327,6 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
 	btf_put(prog->aux->btf);
-	kvfree(prog->aux->func_info);
 	bpf_prog_free_linfo(prog);
 
 	if (deferred)
-- 
2.20.1



