Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7322D6CC4A7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjC1PHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjC1PHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA0AD520
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E89061857
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBA1C4339C;
        Tue, 28 Mar 2023 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015952;
        bh=nOai4my4CkFgclSU7YAKhG/cMS9uXMRuAyvl2wCF208=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gT47i92ZeqX8FEB0AP7MfxPlvqkYmcOpqbvja3QjHoxUx9cxp9gtYXcROpeCZhhc
         qHZPhUO0rIqPEca2SX7uqaSd4MA+zxRBhaNTBwg9v+H98Aht8w637YLPLM84AWigVt
         qa+WXFc28RJxFq1WWFnEQxfSBFdKlVr90dFuhNhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tero Kristo <tero.kristo@linux.intel.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/146] trace/hwlat: Do not start per-cpu thread if it is already running
Date:   Tue, 28 Mar 2023 16:41:41 +0200
Message-Id: <20230328142603.220384449@linuxfoundation.org>
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

From: Tero Kristo <tero.kristo@linux.intel.com>

[ Upstream commit 08697bca9bbba15f2058fdbd9f970bd5f6a8a2e8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 72eeab938f1de..9ec032f22531c 100644
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
-- 
2.39.2



