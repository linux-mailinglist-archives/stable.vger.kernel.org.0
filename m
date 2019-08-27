Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4739E0AB
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfH0IEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbfH0IET (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB1E2173E;
        Tue, 27 Aug 2019 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893058;
        bh=kVoyUutgMOlCeL9jhsRtB04HQpHiX0knf6bLXhJU3As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vomnnGGZTPuzlE6H8hvVkKj/1Eq0bHMAKgud/i1xTEZWVufcVAn6pi0zDwMIlCbF
         RXvnV+3gMta+Yol5UQlRugWsPJs/qPvvI8s5R75LOeev4ryZwzwwnQfDAcAZLLzr1A
         6Wy9rvi2upqYfYXjrWbKZXnE8E019tShakYIao5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 064/162] perf bench numa: Fix cpu0 binding
Date:   Tue, 27 Aug 2019 09:49:52 +0200
Message-Id: <20190827072740.388884760@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6bbfe4e602691b90ac866712bd4c43c51e546a60 ]

Michael reported an issue with perf bench numa failing with binding to
cpu0 with '-0' option.

  # perf bench numa mem -p 3 -t 1 -P 512 -s 100 -zZcm0 --thp 1 -M 1 -ddd
  # Running 'numa/mem' benchmark:

   # Running main, "perf bench numa numa-mem -p 3 -t 1 -P 512 -s 100 -zZcm0 --thp 1 -M 1 -ddd"
  binding to node 0, mask: 0000000000000001 => -1
  perf: bench/numa.c:356: bind_to_memnode: Assertion `!(ret)' failed.
  Aborted (core dumped)

This happens when the cpu0 is not part of node0, which is the benchmark
assumption and we can see that's not the case for some powerpc servers.

Using correct node for cpu0 binding.

Reported-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20190801142642.28004-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/numa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index a7784554a80de..23c27ca48abf3 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -379,8 +379,10 @@ static u8 *alloc_data(ssize_t bytes0, int map_flags,
 
 	/* Allocate and initialize all memory on CPU#0: */
 	if (init_cpu0) {
-		orig_mask = bind_to_node(0);
-		bind_to_memnode(0);
+		int node = numa_node_of_cpu(0);
+
+		orig_mask = bind_to_node(node);
+		bind_to_memnode(node);
 	}
 
 	bytes = bytes0 + HPSIZE;
-- 
2.20.1



