Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA5A4521C8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353331AbhKPBGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245405AbhKOTUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E806101B;
        Mon, 15 Nov 2021 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001236;
        bh=sF8fHi2Yg07ypCz0lBor9KwD8I+9TbF5mnw5PXmD5pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC77iSBuMBaM3QS/cRROM9FHJBazmq1QYSALKvAokNyEzcRB10BGgltZUt+xpXktm
         EKwJGGqHchoUmQnss4FvJH52l17jyZ6Ey1yoxmhR5jnYABGpiWfyuN23aPi5WTnYJm
         DQlmlQ/FU+3cpysmq9StpjEEVk7eWBMXQJNHgpLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH 5.15 113/917] soc: fsl: dpio: replace smp_processor_id with raw_smp_processor_id
Date:   Mon, 15 Nov 2021 17:53:28 +0100
Message-Id: <20211115165432.578743785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit e775eb9fc2a4107f03222fa48bc95c2c82427e64 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/dpio/dpio-service.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -59,7 +59,7 @@ static inline struct dpaa2_io *service_s
 	 * potentially being migrated away.
 	 */
 	if (cpu < 0)
-		cpu = smp_processor_id();
+		cpu = raw_smp_processor_id();
 
 	/* If a specific cpu was requested, pick it up immediately */
 	return dpio_by_cpu[cpu];


