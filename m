Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB193737A0
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEEJgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 05:36:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:56798 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhEEJgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 05:36:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620207317; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=DjffynwOTIplvphcol0QO9d3xBlxRHbmF00ZLWu5TJ8=; b=nYt7gRUva+WM5daMldtTxZXgBOTn9GY8CUlPLaFA3qICdftB6IhKT+cR8K0dVF/lGI8eL+RN
 s13e+QkLp2Re4eLBKWMML7jdwnSJ3u6c0RURJsehC8iDnl2XbA3i5T5xbt+Lydy8ZhmCRPbh
 cQm9qB4dpO1vGd+zNAhTAq0hO4w=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 609266b879b6f9e57beb5b0a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 05 May 2021 09:34:48
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6EB77C43144; Wed,  5 May 2021 09:34:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14296C4338A;
        Wed,  5 May 2021 09:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14296C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=saiprakash.ranjan@codeaurora.org
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>
Cc:     coresight@lists.linaro.org, Stephen Boyd <swboyd@chromium.org>,
        Denis Nikitin <denik@chromium.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
Date:   Wed,  5 May 2021 15:04:30 +0530
Message-Id: <20210505093430.18445-1-saiprakash.ranjan@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 6f755e85c332 ("coresight: Add helper for inserting synchronization packets")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index 45b85edfc690..cd0fb7bfba68 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -530,7 +530,7 @@ static unsigned long tmc_update_etf_buffer(struct coresight_device *csdev,
 		buf_ptr = buf->data_pages[cur] + offset;
 		*buf_ptr = readl_relaxed(drvdata->base + TMC_RRD);
 
-		if (lost && *barrier) {
+		if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
 			*buf_ptr = *barrier;
 			barrier++;
 		}
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

