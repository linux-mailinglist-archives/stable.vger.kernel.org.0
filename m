Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7188A3DDA2D
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhHBOHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237726AbhHBOE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118A161247;
        Mon,  2 Aug 2021 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912692;
        bh=8VN2c+ZJ6cydjnakGXgS/4NYIz2w8VLQlb2/rkOqVZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWdV9SauL1iwtfF9S5wOo7dvIWZoBVDVOh96eTRlpAGvJfI3edZonD735ypKKkef5
         SzGAWXJgN+Z3w2wDRD3luZ5M6T1fIN781bRT0S4UWzdYiLHid7/bKJj83TB1pLdn1S
         vOHN7pVHu6HmIcjuxN1dU/lFOwpN3lBBTWKPGU6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.13 093/104] bpf: Remove superfluous aux sanitation on subprog rejection
Date:   Mon,  2 Aug 2021 15:45:30 +0200
Message-Id: <20210802134347.066516453@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 59089a189e3adde4cf85f2ce479738d1ae4c514d upstream.

Follow-up to fe9a5ca7e370 ("bpf: Do not mark insn as seen under speculative
path verification"). The sanitize_insn_aux_data() helper does not serve a
particular purpose in today's code. The original intention for the helper
was that if function-by-function verification fails, a given program would
be cleared from temporary insn_aux_data[], and then its verification would
be re-attempted in the context of the main program a second time.

However, a failure in do_check_subprogs() will skip do_check_main() and
propagate the error to the user instead, thus such situation can never occur.
Given its interaction is not compatible to the Spectre v1 mitigation (due to
comparing aux->seen with env->pass_cnt), just remove sanitize_insn_aux_data()
to avoid future bugs in this area.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12714,37 +12714,6 @@ static void free_states(struct bpf_verif
 	}
 }
 
-/* The verifier is using insn_aux_data[] to store temporary data during
- * verification and to store information for passes that run after the
- * verification like dead code sanitization. do_check_common() for subprogram N
- * may analyze many other subprograms. sanitize_insn_aux_data() clears all
- * temporary data after do_check_common() finds that subprogram N cannot be
- * verified independently. pass_cnt counts the number of times
- * do_check_common() was run and insn->aux->seen tells the pass number
- * insn_aux_data was touched. These variables are compared to clear temporary
- * data from failed pass. For testing and experiments do_check_common() can be
- * run multiple times even when prior attempt to verify is unsuccessful.
- *
- * Note that special handling is needed on !env->bypass_spec_v1 if this is
- * ever called outside of error path with subsequent program rejection.
- */
-static void sanitize_insn_aux_data(struct bpf_verifier_env *env)
-{
-	struct bpf_insn *insn = env->prog->insnsi;
-	struct bpf_insn_aux_data *aux;
-	int i, class;
-
-	for (i = 0; i < env->prog->len; i++) {
-		class = BPF_CLASS(insn[i].code);
-		if (class != BPF_LDX && class != BPF_STX)
-			continue;
-		aux = &env->insn_aux_data[i];
-		if (aux->seen != env->pass_cnt)
-			continue;
-		memset(aux, 0, offsetof(typeof(*aux), orig_idx));
-	}
-}
-
 static int do_check_common(struct bpf_verifier_env *env, int subprog)
 {
 	bool pop_log = !(env->log.level & BPF_LOG_LEVEL2);
@@ -12821,9 +12790,6 @@ out:
 	if (!ret && pop_log)
 		bpf_vlog_reset(&env->log, 0);
 	free_states(env);
-	if (ret)
-		/* clean aux data in case subprog was rejected */
-		sanitize_insn_aux_data(env);
 	return ret;
 }
 


