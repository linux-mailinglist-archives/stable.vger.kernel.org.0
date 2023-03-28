Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066046CC4A9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbjC1PHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbjC1PHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED57ADBE1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59728B81D79
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF8BC433D2;
        Tue, 28 Mar 2023 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015950;
        bh=TDK7C4tBc1XL02w3YdJ1crK36dwWk55XRLALtQ6RWm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUdElOrIchfJ3wMre3O9CNbjKbGNTltks25tJ64rY/B3HScebnRA9UP2rqQK27ORd
         xd8HfY/MqzOsfek9LdWnFKK/ZPGq251VsdvbK0/BCdQJDGXwJl9aeWGi5W/MgOELnX
         T2YcQ7sCva573HBnUKkcvO1qFljT00TMJVEZIEUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cai Huoqing <caihuoqing@baidu.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Doug Ledford <dledford@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/146] trace/hwlat: make use of the helper function kthread_run_on_cpu()
Date:   Tue, 28 Mar 2023 16:41:40 +0200
Message-Id: <20230328142603.170881386@linuxfoundation.org>
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

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit ff78f6679d2e223e073fcbdc8f70b6bc0abadf99 ]

Replace kthread_create_on_cpu/wake_up_process() with kthread_run_on_cpu()
to simplify the code.

Link: https://lkml.kernel.org/r/20211022025711.3673-7-caihuoqing@baidu.com
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 08697bca9bbb ("trace/hwlat: Do not start per-cpu thread if it is already running")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 455f5edf008b8..72eeab938f1de 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -491,18 +491,14 @@ static void stop_per_cpu_kthreads(void)
 static int start_cpu_kthread(unsigned int cpu)
 {
 	struct task_struct *kthread;
-	char comm[24];
 
-	snprintf(comm, 24, "hwlatd/%d", cpu);
-
-	kthread = kthread_create_on_cpu(kthread_fn, NULL, cpu, comm);
+	kthread = kthread_run_on_cpu(kthread_fn, NULL, cpu, "hwlatd/%u");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
 		return -ENOMEM;
 	}
 
 	per_cpu(hwlat_per_cpu_data, cpu).kthread = kthread;
-	wake_up_process(kthread);
 
 	return 0;
 }
-- 
2.39.2



