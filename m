Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B4759DEF0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbiHWLNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242917AbiHWLLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:11:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B968B8F02;
        Tue, 23 Aug 2022 02:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE86EB81C65;
        Tue, 23 Aug 2022 09:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358AAC433D6;
        Tue, 23 Aug 2022 09:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246266;
        bh=HUxFH7R4KZzEpSC3nlAS/0ulvTEtFkqh0CyQgt65MM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrKQKqRdixinRyQMGsRr9XIdza0luhVcJtXEZidX9rcBIxCfd6v6kohJ0QGBadipK
         1XvRohD8lgUttLTPapFLR4m0rv2gGnPmK8IR6ablqimF+gtk9j7mIIExcp2Zoj1vuU
         BoJ/NRWXXPxs36FafIe7fEcJiXdoIIrTAx6yomRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hewenliang <hewenliang4@huawei.com>,
        Haibin Zhang <haibinzhang@tencent.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/389] arm64: fix oops in concurrently setting insn_emulation sysctls
Date:   Tue, 23 Aug 2022 10:22:12 +0200
Message-Id: <20220823080117.868598684@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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



