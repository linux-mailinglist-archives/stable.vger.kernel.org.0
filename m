Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3401C6356BB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiKWJdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237862AbiKWJcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:32:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29B0429B2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA14B81EF8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A992FC43470;
        Wed, 23 Nov 2022 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195887;
        bh=i+svlwgfyazBfWgfYrV0oTcv5EMEiLtTVctGjOddZNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxE0Cz8MRDQk9EaVkEBYbkywmEuP5rigUfTPMxe8VTktO+0yiiCOMoYcol6ke5X5p
         VrH7AtvzrLpofnYZGkj1tyZDilBhB83HGAASiQDNXZ58JOiqkreWysEatM7ebK0Sml
         rDpPcCjA6CQOLxFRU1RWuL+3HNl8pbMieZx/J89U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/181] bpf: Fix memory leaks in __check_func_call
Date:   Wed, 23 Nov 2022 09:50:22 +0100
Message-Id: <20221123084604.918492869@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index 8a73a165ac76..cceb29b0585f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5808,11 +5808,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
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
 
@@ -5829,6 +5829,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		print_verifier_state(env, callee);
 	}
 	return 0;
+
+err_out:
+	free_func_state(callee);
+	state->frame[state->curframe + 1] = NULL;
+	return err;
 }
 
 int map_set_for_each_callback_args(struct bpf_verifier_env *env,
@@ -5966,8 +5971,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		return -EINVAL;
 	}
 
-	state->curframe--;
-	caller = state->frame[state->curframe];
+	caller = state->frame[state->curframe - 1];
 	if (callee->in_callback_fn) {
 		/* enforce R0 return value range [0, 1]. */
 		struct tnum range = tnum_range(0, 1);
@@ -6006,7 +6010,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	}
 	/* clear everything in the callee */
 	free_func_state(callee);
-	state->frame[state->curframe + 1] = NULL;
+	state->frame[state->curframe--] = NULL;
 	return 0;
 }
 
-- 
2.35.1



