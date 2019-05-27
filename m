Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69E02B177
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 11:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfE0JkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 05:40:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfE0JkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 05:40:18 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3ECA3419BF0B28FDFABB;
        Mon, 27 May 2019 17:40:16 +0800 (CST)
Received: from SZX1000472652.huawei.com (100.100.247.164) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Mon, 27 May 2019 17:40:05 +0800
From:   Yongliang Gao <gaoyongliang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <rmk+kernel@armlinux.org.uk>,
        <linux@armlinux.org.uk>, <punitagrawal@gmail.com>,
        <rafael.j.wysocki@intel.com>, <marc.zyngier@arm.com>,
        <james.morse@arm.com>, <linux-arm-kernel@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <chenjie6@huawei.com>, <nixiaoming@huawei.com>,
        <zengweilin@huawei.com>, <shiwenlu@huawei.com>
Subject: [PATCH] arm: fix using smp_processor_id() in preemptible context
Date:   Mon, 27 May 2019 17:39:39 +0800
Message-ID: <1558949979-129251-1-git-send-email-gaoyongliang@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [100.100.247.164]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

harden_branch_predictor() call smp_processor_id() in preemptible
context, this would cause a bug messages.

The bug messages is as follows:
BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor0/17992
caller is harden_branch_predictor arch/arm/include/asm/system_misc.h:27 [inline]
caller is __do_user_fault+0x34/0x114 arch/arm/mm/fault.c:200
CPU: 1 PID: 17992 Comm: syz-executor0 Tainted: G O 4.4.176 #1
Hardware name: Hisilicon A9
[<c0114ae4>] (unwind_backtrace) from [<c010e6fc>] (show_stack+0x18/0x1c)
[<c010e6fc>] (show_stack) from [<c0379514>] (dump_stack+0xc8/0x118)
[<c0379514>] (dump_stack) from [<c039b5a0>] (check_preemption_disabled+0xf4/0x138)
[<c039b5a0>] (check_preemption_disabled) from [<c011abe4>] (__do_user_fault+0x34/0x114)
[<c011abe4>] (__do_user_fault) from [<c053b0d0>] (do_page_fault+0x3b4/0x3d8)
[<c053b0d0>] (do_page_fault) from [<c01013dc>] (do_DataAbort+0x58/0xf8)
[<c01013dc>] (do_DataAbort) from [<c053a880>] (__dabt_usr+0x40/0x60)

Reported-by: Jingwen Qiu <qiujingwen@huawei.com>
Signed-off-by: Yongliang Gao <gaoyongliang@huawei.com>
Cc: <stable@vger.kernel.org>
---
 arch/arm/include/asm/system_misc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index 66f6a3a..4a55cfb 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -22,9 +22,10 @@
 static inline void harden_branch_predictor(void)
 {
 	harden_branch_predictor_fn_t fn = per_cpu(harden_branch_predictor_fn,
-						  smp_processor_id());
+						  get_cpu());
 	if (fn)
 		fn();
+	put_cpu();
 }
 #else
 #define harden_branch_predictor() do { } while (0)
-- 
1.8.5.6

