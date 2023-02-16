Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E423E698B3F
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBPDpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 22:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBPDpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 22:45:01 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A5BDDC;
        Wed, 15 Feb 2023 19:45:00 -0800 (PST)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PHLPp37wpzJqpY;
        Thu, 16 Feb 2023 11:43:10 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 11:44:58 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <naveen.n.rao@linux.ibm.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <mhiramat@kernel.org>, <ast@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <yangjihong1@huawei.com>
Subject: [PATCH v2 1/2] x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
Date:   Thu, 16 Feb 2023 11:42:46 +0800
Message-ID: <20230216034247.32348-2-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20230216034247.32348-1-yangjihong1@huawei.com>
References: <20230216034247.32348-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the following commit:

  commit f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")

modified the update timing of the KPROBE_FLAG_OPTIMIZED, a optimized_kprobe
may be in the optimizing or unoptimizing state when op.kp->flags
has KPROBE_FLAG_OPTIMIZED and op->list is not empty.

The __recover_optprobed_insn check logic is incorrect, a kprobe in the
unoptimizing state may be incorrectly determined as unoptimizing.
As a result, incorrect instructions are copied.

The optprobe_queued_unopt function needs to be exported for invoking in
arch directory.

Cc: stable@vger.kernel.org
Fixes: f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c | 4 ++--
 include/linux/kprobes.h       | 1 +
 kernel/kprobes.c              | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index e57e07b0edb6..f406bfa9a8cd 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -46,8 +46,8 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 		/* This function only handles jump-optimized kprobe */
 		if (kp && kprobe_optimized(kp)) {
 			op = container_of(kp, struct optimized_kprobe, kp);
-			/* If op->list is not empty, op is under optimizing */
-			if (list_empty(&op->list))
+			/* If op is optimized or under unoptimizing */
+			if (list_empty(&op->list) || optprobe_queued_unopt(op))
 				goto found;
 		}
 	}
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index a0b92be98984..ab39285f71a6 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -378,6 +378,7 @@ extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
 DEFINE_INSN_CACHE_OPS(optinsn);
 
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
 #else /* !CONFIG_OPTPROBES */
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1c18ecf9f98b..90b0fac6efa0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -662,7 +662,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 
-- 
2.30.GIT

