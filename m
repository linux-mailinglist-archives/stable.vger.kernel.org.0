Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08C1B41D3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgDVKGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgDVKGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28012075A;
        Wed, 22 Apr 2020 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549979;
        bh=KiFsFr2EzdVONAVMzvEkRR/zXd7M6X6aoyMeRIbSy6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBgrccVsNUevwLmeu9ApwnymRABY+ZBq+u264gfPpbswAW4/hz6yCqNsL0eISOTM5
         IE512mngmHsP2sY3EFPEr1inbOlBi6+y/akRDu3fELjzefuq3ao8d8wCjFDt6ZB8bw
         uAG1mRnQLnpaWxLJFU+T2Y+zN1hsM6+sT+ugdz/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 084/125] tracing: Fix the race between registering snapshot event trigger and triggering snapshot operation
Date:   Wed, 22 Apr 2020 11:56:41 +0200
Message-Id: <20200422095046.631782623@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@cn.fujitsu.com>

commit 0bbe7f719985efd9adb3454679ecef0984cb6800 upstream.

Traced event can trigger 'snapshot' operation(i.e. calls snapshot_trigger()
or snapshot_count_trigger()) when register_snapshot_trigger() has completed
registration but doesn't allocate buffer for 'snapshot' event trigger.  In
the rare case, 'snapshot' operation always detects the lack of allocated
buffer so make register_snapshot_trigger() allocate buffer first.

trigger-snapshot.tc in kselftest reproduces the issue on slow vm:
-----------------------------------------------------------
cat trace
...
ftracetest-3028  [002] ....   236.784290: sched_process_fork: comm=ftracetest pid=3028 child_comm=ftracetest child_pid=3036
     <...>-2875  [003] ....   240.460335: tracing_snapshot_instance_cond: *** SNAPSHOT NOT ALLOCATED ***
     <...>-2875  [003] ....   240.460338: tracing_snapshot_instance_cond: *** stopping trace here!   ***
-----------------------------------------------------------

Link: http://lkml.kernel.org/r/20200414015145.66236-1-yangx.jy@cn.fujitsu.com

Cc: stable@vger.kernel.org
Fixes: 93e31ffbf417a ("tracing: Add 'snapshot' event trigger command")
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_trigger.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1068,14 +1068,10 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	int ret = register_trigger(glob, ops, data, file);
+	if (tracing_alloc_snapshot() != 0)
+		return 0;
 
-	if (ret > 0 && tracing_alloc_snapshot() != 0) {
-		unregister_trigger(glob, ops, data, file);
-		ret = 0;
-	}
-
-	return ret;
+	return register_trigger(glob, ops, data, file);
 }
 
 static int


