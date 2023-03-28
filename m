Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530BA6CC4BE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjC1PIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbjC1PIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734FAD338
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A6B6182A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4254FC433D2;
        Tue, 28 Mar 2023 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016005;
        bh=dHr6kwbnDPPOkOsMXQVKrxEIkV8xCxSufrQollMViB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsJXPFyMR6CY3Rrlp6SUJy2EUBGwRyBY4utUg/sTplUsZPPK1zXQXA1d7Um3lhWum
         Cb+BzjbHTBp3zo25nizNGBOmbVWFdVc/cWToLANerfh+Ts+R8ERbiME0giYIZ7mcGb
         Wb/uOUayI42EJ1QyMqt1Gp1TAW7uBx6L8v1pJb0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/146] tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr
Date:   Tue, 28 Mar 2023 16:41:33 +0200
Message-Id: <20230328142602.850069548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 11f32e947c452..455f5edf008b8 100644
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



