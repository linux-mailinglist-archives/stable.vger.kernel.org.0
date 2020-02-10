Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4184D157594
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgBJMmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbgBJMmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:09 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B6920838;
        Mon, 10 Feb 2020 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338529;
        bh=HB9ioouNhbX6196OJdVU2ZW4/5eaAJ436PT5UzGI+M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2elRb+Dp13hdHaNLFjkZ2mWg7jDNPmxwDvbjXyA5BGy5jncFL8qo6CqjuSPw8tM+
         5vJmt3g4mpcBr0LnP1qgpp/2pdl1qEaVWWPfkE16jKxOs5EJ+71O3fKWsuGDI7n+nP
         o4X+mY2ZHAirsKlt60O+LH4KnB0Nh6HU5dZo8vHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.5 352/367] perf/cgroups: Install cgroup events to correct cpuctx
Date:   Mon, 10 Feb 2020 04:34:25 -0800
Message-Id: <20200210122454.998214951@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 07c5972951f088094776038006a0592a46d14bbc upstream.

cgroup events are always installed in the cpuctx. However, when it is not
installed via IPI, list_update_cgroup_event() adds it to cpuctx of current
CPU, which triggers list corruption:

  [] list_add double add: new=ffff888ff7cf0db0, prev=ffff888ff7ce82f0, next=ffff888ff7cf0db0.

To reproduce this, we can simply run:

  # perf stat -e cs -a &
  # perf stat -e cs -G anycgroup

Fix this by installing it to cpuctx that contains event->ctx, and the
proper cgrp_cpuctx_list.

Fixes: db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200122195027.2112449-1-songliubraving@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -951,9 +951,9 @@ list_update_cgroup_event(struct perf_eve
 
 	/*
 	 * Because cgroup events are always per-cpu events,
-	 * this will always be called from the right CPU.
+	 * @ctx == &cpuctx->ctx.
 	 */
-	cpuctx = __get_cpu_context(ctx);
+	cpuctx = container_of(ctx, struct perf_cpu_context, ctx);
 
 	/*
 	 * Since setting cpuctx->cgrp is conditional on the current @cgrp
@@ -979,7 +979,8 @@ list_update_cgroup_event(struct perf_eve
 
 	cpuctx_entry = &cpuctx->cgrp_cpuctx_entry;
 	if (add)
-		list_add(cpuctx_entry, this_cpu_ptr(&cgrp_cpuctx_list));
+		list_add(cpuctx_entry,
+			 per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
 	else
 		list_del(cpuctx_entry);
 }


