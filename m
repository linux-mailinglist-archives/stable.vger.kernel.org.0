Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23553CA981
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhGOTG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242247AbhGOTFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B0BC613DB;
        Thu, 15 Jul 2021 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375734;
        bh=X4unYPdD9aUiCg4rzQrQVd7fpH13JNuuUM4b9Qpnxyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiaGnnMLdWlzvzH7syA+hW0ovNhcVBuoND7gIqwffOBsO7vTEmwwYW+eR0MXhTiUN
         BQv1St1CEwvguf5azSASlfATGbUzk5qpVaartrtn5q7XBeRIP9mhR+bgAtRixq8MjW
         m02BLy/MVvssYURXF58Xv1PoF4qiXJtKCxBTta/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.12 214/242] coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
Date:   Thu, 15 Jul 2021 20:39:36 +0200
Message-Id: <20210715182630.839815928@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

commit 5fae8a946ac2df879caf3f79a193d4766d00239b upstream.

commit 6f755e85c332 ("coresight: Add helper for inserting synchronization
packets") removed trailing '\0' from barrier_pkt array and updated the
call sites like etb_update_buffer() to have proper checks for barrier_pkt
size before read but missed updating tmc_update_etf_buffer() which still
reads barrier_pkt past the array size resulting in KASAN out-of-bounds
bug. Fix this by adding a check for barrier_pkt size before accessing
like it is done in etb_update_buffer().

 BUG: KASAN: global-out-of-bounds in tmc_update_etf_buffer+0x4b8/0x698
 Read of size 4 at addr ffffffd05b7d1030 by task perf/2629

 Call trace:
  dump_backtrace+0x0/0x27c
  show_stack+0x20/0x2c
  dump_stack+0x11c/0x188
  print_address_description+0x3c/0x4a4
  __kasan_report+0x140/0x164
  kasan_report+0x10/0x18
  __asan_report_load4_noabort+0x1c/0x24
  tmc_update_etf_buffer+0x4b8/0x698
  etm_event_stop+0x248/0x2d8
  etm_event_del+0x20/0x2c
  event_sched_out+0x214/0x6f0
  group_sched_out+0xd0/0x270
  ctx_sched_out+0x2ec/0x518
  __perf_event_task_sched_out+0x4fc/0xe6c
  __schedule+0x1094/0x16a0
  preempt_schedule_irq+0x88/0x170
  arm64_preempt_schedule_irq+0xf0/0x18c
  el1_irq+0xe8/0x180
  perf_event_exec+0x4d8/0x56c
  setup_new_exec+0x204/0x400
  load_elf_binary+0x72c/0x18c0
  search_binary_handler+0x13c/0x420
  load_script+0x500/0x6c4
  search_binary_handler+0x13c/0x420
  exec_binprm+0x118/0x654
  __do_execve_file+0x77c/0xba4
  __arm64_compat_sys_execve+0x98/0xac
  el0_svc_common+0x1f8/0x5e0
  el0_svc_compat_handler+0x84/0xb0
  el0_svc_compat+0x10/0x50

 The buggy address belongs to the variable:
  barrier_pkt+0x10/0x40

 Memory state around the buggy address:
  ffffffd05b7d0f00: fa fa fa fa 04 fa fa fa fa fa fa fa 00 00 00 00
  ffffffd05b7d0f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffffffd05b7d1000: 00 00 00 00 00 00 fa fa fa fa fa fa 00 00 00 03
                                      ^
  ffffffd05b7d1080: fa fa fa fa 00 02 fa fa fa fa fa fa 03 fa fa fa
  ffffffd05b7d1100: fa fa fa fa 00 00 00 00 05 fa fa fa fa fa fa fa
 ==================================================================

Link: https://lore.kernel.org/r/20210505093430.18445-1-saiprakash.ranjan@codeaurora.org
Fixes: 0c3fc4d5fa26 ("coresight: Add barrier packet for synchronisation")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210614175901.532683-6-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -530,7 +530,7 @@ static unsigned long tmc_update_etf_buff
 		buf_ptr = buf->data_pages[cur] + offset;
 		*buf_ptr = readl_relaxed(drvdata->base + TMC_RRD);
 
-		if (lost && *barrier) {
+		if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
 			*buf_ptr = *barrier;
 			barrier++;
 		}


