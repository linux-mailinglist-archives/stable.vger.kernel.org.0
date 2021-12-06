Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2ED46AA34
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351330AbhLFVYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:24:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59580 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351351AbhLFVXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 285FEB81084;
        Mon,  6 Dec 2021 21:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DD4C341C6;
        Mon,  6 Dec 2021 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825621;
        bh=ZvYgMm7di0ztR3KRZHr5r9hkEXZX4IXsy5TpIK/+AIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvLNhSKIQ2EwGgzTM2NNU5mBpzbXVhuKs0qBQqG6Lo4044tZzZnfTsBon1u5w79MB
         ozrdWVcaNgcBWCaamnawI7kYIKH6mfG4c9UsQepdM8DLxmDsPuLBUv3WEM6i69v+Th
         oIGlx8mtI5iOekTlhpAhUrz8GbrkOWfyAQ2ww3o/78rvQubhBZiWzM4+GSCV4Pv1px
         JUmbR4YN5mGAiGITnmzZ8+K5rM2JW+F1dWmr7EEzgWUIMExbiGZINkZbpOrED1AtXY
         of2rgdkFah2c9DO2VrCDQkuxWScWvxcGBTUkT6IcOf8teg+gRdBziVciLuOIrfpsd5
         UHiRlfH05bxzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Jun <chenjun102@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.14 6/6] tracing: Fix a kmemleak false positive in tracing_map
Date:   Mon,  6 Dec 2021 16:20:02 -0500
Message-Id: <20211206212004.1661417-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206212004.1661417-1-sashal@kernel.org>
References: <20211206212004.1661417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit f25667e5980a4333729cac3101e5de1bb851f71a ]

Doing the command:
  echo 'hist:key=common_pid.execname,common_timestamp' > /sys/kernel/debug/tracing/events/xxx/trigger

Triggers many kmemleak reports:

unreferenced object 0xffff0000c7ea4980 (size 128):
  comm "bash", pid 338, jiffies 4294912626 (age 9339.324s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f3469921>] kmem_cache_alloc_trace+0x4c0/0x6f0
    [<0000000054ca40c3>] hist_trigger_elt_data_alloc+0x140/0x178
    [<00000000633bd154>] tracing_map_init+0x1f8/0x268
    [<000000007e814ab9>] event_hist_trigger_func+0xca0/0x1ad0
    [<00000000bf8520ed>] trigger_process_regex+0xd4/0x128
    [<00000000f549355a>] event_trigger_write+0x7c/0x120
    [<00000000b80f898d>] vfs_write+0xc4/0x380
    [<00000000823e1055>] ksys_write+0x74/0xf8
    [<000000008a9374aa>] __arm64_sys_write+0x24/0x30
    [<0000000087124017>] do_el0_svc+0x88/0x1c0
    [<00000000efd0dcd1>] el0_svc+0x1c/0x28
    [<00000000dbfba9b3>] el0_sync_handler+0x88/0xc0
    [<00000000e7399680>] el0_sync+0x148/0x180
unreferenced object 0xffff0000c7ea4980 (size 128):
  comm "bash", pid 338, jiffies 4294912626 (age 9339.324s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f3469921>] kmem_cache_alloc_trace+0x4c0/0x6f0
    [<0000000054ca40c3>] hist_trigger_elt_data_alloc+0x140/0x178
    [<00000000633bd154>] tracing_map_init+0x1f8/0x268
    [<000000007e814ab9>] event_hist_trigger_func+0xca0/0x1ad0
    [<00000000bf8520ed>] trigger_process_regex+0xd4/0x128
    [<00000000f549355a>] event_trigger_write+0x7c/0x120
    [<00000000b80f898d>] vfs_write+0xc4/0x380
    [<00000000823e1055>] ksys_write+0x74/0xf8
    [<000000008a9374aa>] __arm64_sys_write+0x24/0x30
    [<0000000087124017>] do_el0_svc+0x88/0x1c0
    [<00000000efd0dcd1>] el0_svc+0x1c/0x28
    [<00000000dbfba9b3>] el0_sync_handler+0x88/0xc0
    [<00000000e7399680>] el0_sync+0x148/0x180

The reason is elts->pages[i] is alloced by get_zeroed_page.
and kmemleak will not scan the area alloced by get_zeroed_page.
The address stored in elts->pages will be regarded as leaked.

That is, the elts->pages[i] will have pointers loaded onto it as well, and
without telling kmemleak about it, those pointers will look like memory
without a reference.

To fix this, call kmemleak_alloc to tell kmemleak to scan elts->pages[i]

Link: https://lkml.kernel.org/r/20211124140801.87121-1-chenjun102@huawei.com

Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/tracing_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 379db35838b64..572c0854d631c 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -24,6 +24,7 @@
 #include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
+#include <linux/kmemleak.h>
 
 #include "tracing_map.h"
 #include "trace.h"
@@ -227,6 +228,7 @@ void tracing_map_array_free(struct tracing_map_array *a)
 	for (i = 0; i < a->n_pages; i++) {
 		if (!a->pages[i])
 			break;
+		kmemleak_free(a->pages[i]);
 		free_page((unsigned long)a->pages[i]);
 	}
 
@@ -262,6 +264,7 @@ struct tracing_map_array *tracing_map_array_alloc(unsigned int n_elts,
 		a->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!a->pages[i])
 			goto free;
+		kmemleak_alloc(a->pages[i], PAGE_SIZE, 1, GFP_KERNEL);
 	}
  out:
 	return a;
-- 
2.33.0

