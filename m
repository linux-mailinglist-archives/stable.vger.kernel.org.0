Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3049C69498A
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjBMO7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjBMO7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E191B541
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 261C46113A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC7AC433EF;
        Mon, 13 Feb 2023 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300354;
        bh=DfwNNvkSq9fxywaXdI6aqKqHceEOTM9Rqkiz+driz1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOnZBWAId7l9DxawFNe7v696xstaUoQug/aI7MAdeVxaYoBIJcx7f8btzVU3bJbu7
         veWE53xFIZofEzl6ga1B2Rv3yCbNGDgybHj02LhAQjIA6gzX9fsvKwc494a2RVfac+
         9xKAixbEBBiNnJ5TbxelT3oHsBmjvJ1uZ9nziqeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/67] riscv: stacktrace: Fix missing the first frame
Date:   Mon, 13 Feb 2023 15:49:23 +0100
Message-Id: <20230213144734.356497614@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit cb80242cc679d6397e77d8a964deeb3ff218d2b5 ]

When running kfence_test, I found some testcases failed like this:

 # test_out_of_bounds_read: EXPECTATION FAILED at mm/kfence/kfence_test.c:346
 Expected report_matches(&expect) to be true, but is false
 not ok 1 - test_out_of_bounds_read

The corresponding call-trace is:

 BUG: KFENCE: out-of-bounds read in kunit_try_run_case+0x38/0x84

 Out-of-bounds read at 0x(____ptrval____) (32B right of kfence-#10):
  kunit_try_run_case+0x38/0x84
  kunit_generic_run_threadfn_adapter+0x12/0x1e
  kthread+0xc8/0xde
  ret_from_exception+0x0/0xc

The kfence_test using the first frame of call trace to check whether the
testcase is succeed or not. Commit 6a00ef449370 ("riscv: eliminate
unreliable __builtin_frame_address(1)") skip first frame for all
case, which results the kfence_test failed. Indeed, we only need to skip
the first frame for case (task==NULL || task==current).

With this patch, the call-trace will be:

 BUG: KFENCE: out-of-bounds read in test_out_of_bounds_read+0x88/0x19e

 Out-of-bounds read at 0x(____ptrval____) (1B left of kfence-#7):
  test_out_of_bounds_read+0x88/0x19e
  kunit_try_run_case+0x38/0x84
  kunit_generic_run_threadfn_adapter+0x12/0x1e
  kthread+0xc8/0xde
  ret_from_exception+0x0/0xc

Fixes: 6a00ef449370 ("riscv: eliminate unreliable __builtin_frame_address(1)")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Tested-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20221207025038.1022045-1-liushixin2@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 811e837a8c4ee..ee8ef91c8aaf4 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -32,6 +32,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		fp = (unsigned long)__builtin_frame_address(0);
 		sp = sp_in_global;
 		pc = (unsigned long)walk_stackframe;
+		level = -1;
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -43,7 +44,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		unsigned long low, high;
 		struct stackframe *frame;
 
-		if (unlikely(!__kernel_text_address(pc) || (level++ >= 1 && !fn(arg, pc))))
+		if (unlikely(!__kernel_text_address(pc) || (level++ >= 0 && !fn(arg, pc))))
 			break;
 
 		/* Validate frame pointer */
-- 
2.39.0



