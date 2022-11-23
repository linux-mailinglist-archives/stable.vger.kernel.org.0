Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A06D635803
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiKWJtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiKWJsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10A5E3D22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7E91B81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00675C433C1;
        Wed, 23 Nov 2022 09:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196760;
        bh=vYjTcDxjUZro+fLletC+0gecwRNWkga7YhOeS9UU+Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwutitYoLa8/hPQVD/PONelckHAKd+kZLHs+U4y5NTZxwYMuaxxFRYbkP2LzdtsNr
         2PFgztUr1sOZ/EKjW0RiXdtqC2bx7f3fz2zKZ9j61TWkljE5HNM3SIeyN5snMxNHzk
         JBKWndh6fC2H3+8tZ5dSHu8oGJ7QLCzRlH2ilI0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/314] bpf: Fix memory leaks in __check_func_call
Date:   Wed, 23 Nov 2022 09:49:22 +0100
Message-Id: <20221123084630.811659605@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit eb86559a691cea5fa63e57a03ec3dc9c31e97955 ]

kmemleak reports this issue:

unreferenced object 0xffff88817139d000 (size 2048):
  comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
    [<0000000098b7c90a>] __check_func_call+0x316/0x1230
    [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
    [<00000000aa3875b7>] do_check+0x21d8/0x45e0
    [<000000001147357b>] do_check_common+0x767/0xaf0
    [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
    [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
    [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
    [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
    [<00000000946ee250>] do_syscall_64+0x3b/0x90
    [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root case here is: In function prepare_func_exit(), the callee is
not released in the abnormal scenario after "state->curframe--;". To
fix, move "state->curframe--;" to the very bottom of the function,
right when we free callee and reset frame[] pointer to NULL, as Andrii
suggested.

In addition, function __check_func_call() has a similar problem. In
the abnormal scenario before "state->curframe++;", the callee also
should be released by free_func_state().

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1667884291-15666-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 69fb46fdf763..b781075dd510 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6674,11 +6674,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	/* Transfer references to the callee */
 	err = copy_reference_state(callee, caller);
 	if (err)
-		return err;
+		goto err_out;
 
 	err = set_callee_state_cb(env, caller, callee, *insn_idx);
 	if (err)
-		return err;
+		goto err_out;
 
 	clear_caller_saved_regs(env, caller->regs);
 
@@ -6695,6 +6695,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		print_verifier_state(env, callee, true);
 	}
 	return 0;
+
+err_out:
+	free_func_state(callee);
+	state->frame[state->curframe + 1] = NULL;
+	return err;
 }
 
 int map_set_for_each_callback_args(struct bpf_verifier_env *env,
@@ -6880,8 +6885,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		return -EINVAL;
 	}
 
-	state->curframe--;
-	caller = state->frame[state->curframe];
+	caller = state->frame[state->curframe - 1];
 	if (callee->in_callback_fn) {
 		/* enforce R0 return value range [0, 1]. */
 		struct tnum range = tnum_range(0, 1);
@@ -6920,7 +6924,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	}
 	/* clear everything in the callee */
 	free_func_state(callee);
-	state->frame[state->curframe + 1] = NULL;
+	state->frame[state->curframe--] = NULL;
 	return 0;
 }
 
-- 
2.35.1



