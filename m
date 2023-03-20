Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D26C1122
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjCTLsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCTLso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6C91588F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 580C86148A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CDBC433EF;
        Mon, 20 Mar 2023 11:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679312922;
        bh=wYeP0xRZaYl0VrjJghbv7YIjc//kQmN/mc5R4CD+8To=;
        h=Subject:To:Cc:From:Date:From;
        b=N1i26ci5zZkVr+RHJAizEjxGtwcny7J+K1RN5bHKbAgDulSfvOQt2HbB9jbqP15Is
         7YAEfTwIwim1t/m/f/Tyf0zKKCU8u51uC52edhxd/qZ9ulibD6OkFZ3l51Buko1WQ4
         MVT/ssBmTbDg19MisTIJRA4y7zSAYDz1zXmNjMsU=
Subject: FAILED: patch "[PATCH] trace/hwlat: Do not start per-cpu thread if it is already" failed to apply to 5.15-stable tree
To:     tero.kristo@linux.intel.com, bristot@kernel.org,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 12:48:39 +0100
Message-ID: <167931291995243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 08697bca9bbba15f2058fdbd9f970bd5f6a8a2e8
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931291995243@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

08697bca9bbb ("trace/hwlat: Do not start per-cpu thread if it is already running")
ff78f6679d2e ("trace/hwlat: make use of the helper function kthread_run_on_cpu()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 08697bca9bbba15f2058fdbd9f970bd5f6a8a2e8 Mon Sep 17 00:00:00 2001
From: Tero Kristo <tero.kristo@linux.intel.com>
Date: Fri, 10 Mar 2023 12:04:51 +0200
Subject: [PATCH] trace/hwlat: Do not start per-cpu thread if it is already
 running

The hwlatd tracer will end up starting multiple per-cpu threads with
the following script:

    #!/bin/sh
    cd /sys/kernel/debug/tracing
    echo 0 > tracing_on
    echo hwlat > current_tracer
    echo per-cpu > hwlat_detector/mode
    echo 100000 > hwlat_detector/width
    echo 200000 > hwlat_detector/window
    echo 1 > tracing_on

To fix the issue, check if the hwlatd thread for the cpu is already
running, before starting a new one. Along with the previous patch, this
avoids running multiple instances of the same CPU thread on the system.

Link: https://lore.kernel.org/all/20230302113654.2984709-1-tero.kristo@linux.intel.com/
Link: https://lkml.kernel.org/r/20230310100451.3948583-3-tero.kristo@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: f46b16520a087 ("trace/hwlat: Implement the per-cpu mode")
Signed-off-by: Tero Kristo <tero.kristo@linux.intel.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index edc26dc22c3f..c4945f8adc11 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -492,6 +492,10 @@ static int start_cpu_kthread(unsigned int cpu)
 {
 	struct task_struct *kthread;
 
+	/* Do not start a new hwlatd thread if it is already running */
+	if (per_cpu(hwlat_per_cpu_data, cpu).kthread)
+		return 0;
+
 	kthread = kthread_run_on_cpu(kthread_fn, NULL, cpu, "hwlatd/%u");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");

