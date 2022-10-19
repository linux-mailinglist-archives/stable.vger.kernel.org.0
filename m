Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE1E603F54
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiJSJbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiJSJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C26C58BE;
        Wed, 19 Oct 2022 02:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CEC661886;
        Wed, 19 Oct 2022 09:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405E4C43144;
        Wed, 19 Oct 2022 09:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170496;
        bh=CM0lsX2xNuDhqw6knoqtt6uLkfZ93Q02MCIk5faF5dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jK84knL91kszEr50fLxA3xwU0z4n7zg4kM9luGiCByChmSXXjsWMmAdjlqFYLhSiQ
         leeWYjYcx19R3AepVzsLENSzb0igJ8JUsa1li2D/jO4GVGlnjvgSpYQ5Pywdde4a0s
         Xxgq2ObgCazgC+eYiksLYeSrY8lF6m6nN5CN9n10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nico Pache <npache@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 645/862] tracing/osnoise: Fix possible recursive locking in stop_per_cpu_kthreads
Date:   Wed, 19 Oct 2022 10:32:12 +0200
Message-Id: <20221019083318.425224404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Pache <npache@redhat.com>

[ Upstream commit 99ee9317a1305cd5626736785c8cb38b0e47686c ]

There is a recursive lock on the cpu_hotplug_lock.

In kernel/trace/trace_osnoise.c:<start/stop>_per_cpu_kthreads:
    - start_per_cpu_kthreads calls cpus_read_lock() and if
	start_kthreads returns a error it will call stop_per_cpu_kthreads.
    - stop_per_cpu_kthreads then calls cpus_read_lock() again causing
      deadlock.

Fix this by calling cpus_read_unlock() before calling
stop_per_cpu_kthreads. This behavior can also be seen in commit
f46b16520a08 ("trace/hwlat: Implement the per-cpu mode").

This error was noticed during the LTP ftrace-stress-test:

WARNING: possible recursive locking detected
--------------------------------------------
sh/275006 is trying to acquire lock:
ffffffffb02f5400 (cpu_hotplug_lock){++++}-{0:0}, at: stop_per_cpu_kthreads

but task is already holding lock:
ffffffffb02f5400 (cpu_hotplug_lock){++++}-{0:0}, at: start_per_cpu_kthreads

other info that might help us debug this:
 Possible unsafe locking scenario:

      CPU0
      ----
 lock(cpu_hotplug_lock);
 lock(cpu_hotplug_lock);

 *** DEADLOCK ***

May be due to missing lock nesting notation

3 locks held by sh/275006:
 #0: ffff8881023f0470 (sb_writers#24){.+.+}-{0:0}, at: ksys_write
 #1: ffffffffb084f430 (trace_types_lock){+.+.}-{3:3}, at: rb_simple_write
 #2: ffffffffb02f5400 (cpu_hotplug_lock){++++}-{0:0}, at: start_per_cpu_kthreads

Link: https://lkml.kernel.org/r/20220919144932.3064014-1-npache@redhat.com

Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 313439920a8c..78d536d3ff3d 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1786,8 +1786,9 @@ static int start_per_cpu_kthreads(void)
 	for_each_cpu(cpu, current_mask) {
 		retval = start_kthread(cpu);
 		if (retval) {
+			cpus_read_unlock();
 			stop_per_cpu_kthreads();
-			break;
+			return retval;
 		}
 	}
 
-- 
2.35.1



