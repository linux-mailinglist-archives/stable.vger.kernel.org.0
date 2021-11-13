Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A944F3DA
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 16:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhKMPWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 10:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhKMPWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 10:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720836108E;
        Sat, 13 Nov 2021 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636816802;
        bh=YptAMurNQZoNFeM81W8yIJMdlOmt+kuhFFl4XMj7vSk=;
        h=Subject:To:Cc:From:Date:From;
        b=ImDtwzBg+bZ21njOqe9wtGjQ7zJoW2isYSoLC0gec8xLDHzB3SqiBHfTHE142UHgA
         yze/wjYQnFIs94R240wphfgDftEHlirZS9Is2onu8kjx8lCEsknm8zEaW8R+PLT5vC
         5JpXoaMOOtQTpK9SrXICfT+5yuGk8iJ/QXeejzfM=
Subject: FAILED: patch "[PATCH] soc: fsl: dpio: replace smp_processor_id with" failed to apply to 4.19-stable tree
To:     Meng.Li@windriver.com, leoyang.li@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 16:19:59 +0100
Message-ID: <163681679954112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e775eb9fc2a4107f03222fa48bc95c2c82427e64 Mon Sep 17 00:00:00 2001
From: Meng Li <Meng.Li@windriver.com>
Date: Tue, 19 Oct 2021 10:32:41 +0800
Subject: [PATCH] soc: fsl: dpio: replace smp_processor_id with
 raw_smp_processor_id

When enable debug kernel configs,there will be calltrace as below:

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
caller is debug_smp_processor_id+0x20/0x30
CPU: 6 PID: 1 Comm: swapper/0 Not tainted 5.10.63-yocto-standard #1
Hardware name: NXP Layerscape LX2160ARDB (DT)
Call trace:
 dump_backtrace+0x0/0x1a0
 show_stack+0x24/0x30
 dump_stack+0xf0/0x13c
 check_preemption_disabled+0x100/0x110
 debug_smp_processor_id+0x20/0x30
 dpaa2_io_query_fq_count+0xdc/0x154
 dpaa2_eth_stop+0x144/0x314
 __dev_close_many+0xdc/0x160
 __dev_change_flags+0xe8/0x220
 dev_change_flags+0x30/0x70
 ic_close_devs+0x50/0x78
 ip_auto_config+0xed0/0xf10
 do_one_initcall+0xac/0x460
 kernel_init_freeable+0x30c/0x378
 kernel_init+0x20/0x128
 ret_from_fork+0x10/0x38

Based on comment in the context, it doesn't matter whether
preemption is disable or not. So, replace smp_processor_id()
with raw_smp_processor_id() to avoid above call trace.

Fixes: c89105c9b390 ("staging: fsl-mc: Move DPIO from staging to drivers/soc/fsl")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>

diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 7351f3030550..779c319a4b82 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -59,7 +59,7 @@ static inline struct dpaa2_io *service_select_by_cpu(struct dpaa2_io *d,
 	 * potentially being migrated away.
 	 */
 	if (cpu < 0)
-		cpu = smp_processor_id();
+		cpu = raw_smp_processor_id();
 
 	/* If a specific cpu was requested, pick it up immediately */
 	return dpio_by_cpu[cpu];

