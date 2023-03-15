Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855CD6BB269
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjCOMgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCOMfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762D0195
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DD761D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0DEC433D2;
        Wed, 15 Mar 2023 12:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883684;
        bh=ErmkSfnRUXSuhQYFKWHMYzP3g964wNUbcT8Fi8gv+Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7EVCdLWCT8SOGNta0PuGn7gBnTfGpFGN6/Th8s0TmUp715L4d5TNUq/JozEQ8Pwm
         Q7tEyxiodBVWPpV8klJrl4Itze0iz1HZXLaWs3DLG0m3etaKjk6VZpKwnxWwG7zSoD
         pXBt9T1Uwqm8m4w/vNJgQnVHflBOs/Zq/D6IroFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenz Bauer <lmb@isovalent.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/143] btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR
Date:   Wed, 15 Mar 2023 13:12:59 +0100
Message-Id: <20230315115743.345894021@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lorenz.bauer@isovalent.com>

[ Upstream commit 9b459804ff9973e173fabafba2a1319f771e85fa ]

btf_datasec_resolve contains a bug that causes the following BTF
to fail loading:

    [1] DATASEC a size=2 vlen=2
        type_id=4 offset=0 size=1
        type_id=7 offset=1 size=1
    [2] INT (anon) size=1 bits_offset=0 nr_bits=8 encoding=(none)
    [3] PTR (anon) type_id=2
    [4] VAR a type_id=3 linkage=0
    [5] INT (anon) size=1 bits_offset=0 nr_bits=8 encoding=(none)
    [6] TYPEDEF td type_id=5
    [7] VAR b type_id=6 linkage=0

This error message is printed during btf_check_all_types:

    [1] DATASEC a size=2 vlen=2
        type_id=7 offset=1 size=1 Invalid type

By tracing btf_*_resolve we can pinpoint the problem:

    btf_datasec_resolve(depth: 1, type_id: 1, mode: RESOLVE_TBD) = 0
        btf_var_resolve(depth: 2, type_id: 4, mode: RESOLVE_TBD) = 0
            btf_ptr_resolve(depth: 3, type_id: 3, mode: RESOLVE_PTR) = 0
        btf_var_resolve(depth: 2, type_id: 4, mode: RESOLVE_PTR) = 0
    btf_datasec_resolve(depth: 1, type_id: 1, mode: RESOLVE_PTR) = -22

The last invocation of btf_datasec_resolve should invoke btf_var_resolve
by means of env_stack_push, instead it returns EINVAL. The reason is that
env_stack_push is never executed for the second VAR.

    if (!env_type_is_resolve_sink(env, var_type) &&
        !env_type_is_resolved(env, var_type_id)) {
        env_stack_set_next_member(env, i + 1);
        return env_stack_push(env, var_type, var_type_id);
    }

env_type_is_resolve_sink() changes its behaviour based on resolve_mode.
For RESOLVE_PTR, we can simplify the if condition to the following:

    (btf_type_is_modifier() || btf_type_is_ptr) && !env_type_is_resolved()

Since we're dealing with a VAR the clause evaluates to false. This is
not sufficient to trigger the bug however. The log output and EINVAL
are only generated if btf_type_id_size() fails.

    if (!btf_type_id_size(btf, &type_id, &type_size)) {
        btf_verifier_log_vsi(env, v->t, vsi, "Invalid type");
        return -EINVAL;
    }

Most types are sized, so for example a VAR referring to an INT is not a
problem. The bug is only triggered if a VAR points at a modifier. Since
we skipped btf_var_resolve that modifier was also never resolved, which
means that btf_resolved_type_id returns 0 aka VOID for the modifier.
This in turn causes btf_type_id_size to return NULL, triggering EINVAL.

To summarise, the following conditions are necessary:

- VAR pointing at PTR, STRUCT, UNION or ARRAY
- Followed by a VAR pointing at TYPEDEF, VOLATILE, CONST, RESTRICT or
  TYPE_TAG

The fix is to reset resolve_mode to RESOLVE_TBD before attempting to
resolve a VAR from a DATASEC.

Fixes: 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Link: https://lore.kernel.org/r/20230306112138.155352-2-lmb@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7fcbe5d002070..b73169737a01e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4163,6 +4163,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
 	struct btf *btf = env->btf;
 	u16 i;
 
+	env->resolve_mode = RESOLVE_TBD;
 	for_each_vsi_from(i, v->next_member, v->t, vsi) {
 		u32 var_type_id = vsi->type, type_id, type_size = 0;
 		const struct btf_type *var_type = btf_type_by_id(env->btf,
-- 
2.39.2



