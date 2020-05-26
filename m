Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CAB1BFCF4
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgD3OJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbgD3Nvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E7E62137B;
        Thu, 30 Apr 2020 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254710;
        bh=f3rOv7jXSBRKwhcH/xi8Az3LAJfn4iVHQU1B6aVHB9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IY30U2oh9MrEZihzty+OrwogRcmoRZkLZZbMnPCctwIStG6MhnEq9U8n73kr1MXOT
         4Wjq5UcsigCa0i2LIclqkeHrHVdeBKV/7Ac1mvw5EIaGVE9anC17HS2eW0Fi+HXYCe
         ZJ8ENhDd79MniQtOxVjRoJ1666GADxsOmqKl0Rtg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 58/79] blk-iocost: Fix error on iocost_ioc_vrate_adj
Date:   Thu, 30 Apr 2020 09:50:22 -0400
Message-Id: <20200430135043.19851-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit d6c8e949a35d6906d6c03a50e9a9cdf4e494528a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c            | 4 ++--
 include/trace/events/iocost.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 9a599cc28c290..2dc5dc54e257f 100644
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
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index 7ecaa65b7106e..c2f580fd371b1 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -130,7 +130,7 @@ DEFINE_EVENT(iocg_inuse_update, iocost_inuse_reset,
 
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
-- 
2.20.1

