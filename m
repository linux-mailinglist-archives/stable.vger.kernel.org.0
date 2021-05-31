Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAAB3962A8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhEaPAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234277AbhEaO5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3981161401;
        Mon, 31 May 2021 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469625;
        bh=fVze1sOW+uVpcq7m6Z0V+gR27zJMWKX5h7oXYmvbgNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUHB9J6+mRuIJHlfO0gNh099n6pldpIYUBcPfmyoo9RM7mxhpGorOY6jL7CQyOlDs
         lmRwQnZhlEenY6jCVOn8rXTdaa1FtAH8VVyArIT1tM/W5OprvZkbbLtoDm/jhpyb4F
         ELRzIw06wGm60ZT6Qj/sGZSw8CdPlOL4SzmVgN28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 269/296] bpf, offload: Reorder offload callback prepare in verifier
Date:   Mon, 31 May 2021 15:15:24 +0200
Message-Id: <20210531130712.784254532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit ceb11679d9fcf3fdb358a310a38760fcbe9b63ed ]

Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched the
order of resolve_pseudo_ldimm(), in which some pseudo instructions
are rewritten. Thus those rewritten instructions cannot be passed
to driver via 'prepare' offload callback.

Reorder the 'prepare' offload callback to fix it.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210520085834.15023-1-simon.horman@netronome.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 21247e49fe82..b186d852fe3d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12714,12 +12714,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux)) {
-		ret = bpf_prog_offload_verifier_prep(env->prog);
-		if (ret)
-			goto skip_full_check;
-	}
-
 	env->explored_states = kvcalloc(state_htab_size(env),
 				       sizeof(struct bpf_verifier_state_list *),
 				       GFP_USER);
@@ -12743,6 +12737,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
+	if (bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = bpf_prog_offload_verifier_prep(env->prog);
+		if (ret)
+			goto skip_full_check;
+	}
+
 	ret = check_cfg(env);
 	if (ret < 0)
 		goto skip_full_check;
-- 
2.30.2



