Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8C3442B7
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhCVMog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhCVMmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A891619B6;
        Mon, 22 Mar 2021 12:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416835;
        bh=hbIgt19IBV9LMeLYRgLcF9U819AFktoNC+UNDW3kUVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtUipxiR6OtLuTuTHC8UbreYIi8emWBc4qZRtPVRUdPWlvNCqW+ylJPzcrHm8n4PE
         TLI78pi0AwlVD3sK3sZ5EOlHjB5pOIe/4S0rZfgGW1dQdaO+MotzMZHpSFuG2mH069
         Dztq99vfcDwZ7sgm/R4CAB+uwAgg8NPK+1GNh5E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 139/157] perf/x86/intel: Fix unchecked MSR access error caused by VLBR_EVENT
Date:   Mon, 22 Mar 2021 13:28:16 +0100
Message-Id: <20210322121938.160000191@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 2dc0572f2cef87425147658698dce2600b799bd3 upstream.

On a Haswell machine, the perf_fuzzer managed to trigger this message:

[117248.075892] unchecked MSR access error: WRMSR to 0x3f1 (tried to
write 0x0400000000000000) at rIP: 0xffffffff8106e4f4
(native_write_msr+0x4/0x20)
[117248.089957] Call Trace:
[117248.092685]  intel_pmu_pebs_enable_all+0x31/0x40
[117248.097737]  intel_pmu_enable_all+0xa/0x10
[117248.102210]  __perf_event_task_sched_in+0x2df/0x2f0
[117248.107511]  finish_task_switch.isra.0+0x15f/0x280
[117248.112765]  schedule_tail+0xc/0x40
[117248.116562]  ret_from_fork+0x8/0x30

A fake event called VLBR_EVENT may use the bit 58 of the PEBS_ENABLE, if
the precise_ip is set. The bit 58 is reserved by the HW. Accessing the
bit causes the unchecked MSR access error.

The fake event doesn't support PEBS. The case should be rejected.

Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1615555298-140216-2-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3562,6 +3562,9 @@ static int intel_pmu_hw_config(struct pe
 		return ret;
 
 	if (event->attr.precise_ip) {
+		if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == INTEL_FIXED_VLBR_EVENT)
+			return -EINVAL;
+
 		if (!(event->attr.freq || (event->attr.wakeup_events && !event->attr.watermark))) {
 			event->hw.flags |= PERF_X86_EVENT_AUTO_RELOAD;
 			if (!(event->attr.sample_type &


