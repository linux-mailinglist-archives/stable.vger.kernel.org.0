Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FBF3137DD
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhBHPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhBHP2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FD864F29;
        Mon,  8 Feb 2021 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797383;
        bh=GvqqoWao7hO7q+LY/d2qHs0yxYIaYkFr6SFinrGiJdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+M6uY0XagjemobvVjUO7H3eJajpkEf6dHOru0i7E8sBdCPx38C3dIKhe1A7iDLZg
         Q7ZqWGiIyJyC79hfpHLAEfVbDeLhW8ejHoo3bavnf1BUYtnZjuQtmU6T18vtOpC7dz
         QKzd94kdzrC3gj/wlznDUke5+mVmp3Ytt81FMl74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 063/120] tracepoint: Fix race between tracing and removing tracepoint
Date:   Mon,  8 Feb 2021 16:00:50 +0100
Message-Id: <20210208145820.945240185@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit c8b186a8d54d7e12d28e9f9686cb00ff18fc2ab2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tracepoint.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -307,11 +307,13 @@ static inline struct tracepoint *tracepo
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


