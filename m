Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E9C58C0A8
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiHHBxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243812AbiHHBv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279E01A390;
        Sun,  7 Aug 2022 18:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4B060EB5;
        Mon,  8 Aug 2022 01:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AAFC433C1;
        Mon,  8 Aug 2022 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922722;
        bh=HUxFH7R4KZzEpSC3nlAS/0ulvTEtFkqh0CyQgt65MM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeOogc6EGKnE39suKLLhid7J2umcWKEIDz2FJGfhtLRPNNUOhHXoxnM8hrCf3qNaV
         IMqx/tPT88l2GBmls4kIhf1qTqaNJyl1n113nID4hmTTGp5WcKaI7Zj7LHNRzgqluO
         uuKlaD03M0MllweOpj3H+tvIzN0GQUfZ1aDri6blynoshTjY6db9ypzCaS2zh0rlb5
         4/V2dq57YJvtNn0OJjVjk6bFovK/qjaApABiik0udQSYMTmKs4dLSuqrBa/6eR64JG
         og8OEJe09peZR6Zhj+n6hiKL/wxCcjOhVWr98W6OiePq/Q1y2ke+0QS3hH5XVW3cXF
         W53SHGW8bvOwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?haibinzhang=20=28=E5=BC=A0=E6=B5=B7=E6=96=8C=29?= 
        <haibinzhang@tencent.com>, hewenliang <hewenliang4@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ardb@kernel.org, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 03/23] arm64: fix oops in concurrently setting insn_emulation sysctls
Date:   Sun,  7 Aug 2022 21:38:10 -0400
Message-Id: <20220808013832.316381-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: haibinzhang (张海斌) <haibinzhang@tencent.com>

[ Upstream commit af483947d472eccb79e42059276c4deed76f99a6 ]

emulation_proc_handler() changes table->data for proc_dointvec_minmax
and can generate the following Oops if called concurrently with itself:

 | Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
 | Internal error: Oops: 96000006 [#1] SMP
 | Call trace:
 | update_insn_emulation_mode+0xc0/0x148
 | emulation_proc_handler+0x64/0xb8
 | proc_sys_call_handler+0x9c/0xf8
 | proc_sys_write+0x18/0x20
 | __vfs_write+0x20/0x48
 | vfs_write+0xe4/0x1d0
 | ksys_write+0x70/0xf8
 | __arm64_sys_write+0x20/0x28
 | el0_svc_common.constprop.0+0x7c/0x1c0
 | el0_svc_handler+0x2c/0xa0
 | el0_svc+0x8/0x200

To fix this issue, keep the table->data as &insn->current_mode and
use container_of() to retrieve the insn pointer. Another mutex is
used to protect against the current_mode update but not for retrieving
insn_emulation as table->data is no longer changing.

Co-developed-by: hewenliang <hewenliang4@huawei.com>
Signed-off-by: hewenliang <hewenliang4@huawei.com>
Signed-off-by: Haibin Zhang <haibinzhang@tencent.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220128090324.2727688-1-hewenliang4@huawei.com
Link: https://lore.kernel.org/r/9A004C03-250B-46C5-BF39-782D7551B00E@tencent.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/armv8_deprecated.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index bcb14d11232f..fbf66e0973aa 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -59,6 +59,7 @@ struct insn_emulation {
 static LIST_HEAD(insn_emulation);
 static int nr_insn_emulated __initdata;
 static DEFINE_RAW_SPINLOCK(insn_emulation_lock);
+static DEFINE_MUTEX(insn_emulation_mutex);
 
 static void register_emulation_hooks(struct insn_emulation_ops *ops)
 {
@@ -207,10 +208,10 @@ static int emulation_proc_handler(struct ctl_table *table, int write,
 				  loff_t *ppos)
 {
 	int ret = 0;
-	struct insn_emulation *insn = (struct insn_emulation *) table->data;
+	struct insn_emulation *insn = container_of(table->data, struct insn_emulation, current_mode);
 	enum insn_emulation_mode prev_mode = insn->current_mode;
 
-	table->data = &insn->current_mode;
+	mutex_lock(&insn_emulation_mutex);
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (ret || !write || prev_mode == insn->current_mode)
@@ -223,7 +224,7 @@ static int emulation_proc_handler(struct ctl_table *table, int write,
 		update_insn_emulation_mode(insn, INSN_UNDEF);
 	}
 ret:
-	table->data = insn;
+	mutex_unlock(&insn_emulation_mutex);
 	return ret;
 }
 
@@ -247,7 +248,7 @@ static void __init register_insn_emulation_sysctl(void)
 		sysctl->maxlen = sizeof(int);
 
 		sysctl->procname = insn->ops->name;
-		sysctl->data = insn;
+		sysctl->data = &insn->current_mode;
 		sysctl->extra1 = &insn->min;
 		sysctl->extra2 = &insn->max;
 		sysctl->proc_handler = emulation_proc_handler;
-- 
2.35.1

