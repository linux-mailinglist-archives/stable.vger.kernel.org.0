Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A358B6CC287
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjC1OqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbjC1OqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FB9DBE5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7763CE1DA2
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC40C433D2;
        Tue, 28 Mar 2023 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014738;
        bh=OaLfNVnSKxJGTvMM1xZVmH7wGbNtgiQQwms+TJS9bLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arVqbKgT1IzLA2FAOTAO+Z69k4KT5DWiAneASwW5YWNVH7588xyS1vkz9po/JDRvk
         hl/BjLAN2PMiVivNpLybPiqOA9y5Yok46z684vcMJHSMFhoXnGWJKlPKreLXGgf4K4
         YSZeQ67pE+MA6GLiYQnADDRlUFxlQ9MIy41l/yOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 006/240] tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr
Date:   Tue, 28 Mar 2023 16:39:29 +0200
Message-Id: <20230328142619.914734290@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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



