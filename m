Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD791C147A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgEANjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731219AbgEANjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E05208DB;
        Fri,  1 May 2020 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340386;
        bh=ldTvqhRkqM+nR/J0XJ6ZzNqIValUnJ/esBZKHmivZsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMNr9Q/P0a6s/MBcPThGlA1G3qBOlV0ygPfehE8WP43Co90zrD2R4SXnuRK02fbMp
         eB0p6zoc2/3qy2D9ciaNdqfX4Wk19GdL0GkFieEzFdeNZzCzALGaGcNZzu+cjG4Y+2
         WSW29VrMcJ8+pqAiaygI0w/J1kzOUi2y3k1z3i+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 45/83] blk-iocost: Fix error on iocost_ioc_vrate_adj
Date:   Fri,  1 May 2020 15:23:24 +0200
Message-Id: <20200501131536.767658378@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit d6c8e949a35d6906d6c03a50e9a9cdf4e494528a upstream.

Systemtap 4.2 is unable to correctly interpret the "u32 (*missed_ppm)[2]"
argument of the iocost_ioc_vrate_adj trace entry defined in
include/trace/events/iocost.h leading to the following error:

  /tmp/stapAcz0G0/stap_c89c58b83cea1724e26395efa9ed4939_6321_aux_6.c:78:8:
  error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
   , u32[]* __tracepoint_arg_missed_ppm

That argument type is indeed rather complex and hard to read. Looking
at block/blk-iocost.c. It is just a 2-entry u32 array. By simplifying
the argument to a simple "u32 *missed_ppm" and adjusting the trace
entry accordingly, the compilation error was gone.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iocost.c            |    4 ++--
 include/trace/events/iocost.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1594,7 +1594,7 @@ skip_surplus_transfers:
 				      vrate_min, vrate_max);
 		}
 
-		trace_iocost_ioc_vrate_adj(ioc, vrate, &missed_ppm, rq_wait_pct,
+		trace_iocost_ioc_vrate_adj(ioc, vrate, missed_ppm, rq_wait_pct,
 					   nr_lagging, nr_shortages,
 					   nr_surpluses);
 
@@ -1603,7 +1603,7 @@ skip_surplus_transfers:
 			ioc->period_us * vrate * INUSE_MARGIN_PCT, 100);
 	} else if (ioc->busy_level != prev_busy_level || nr_lagging) {
 		trace_iocost_ioc_vrate_adj(ioc, atomic64_read(&ioc->vtime_rate),
-					   &missed_ppm, rq_wait_pct, nr_lagging,
+					   missed_ppm, rq_wait_pct, nr_lagging,
 					   nr_shortages, nr_surpluses);
 	}
 
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -130,7 +130,7 @@ DEFINE_EVENT(iocg_inuse_update, iocost_i
 
 TRACE_EVENT(iocost_ioc_vrate_adj,
 
-	TP_PROTO(struct ioc *ioc, u64 new_vrate, u32 (*missed_ppm)[2],
+	TP_PROTO(struct ioc *ioc, u64 new_vrate, u32 *missed_ppm,
 		u32 rq_wait_pct, int nr_lagging, int nr_shortages,
 		int nr_surpluses),
 
@@ -155,8 +155,8 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 		__entry->old_vrate = atomic64_read(&ioc->vtime_rate);;
 		__entry->new_vrate = new_vrate;
 		__entry->busy_level = ioc->busy_level;
-		__entry->read_missed_ppm = (*missed_ppm)[READ];
-		__entry->write_missed_ppm = (*missed_ppm)[WRITE];
+		__entry->read_missed_ppm = missed_ppm[READ];
+		__entry->write_missed_ppm = missed_ppm[WRITE];
 		__entry->rq_wait_pct = rq_wait_pct;
 		__entry->nr_lagging = nr_lagging;
 		__entry->nr_shortages = nr_shortages;


