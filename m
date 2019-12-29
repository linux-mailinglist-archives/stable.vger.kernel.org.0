Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8365712C7B4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfL2Rpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbfL2Rpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7E8206A4;
        Sun, 29 Dec 2019 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641545;
        bh=K9QFq+c8GqpHyIIbuhqi4vkeOg9dl6bOL2jocsocoCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4F4JiR7EZAzN5w9pE2Vrhb7vS3XrLLhYheFXbsGo0Z2K22EtJGvx06ZlEnuSvu2n
         fC4WuZQDJoHRpNR7cCi3cIZy6bx9wQbLLmkdrwFLcaSCsdMUZQ/DJLr4qb/CeQB+3T
         2TliU7NR6NwbdLUBEIn60y8OtEpdIJ7nk4N48SdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/434] block: Fix writeback throttling W=1 compiler warnings
Date:   Sun, 29 Dec 2019 18:22:44 +0100
Message-Id: <20191229172709.026967003@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1d200e9d6f635ae894993a7d0f1b9e0b6e522e3b ]

Fix the following compiler warnings:

In file included from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:21,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:38,
                 from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:51,
                 from ./include/linux/mmzone.h:8,
                 from ./include/linux/gfp.h:6,
                 from ./include/linux/mm.h:10,
                 from ./include/linux/bvec.h:13,
                 from ./include/linux/blk_types.h:10,
                 from block/blk-wbt.c:23:
In function 'strncpy',
    inlined from 'perf_trace_wbt_stat' at ./include/trace/events/wbt.h:15:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'perf_trace_wbt_lat' at ./include/trace/events/wbt.h:58:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'perf_trace_wbt_step' at ./include/trace/events/wbt.h:87:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'perf_trace_wbt_timer' at ./include/trace/events/wbt.h:126:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'trace_event_raw_event_wbt_stat' at ./include/trace/events/wbt.h:15:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'trace_event_raw_event_wbt_lat' at ./include/trace/events/wbt.h:58:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'trace_event_raw_event_wbt_timer' at ./include/trace/events/wbt.h:126:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'trace_event_raw_event_wbt_step' at ./include/trace/events/wbt.h:87:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: e34cbd307477 ("blk-wbt: add general throttling mechanism"; v4.10).
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/wbt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/wbt.h b/include/trace/events/wbt.h
index b048694070e2..37342a13c9cb 100644
--- a/include/trace/events/wbt.h
+++ b/include/trace/events/wbt.h
@@ -33,7 +33,8 @@ TRACE_EVENT(wbt_stat,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strlcpy(__entry->name, dev_name(bdi->dev),
+			ARRAY_SIZE(__entry->name));
 		__entry->rmean		= stat[0].mean;
 		__entry->rmin		= stat[0].min;
 		__entry->rmax		= stat[0].max;
@@ -67,7 +68,8 @@ TRACE_EVENT(wbt_lat,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strlcpy(__entry->name, dev_name(bdi->dev),
+			ARRAY_SIZE(__entry->name));
 		__entry->lat = div_u64(lat, 1000);
 	),
 
@@ -103,7 +105,8 @@ TRACE_EVENT(wbt_step,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strlcpy(__entry->name, dev_name(bdi->dev),
+			ARRAY_SIZE(__entry->name));
 		__entry->msg	= msg;
 		__entry->step	= step;
 		__entry->window	= div_u64(window, 1000);
@@ -138,7 +141,8 @@ TRACE_EVENT(wbt_timer,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strlcpy(__entry->name, dev_name(bdi->dev),
+			ARRAY_SIZE(__entry->name));
 		__entry->status		= status;
 		__entry->step		= step;
 		__entry->inflight	= inflight;
-- 
2.20.1



