Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0776E6CC39F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjC1Ozu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjC1Ozt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B15BDBE6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07E71617E5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E356C433EF;
        Tue, 28 Mar 2023 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015347;
        bh=OaLfNVnSKxJGTvMM1xZVmH7wGbNtgiQQwms+TJS9bLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlAeO53sK6UQllsMrcoyjOhLyfUcPGxnm3l6oPDyWQHeGDpvAfAAAPYXYc2OEodw8
         b33OorvmWfO1aQoaUr+OULRNNXhbhgGA5tLonqeEnrUIEy0IeBFmAEMkk47/Lg+yKw
         b1aGsfDNkSC22wJE7EDavCS6IM49+3sg+Xg1oFOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/224] tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr
Date:   Tue, 28 Mar 2023 16:40:02 +0200
Message-Id: <20230328142617.483316221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Costa Shulyupin <costa.shul@redhat.com>

[ Upstream commit 71c7a30442b724717a30d5e7d1662ba4904eb3d4 ]

There is a problem with the behavior of hwlat in a container,
resulting in incorrect output. A warning message is generated:
"cpumask changed while in round-robin mode, switching to mode none",
and the tracing_cpumask is ignored. This issue arises because
the kernel thread, hwlatd, is not a part of the container, and
the function sched_setaffinity is unable to locate it using its PID.
Additionally, the task_struct of hwlatd is already known.
Ultimately, the function set_cpus_allowed_ptr achieves
the same outcome as sched_setaffinity, but employs task_struct
instead of PID.

Test case:

  # cd /sys/kernel/tracing
  # echo 0 > tracing_on
  # echo round-robin > hwlat_detector/mode
  # echo hwlat > current_tracer
  # unshare --fork --pid bash -c 'echo 1 > tracing_on'
  # dmesg -c

Actual behavior:

[573502.809060] hwlat_detector: cpumask changed while in round-robin mode, switching to mode none

Link: https://lore.kernel.org/linux-trace-kernel/20230316144535.1004952-1-costa.shul@redhat.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 0330f7aa8ee63 ("tracing: Have hwlat trace migrate across tracing_cpumask CPUs")
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index c4945f8adc119..2f37a6e68aa9f 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -339,7 +339,7 @@ static void move_to_next_cpu(void)
 	cpumask_clear(current_mask);
 	cpumask_set_cpu(next_cpu, current_mask);
 
-	sched_setaffinity(0, current_mask);
+	set_cpus_allowed_ptr(current, current_mask);
 	return;
 
  change_mode:
@@ -446,7 +446,7 @@ static int start_single_kthread(struct trace_array *tr)
 
 	}
 
-	sched_setaffinity(kthread->pid, current_mask);
+	set_cpus_allowed_ptr(kthread, current_mask);
 
 	kdata->kthread = kthread;
 	wake_up_process(kthread);
-- 
2.39.2



