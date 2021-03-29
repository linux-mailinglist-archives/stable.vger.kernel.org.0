Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5534C665
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhC2IHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhC2IGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C7206196B;
        Mon, 29 Mar 2021 08:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005170;
        bh=bioptFnmAdZ/zCalDIFArsnAR4pVdV4g21+yHhqX0PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLmt0PFM9DYSMN+JFDuuKcGxvbGGfyZJZKjEj+9KXHH88PTwIr+kXugYKerODpkBB
         /69sb/WtM3xnkjHPAb9bevM23uh4B2oQjDmOwlDyB/nlNGVIkimd6mptnQUl1cZ/Lr
         HFUP3ZpnRnXkNCXz0W+6dg6VWLx36uoRFPcaDzaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/59] perf auxtrace: Fix auxtrace queue conflict
Date:   Mon, 29 Mar 2021 09:58:30 +0200
Message-Id: <20210329075610.523221477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b410ed2a8572d41c68bd9208555610e4b07d0703 ]

The only requirement of an auxtrace queue is that the buffers are in
time order.  That is achieved by making separate queues for separate
perf buffer or AUX area buffer mmaps.

That generally means a separate queue per cpu for per-cpu contexts, and
a separate queue per thread for per-task contexts.

When buffers are added to a queue, perf checks that the buffer cpu and
thread id (tid) match the queue cpu and thread id.

However, generally, that need not be true, and perf will queue buffers
correctly anyway, so the check is not needed.

In addition, the check gets erroneously hit when using sample mode to
trace multiple threads.

Consequently, fix that case by removing the check.

Fixes: e502789302a6 ("perf auxtrace: Add helpers for queuing AUX area tracing data")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20210308151143.18338-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/auxtrace.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 44c8bcefe224..0224fc3aacc1 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -250,10 +250,6 @@ static int auxtrace_queues__add_buffer(struct auxtrace_queues *queues,
 		queue->set = true;
 		queue->tid = buffer->tid;
 		queue->cpu = buffer->cpu;
-	} else if (buffer->cpu != queue->cpu || buffer->tid != queue->tid) {
-		pr_err("auxtrace queue conflict: cpu %d, tid %d vs cpu %d, tid %d\n",
-		       queue->cpu, queue->tid, buffer->cpu, buffer->tid);
-		return -EINVAL;
 	}
 
 	buffer->buffer_nr = queues->next_buffer_nr++;
-- 
2.30.1



