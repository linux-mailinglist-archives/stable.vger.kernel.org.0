Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20485119949
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfLJVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfLJVdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE99E207FF;
        Tue, 10 Dec 2019 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013583;
        bh=p5Ji009ZQl7sPBz9tomk2b5BFRUxQIfpJoi6Rg5HaJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tokELLiAfeNeCoT/ymf6x+bdlnGA9h7g47YUkcFqmtfjQDqbO9J5EaRH/8DdNw2ko
         EGVwNm06bC0moI6ppAeiJ4PhsGY1Ux6oBTurEPhxB9hEumEj3Sg/iMddnDiHWgz1O4
         GyGxPC5+HJm+SR5uoFaU5zTIh7oNqZ+6QWAWeJsU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 035/177] block: Fix writeback throttling W=1 compiler warnings
Date:   Tue, 10 Dec 2019 16:29:59 -0500
Message-Id: <20191210213221.11921-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b048694070e2c..37342a13c9cb9 100644
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

