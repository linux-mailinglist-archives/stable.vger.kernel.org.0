Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4415AEBE8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbiIFOAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbiIFN6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A964B82D07;
        Tue,  6 Sep 2022 06:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E21C061549;
        Tue,  6 Sep 2022 13:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF4C433C1;
        Tue,  6 Sep 2022 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471759;
        bh=ELg0Fox4x+C8VsMYK4GaWUmh4seLkJ7DS0K2pza7Ltk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBy7/GPRxCQz5Ra0rQKmGvFi1Tbjd6b1OCPpMQ+rdsn9t2HfmGVszYQUOy5bsr3gs
         RAeDibrLqsXL+EjyJNjjscGUTLsNBvyRSevTAN48SxP/M7RL9wkyLdHATu1SYtYGLM
         /pvf7BZS/9DUj/BD36eG7+RUNcb9OYjtNpp2Twm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 028/155] bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO
Date:   Tue,  6 Sep 2022 15:29:36 +0200
Message-Id: <20220906132830.625352742@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 2fc31465c5373b5ca4edf2e5238558cb62902311 ]

Precision markers need to be propagated whenever we have an ARG_CONST_*
style argument, as the verifier cannot consider imprecise scalars to be
equivalent for the purposes of states_equal check when such arguments
refine the return value (in this case, set mem_size for PTR_TO_MEM). The
resultant mem_size for the R0 is derived from the constant value, and if
the verifier incorrectly prunes states considering them equivalent where
such arguments exist (by seeing that both registers have reg->precise as
false in regsafe), we can end up with invalid programs passing the
verifier which can do access beyond what should have been the correct
mem_size in that explored state.

To show a concrete example of the problem:

0000000000000000 <prog>:
       0:       r2 = *(u32 *)(r1 + 80)
       1:       r1 = *(u32 *)(r1 + 76)
       2:       r3 = r1
       3:       r3 += 4
       4:       if r3 > r2 goto +18 <LBB5_5>
       5:       w2 = 0
       6:       *(u32 *)(r1 + 0) = r2
       7:       r1 = *(u32 *)(r1 + 0)
       8:       r2 = 1
       9:       if w1 == 0 goto +1 <LBB5_3>
      10:       r2 = -1

0000000000000058 <LBB5_3>:
      11:       r1 = 0 ll
      13:       r3 = 0
      14:       call bpf_ringbuf_reserve
      15:       if r0 == 0 goto +7 <LBB5_5>
      16:       r1 = r0
      17:       r1 += 16777215
      18:       w2 = 0
      19:       *(u8 *)(r1 + 0) = r2
      20:       r1 = r0
      21:       r2 = 0
      22:       call bpf_ringbuf_submit

00000000000000b8 <LBB5_5>:
      23:       w0 = 0
      24:       exit

For the first case, the single line execution's exploration will prune
the search at insn 14 for the branch insn 9's second leg as it will be
verified first using r2 = -1 (UINT_MAX), while as w1 at insn 9 will
always be 0 so at runtime we don't get error for being greater than
UINT_MAX/4 from bpf_ringbuf_reserve. The verifier during regsafe just
sees reg->precise as false for both r2 registers in both states, hence
considers them equal for purposes of states_equal.

If we propagated precise markers using the backtracking support, we
would use the precise marking to then ensure that old r2 (UINT_MAX) was
within the new r2 (1) and this would never be true, so the verification
would rightfully fail.

The end result is that the out of bounds access at instruction 19 would
be permitted without this fix.

Note that reg->precise is always set to true when user does not have
CAP_BPF (or when subprog count is greater than 1 (i.e. use of any static
or global functions)), hence this is only a problem when precision marks
need to be explicitly propagated (i.e. privileged users with CAP_BPF).

A simplified test case has been included in the next patch to prevent
future regressions.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220823185300.406-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 20df58c351abf..339147061127a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6066,6 +6066,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			return -EACCES;
 		}
 		meta->mem_size = reg->var_off.value;
+		err = mark_chain_precision(env, regno);
+		if (err)
+			return err;
 		break;
 	case ARG_PTR_TO_INT:
 	case ARG_PTR_TO_LONG:
-- 
2.35.1



