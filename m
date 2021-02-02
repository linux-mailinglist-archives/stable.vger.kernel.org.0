Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3F130CE60
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhBBWC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234431AbhBBWCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:02:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 884ED64FAA;
        Tue,  2 Feb 2021 22:01:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l73jd-00970K-Hm; Tue, 02 Feb 2021 17:01:21 -0500
Message-ID: <20210202220121.435051654@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 16:59:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [for-linus][PATCH 5/5] tracepoint: Fix race between tracing and removing tracepoint
References: <20210202215949.848582355@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

When executing a tracepoint, the tracepoint's func is dereferenced twice -
in __DO_TRACE() (where the returned pointer is checked) and later on in
__traceiter_##_name where the returned pointer is dereferenced without
checking which leads to races against tracepoint_removal_sync() and
crashes.

This adds a check before referencing the pointer in tracepoint_ptr_deref.

Link: https://lkml.kernel.org/r/20210202072326.120557-1-aik@ozlabs.ru

Cc: stable@vger.kernel.org
Fixes: d25e37d89dd2f ("tracepoint: Optimize using static_call()")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 0f21617f1a66..966ed8980327 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -307,11 +307,13 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 									\
 		it_func_ptr =						\
 			rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
-		do {							\
-			it_func = (it_func_ptr)->func;			\
-			__data = (it_func_ptr)->data;			\
-			((void(*)(void *, proto))(it_func))(__data, args); \
-		} while ((++it_func_ptr)->func);			\
+		if (it_func_ptr) {					\
+			do {						\
+				it_func = (it_func_ptr)->func;		\
+				__data = (it_func_ptr)->data;		\
+				((void(*)(void *, proto))(it_func))(__data, args); \
+			} while ((++it_func_ptr)->func);		\
+		}							\
 		return 0;						\
 	}								\
 	DEFINE_STATIC_CALL(tp_func_##_name, __traceiter_##_name);
-- 
2.29.2


